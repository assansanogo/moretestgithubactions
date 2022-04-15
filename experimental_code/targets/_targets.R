library(targets)
source("functions.R")
options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("biglm", "tidyverse","broom","visNetwork"))

# input data
list(
  
  # input data
  tar_target(
    input_data_file,
    "data/raw_data.csv",
    format = "file"
  ),
  # data ingestionogram
  tar_target(
    data_ingestion,
    read_csv(input_data_file, col_types = cols())
  ),
  # data remove na
  tar_target(
    data_no_na,
    data_ingestion %>%
      filter(!is.na(Ozone))
  ),
  # data histogram
  tar_target(histogram, 
             create_plot(data_no_na)),
  # data regression
  tar_target(fit_linear_regression, 
             biglm(Ozone ~ Wind + Temp, data_no_na)
             )
  )
