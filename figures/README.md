# Figures - ICICI Bank FX Exposure Analysis

This folder contains visual outputs from the empirical study **Foreign Exchange Exposure and Market Volatility: A Multi-Currency Empirical Study of ICICI Bank (2019–2026)**.

The analysis examines the relationship between ICICI Bank's stock returns, Indian equity-market returns, and changes in selected foreign-exchange rates. It compares Western currency specifications (USD, GBP and EUR) with Asian currency specifications (AED, CNY and JPY), includes a NIFTY Bank robustness model, and investigates changes around the COVID-19 period.

## 1. Model Comparison

### `Model Comparison using AIC.jpeg`

Compares the Akaike Information Criterion (AIC) for the Asian and Western currency models.

AIC balances model fit against model complexity; a lower value is preferred when comparing models fitted to the same response and comparable observations. The displayed values are approximately −9,311 for the Asian model and −9,308 for the Western model. The difference is small, so it should not be presented as strong evidence that one specification is substantially superior.

### `Model Performance comparison.jpeg`

Compares the coefficient of determination (\(R^2\)) across three specifications:

- Western model: market returns and USD, GBP and EUR returns.
- Asian model: market returns and AED, CNY and JPY returns.
- Bank model: NIFTY Bank excess returns and USD, GBP and EUR returns.

The displayed \(R^2\) values are 0.578, 0.579 and 0.768, respectively. These describe in-sample explanatory fit and do not, on their own, establish predictive accuracy or causal relationships.

## 2. Relative Stock-Market Performance

### `Normalized performance.jpeg`

Plots the normalised performance of ICICI Bank and the NIFTY index, with both series rebased to 100 at the beginning of the displayed sample.

The dashed vertical line marks the COVID-19 market-shock reference date used in the analysis. Normalisation helps compare relative price paths, but the chart does not isolate the effect of exchange rates on ICICI Bank's share price.

## 3. Risk-Free Rate

### `Risk Free rate 91 days.jpeg`

Shows the 91-day Treasury Bill yield over the study period. The risk-free rate is used to calculate daily excess returns for the market and banking variables in the regression framework.

The yield is displayed as an annual percentage. The analysis script converts it to a daily log-rate approximation using the formula documented in the source code.

## 4. Foreign-Exchange Volatility

### `FX Volatility.jpeg`

Displays the absolute daily log returns of the EUR, GBP and USD exchange-rate series over time.

Absolute returns provide a simple view of the magnitude of daily movements, making periods of larger currency fluctuations easier to identify. They are a descriptive volatility proxy, not a formal conditional-volatility model.

`Rplot.jpeg` shows the same FX volatility visualisation and is therefore a duplicate. Only one copy is needed in the published repository.

## 5. USD and ICICI Bank Return Relationship

### `USD VS ICICI.jpeg`

Plots ICICI Bank's daily log returns against USD/INR daily log returns, together with a fitted linear trend.

The chart provides a visual inspection of the relationship between the two return series. The fitted slope is descriptive; its statistical significance and interpretation must be assessed using the regression output and diagnostic tests.

## 6. Currency Exposure Coefficients

### `FX exposure by Model.jpeg`

Compares the estimated currency-return coefficients from the Asian and Western regression specifications.

The Asian specification includes AED, CNY and JPY returns, while the Western specification includes EUR, GBP and USD returns. The plotted coefficients represent conditional relationships within each model, controlling for the other included regressors.

Coefficient signs and magnitudes should be interpreted alongside standard errors, confidence intervals, statistical significance and the model's specification.

## 7. Pre- and Post-COVID Coefficient Comparison

### `FX Exposure.jpeg`

Compares estimated EUR, GBP and USD coefficients before and after the selected COVID-period split date of 1 April 2020.

The chart is intended to show whether estimated currency-return relationships differ across the two subsamples. Differences in plotted coefficients alone do not prove a statistically significant structural break. A formal test would be needed to assess that claim.

## 8. ICICI Bank Returns and the COVID Period

### `ICICI Returns.jpeg`

Plots ICICI Bank's daily log returns and marks the selected COVID structural-break reference date.

The figure highlights the size and timing of return fluctuations around the split. The visualisation is descriptive and does not independently establish that COVID-19 caused changes in the return-generating process.

## Interpretation and Limitations

- These figures are descriptive and econometric research outputs, not investment recommendations.
- Regression coefficients represent conditional associations and should not automatically be interpreted as direct balance-sheet FX exposure.
- \(R^2\) and AIC answer different model-comparison questions and should be interpreted accordingly.
- Pre- and post-COVID comparisons require statistical testing before conclusions about structural changes are drawn.
- Results depend on the data source, return construction, risk-free-rate treatment, sample period and regression specification.

For the modelling details and underlying R implementation, refer to the repository's `R/` directory and the main README.

