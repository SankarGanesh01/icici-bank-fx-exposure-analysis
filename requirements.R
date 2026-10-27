# Package setup for ICICI Bank FX Exposure Analysis

required_packages <- c(
  "quantmod",  # Financial time-series data retrieval
  "dplyr",     # Data manipulation
  "lmtest",    # Breusch-Pagan and Durbin-Watson tests
  "ggplot2",   # Research visualisations
  "tidyr",     # Data reshaping
  "car"        # Variance Inflation Factor (VIF)
)

# Install packages that are not already available
installed_packages <- rownames(installed.packages())

missing_packages <- setdiff(
  required_packages,
  installed_packages
)

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# Load the packages
invisible(
  lapply(required_packages, library, character.only = TRUE)
)

message("Required R packages are installed and loaded.")
