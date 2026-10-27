library(dplyr)
library(lmtest)
library(ggplot2)
library(tidyr)
library(car)

data$Date <- as.Date(data$Date, format = "%d-%m-%Y")

#T-BILL (RISK-FREE RATE)
data$rf_daily <- log(1 + (data$Tbill_Yield / 100) / 252)
#converting to log returns
returns <- data %>%
  mutate(
    stock_ret = c(NA, diff(log(ICICI))),
    market_ret = c(NA, diff(log(NIFTY))),
    bank_ret = c(NA, diff(log(NIFTYBANK))),
    
    usd_ret = c(NA, diff(log(USD))),
    gbp_ret = c(NA, diff(log(GBP))),
    eur_ret = c(NA, diff(log(EUR))),
    aed_ret = c(NA, diff(log(AED))),
    cny_ret = c(NA, diff(log(CNY))),
    jpy_ret = c(NA, diff(log(JPY)))
  )
returns$Date <- data$Date

returns <- returns %>%
  mutate(
    stock_rf = stock_ret - rf_daily,
    market_rf = market_ret - rf_daily,
    bank_rf = bank_ret - rf_daily
  )
#Removing NA
returns <- na.omit(returns)

#MODEL 1: WESTERN (MAIN MODEL)
model_west <- lm(stock_rf ~ market_rf + usd_ret + gbp_ret + eur_ret, data = returns)
summary(model_west)

#MODEL 2:ASIAN (COMPARISON MODEL)
model_asia <- lm(stock_rf ~ market_rf + aed_ret + cny_ret + jpy_ret, data = returns)
summary(model_asia)

#ROBUSTNESS MODEL (NIFTY BANK)
model_bank <- lm(stock_rf ~ bank_rf + usd_ret + gbp_ret + eur_ret, data = returns)
summary(model_bank)

#DIAGNOSTIC TESTS On Main Model
vif(model_west) #Multicollinearity
bptest(model_west) #Heteroscedasticity
dwtest(model_west) #Autocorrelation

#STRUCTURAL BREAK (COVID SPLIT)
pre_covid <- returns[returns$Date < as.Date("2020-04-01"),]
post_covid <- returns[returns$Date >= as.Date("2020-04-01"),]

model_pre <- lm(stock_rf ~ market_rf + usd_ret + gbp_ret + eur_ret, data = pre_covid)
model_post <- lm(stock_rf ~ market_rf + usd_ret + gbp_ret + eur_ret, data = post_covid)

summary(model_pre)
summary(model_post)

#MODEL COMPARISON
summary(model_west)$r.squared
summary(model_asia)$r.squared
summary(model_bank)$r.squared

#USD-only vs Multi-currency Model Comparison
model_usd <- lm(stock_rf ~ market_rf + usd_ret, data = returns)
summary(model_usd)

#GRAPH 1-ICICI vs Market
data_norm <- data %>%
  mutate(
    ICICI_norm = ICICI / first(ICICI) * 100,
    NIFTY_norm = NIFTY / first(NIFTY) * 100
  )
ggplot(data_norm, aes(x = Date)) +
  geom_line(aes(y = ICICI_norm, color = "ICICI")) +
  geom_line(aes(y = NIFTY_norm, color = "NIFTY")) +
  geom_vline(xintercept = as.Date("2020-03-23"), linetype="dashed") +
  labs(title = "Normalized Performance (Base = 100)",
       y = "Index Value", color = "") +
  theme_minimal()

#GRAPH 2-Returns with COVID Break
ggplot(returns, aes(x = Date, y = stock_ret)) +
  geom_line(color = "blue") +
  geom_vline(xintercept = as.Date("2020-04-01"), 
             linetype = "dashed", color = "red") +
  geom_smooth(se = FALSE, color = "black")+
  labs(title = "ICICI Returns with COVID Structural Break",
       y = "Log Returns") +
  theme_minimal()

