library(quantmod)
library(dplyr)

start_date <- as.Date("2019-01-01")
end_date <- Sys.Date()

# ==============================
# CORE DATA
# ==============================

getSymbols("ICICIBANK.NS", src = "yahoo", from = start_date, to = end_date)
getSymbols("^NSEI", src = "yahoo", from = start_date, to = end_date)
getSymbols("^NSEBANK", src = "yahoo", from = start_date, to = end_date)

# ==============================
# FX DATA (DIRECT INR)
# ==============================

getSymbols("USDINR=X", src = "yahoo", from = start_date, to = end_date)
getSymbols("GBPINR=X", src = "yahoo", from = start_date, to = end_date)
getSymbols("EURINR=X", src = "yahoo", from = start_date, to = end_date)
getSymbols("AEDINR=X", src = "yahoo", from = start_date, to = end_date)

# ==============================
# FX DATA (INDIRECT - FIXED)
# ==============================

getSymbols("USDCNY=X", src = "yahoo", from = start_date, to = end_date)
getSymbols("USDJPY=X", src = "yahoo", from = start_date, to = end_date)

# ==============================
# EXTRACT CLOSING PRICES
# ==============================

ICICI <- Cl(ICICIBANK.NS)
NIFTY <- Cl(NSEI)
NIFTYBANK <- Cl(NSEBANK)

USD <- Cl(`USDINR=X`)
GBP <- Cl(`GBPINR=X`)
EUR <- Cl(`EURINR=X`)
AED <- Cl(`AEDINR=X`)

USDCNY <- Cl(`USDCNY=X`)
USDJPY <- Cl(`USDJPY=X`)
USDINR <- Cl(`USDINR=X`)

# ==============================
# CONVERT TO INR (KEY FIX)
# ==============================

CNY <- USDINR / USDCNY
JPY <- USDINR / USDJPY

# ==============================
# MERGE ALL DATA
# ==============================

data <- merge(ICICI, NIFTY, NIFTYBANK, USD, GBP, EUR, AED, CNY, JPY, all = FALSE)

# ==============================
# RENAME COLUMNS
# ==============================

colnames(data) <- c("ICICI", "NIFTY", "NIFTYBANK",
                    "USD", "GBP", "EUR",
                    "AED", "CNY", "JPY")

# ==============================
# CONVERT TO DATAFRAME
# ==============================

data <- data.frame(Date = index(data), coredata(data))

# ==============================
# CLEAN DATA
# ==============================

data <- na.omit(data)

# ==============================
# SAVE FINAL DATA
# ==============================

write.csv(data, "FDA_FINAL_DATA.csv", row.names = FALSE)
