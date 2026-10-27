# Data Documentation

## Project

**ICICI Bank Foreign Exchange Exposure Analysis (2019–2026)**

This project analyses daily ICICI Bank stock returns against Indian equity-market returns and six currency variables. The data pipeline uses Yahoo Finance through R's `quantmod` package.

Raw market data is not included in this directory. This README documents the expected inputs and data construction.

## 1. Date Range

The data-download script sets:

- Start date: `2019-01-01`
- End date: `Sys.Date()` in R, meaning the current system date when the script runs.

The actual end date and number of observations depend on the retrieval date, market calendars, and source availability.

## 2. Source Series

| Series | Yahoo Finance ticker | Use |
|---|---|---|
| ICICI Bank | `ICICIBANK.NS` | Stock price and dependent return |
| NIFTY 50 | `^NSEI` | Broad-market benchmark |
| NIFTY Bank | `^NSEBANK` | Banking-sector benchmark |
| USD/INR | `USDINR=X` | USD currency-return series |
| GBP/INR | `GBPINR=X` | GBP currency-return series |
| EUR/INR | `EURINR=X` | EUR currency-return series |
| AED/INR | `AEDINR=X` | AED currency-return series |
| USD/CNY | `USDCNY=X` | Input for derived CNY/INR series |
| USD/JPY | `USDJPY=X` | Input for derived JPY/INR series |

The scripts extract closing prices with `quantmod::Cl()`.

## 3. Currency Conversion

The script derives the CNY and JPY series in INR using:

\[
\text{CNY/INR}=\frac{\text{USD/INR}}{\text{USD/CNY}}
\]

\[
\text{JPY/INR}=\frac{\text{USD/INR}}{\text{USD/JPY}}
\]

These formulas are based on the quoted currency-pair conventions of the input series. Verify the units and quotation conventions returned by the data provider before interpreting the derived values.

## 4. Date Alignment and Cleaning

The data script merges the closing-price series using `all = FALSE`. This retains dates shared by all included series rather than preserving every date from every market.

It then converts the merged time series to a data frame and applies `na.omit()`.

Consequently, the final dataset excludes dates with missing observations in any of the merged series. The resulting sample can be smaller than the number of observations available for any individual ticker.

## 5. Required Treasury Bill Data

The regression script expects a column named `Tbill_Yield`, representing the annual percentage yield of the 91-day Treasury Bill.

This series is used to calculate a daily risk-free-rate approximation:

\[
r_{f,t}=\ln\left(1+\frac{y_t/100}{252}\right)
\]

The displayed downloader does not retrieve or merge this column. Before running the analysis, obtain an appropriate Treasury Bill yield series, align it to the analysis dates, and verify its units and missing-value treatment.

Do not run the regression pipeline until this required input has been incorporated.

## 6. Expected Analysis Dataset

The downloader writes a CSV file named:

`FDA_FINAL_DATA.csv`

The displayed downloader includes the following columns:

- `Date`
- `ICICI`
- `NIFTY`
- `NIFTYBANK`
- `USD`
- `GBP`
- `EUR`
- `AED`
- `CNY`
- `JPY`

The final analysis dataset must additionally contain `Tbill_Yield` to support the regression code. This can be created by merging the Treasury Bill data into the downloaded dataset using the date field.

## 7. Reproducibility and Data Quality

For each dataset version, record:

- Retrieval date and source.
- Actual first and last observation dates.
- Number of rows before and after merging.
- Missing-value counts by series.
- FX quotation conventions and currency-conversion formulas.
- Treasury Bill yield source, units and date-alignment method.

Yahoo Finance data availability and historical values may change. The downloaded series should therefore be treated as research inputs that require validation rather than as an immutable official record.

## 8. Data Usage

This repository does not redistribute the complete underlying market datasets. Users should review the data provider's applicable terms before sharing or redistributing downloaded data.

The `data/` directory is intended for documentation and, if needed, non-restricted data-processing instructions—not for committing large raw datasets or credentials.