#GRAPH 3-FX Movements
returns %>%
  select(Date, usd_ret, gbp_ret, eur_ret) %>%
  pivot_longer(-Date, names_to = "Currency", values_to = "Return") %>%
  ggplot(aes(x = Date, y = abs(Return), color = Currency)) +
  geom_line(alpha = 0.7) +
  labs(title = "FX Volatility Over Time",
       y = "|Returns|") +
  facet_wrap(~Currency) +
  theme_minimal()

#GRAPH 4-Pre vs Post COVID Coefficients
coef_data <- data.frame(
  Variable = c("USD", "GBP", "EUR"),
  Pre = coef(model_pre)[c("usd_ret", "gbp_ret", "eur_ret")],
  Post = coef(model_post)[c("usd_ret", "gbp_ret", "eur_ret")]
)
coef_data_long <- pivot_longer(coef_data, -Variable, names_to = "Period", values_to = "Coefficient")

ggplot(coef_data_long, aes(x = Variable, y = Coefficient, fill = Period)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "FX Exposure: Pre vs Post COVID",
       y = "Coefficient Value") +
  theme_minimal()

# Graph 5-Risk-free rate over time
ggplot(data, aes(x = Date, y = Tbill_Yield)) +
  geom_line() +
  labs(title = "Risk-Free Rate (91-Day T-Bill)", 
       y = "%", 
       subtitle = "Used for excess return calculation in CAPM model") +geom_vline(xintercept = as.Date("2020-03-23"), linetype = "dashed", color = "red")+
  theme_minimal()

ggplot(returns, aes(x = usd_ret, y = stock_ret)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "USD vs ICICI Returns Relationship",
       x = "USD Returns", y = "ICICI Returns") +
  theme_minimal() ##CHATGPT Was Used for adding the value in this graph

# Model comparison dataframe
model_comp <- data.frame(
  Model = c("Bank Model", "Western Model", "Asian Model"),
  R_Squared = c(
    summary(model_bank)$r.squared,
    summary(model_west)$r.squared,
    summary(model_asia)$r.squared
  )
)

#Graph Model Comparison
ggplot(model_comp, aes(x = reorder(Model, R_Squared), y = R_Squared)) +
  geom_col(fill = "#2E86AB", width = 0.6) +
  geom_text(aes(label = round(R_Squared, 3)), vjust = -0.5, size = 4) +
  labs(title = "Model Performance Comparison (R²)",
       x = "",
       y = "R-Squared") +
  ylim(0, 0.85) +
  theme_minimal() ##CHATGPT Was Used for analysing the error in this graph

#Graph- AIC comparison
aic_values <- data.frame(
  Model = c("Western Model", "Asian Model"),
  AIC = c(AIC(model_west), AIC(model_asia))
)

ggplot(aic_values, aes(x = Model, y = AIC)) +
  geom_col(fill = "#F18F01", width = 0.6) +
  geom_text(aes(label = round(AIC, 0)), vjust = -0.5, size = 4) +
  labs(title = "Model Comparison using AIC (Lower is Better)",
       x = "",
       y = "AIC Value") +
  theme_minimal() ##CHATGPT Was Used for adding the value in this graph

# Graph-Extract coefficients
# Western
west_coef <- data.frame(
  Currency = c("USD", "GBP", "EUR"),
  Coefficient = as.numeric(coef(model_west)[c("usd_ret", "gbp_ret", "eur_ret")]),
  Model = "Western"
)
# Asian
asia_coef <- data.frame(
  Currency = c("AED", "CNY", "JPY"),
  Coefficient = as.numeric(coef(model_asia)[c("aed_ret", "cny_ret", "jpy_ret")]),
  Model = "Asian"
)
coef_data <- rbind(west_coef, asia_coef)
coef_data$Model <- as.factor(coef_data$Model)
ggplot(coef_data, aes(x = Currency, y = Coefficient, fill = Model)) +
  geom_col() +
  geom_text(aes(label = round(Coefficient, 3)), vjust = -0.5) +
  facet_wrap(~Model, scales = "free_x") +
  geom_hline(yintercept = 0) +
  labs(title = "FX Exposure by Model",
       y = "Coefficient Value") +
  theme_minimal() ##CHATGPT Was Used for debugging and adding the value in this graph
