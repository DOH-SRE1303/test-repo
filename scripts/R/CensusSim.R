# Install and load necessary packages
if (!requireNamespace("forecast", quietly = TRUE)) {
  install.packages("forecast")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("lubridate", quietly = TRUE)) {
  install.packages("lubridate")
}
if (!requireNamespace("zoo", quietly = TRUE)) {
  install.packages("zoo")
}

# Load the necessary libraries
library(forecast)
library(dplyr)
library(lubridate)
library(zoo)

# Read your data
WAH_Ill <- read.csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-HEALTH-Sets/WAHEALTH_census_filtered.csv')

# Get the current date
current_date <- Sys.Date()
past_days <- 14 # Number of past days to predict
future_days <- 7 # Number of future days to predict
cutoff_date <- current_date - past_days

# Ensure dates are in Date format
WAH_Ill$reportingday <- as.Date(WAH_Ill$reportingday)

# Create a sequence of dates for the entire range
date_seq <- seq.Date(min(WAH_Ill$reportingday), current_date + future_days, by = "day")

# Function to fill missing dates with the average of the closest filled dates
fill_missing_dates <- function(data, date_seq) {
  full_data <- data.frame(reportingday = date_seq) %>%
    left_join(data, by = "reportingday")
  full_data <- full_data %>%
    mutate(across(contains("Currently.In.Use"), ~ zoo::na.approx(., na.rm = FALSE)),
           across(contains("ED.Visits"), ~ zoo::na.approx(., na.rm = FALSE)))
  return(full_data)
}

# Prepare the data for the ARIMA model
facilities <- unique(WAH_Ill$Facility)
predictions_list <- list()

for (facility in facilities) {
  # Filter data for each facility
  facility_data <- WAH_Ill %>% filter(Facility == facility)
  
  # Fill missing dates
  filled_facility_data <- fill_missing_dates(facility_data, date_seq)
  
  # Remove rows with remaining NAs after filling
  filled_facility_data <- filled_facility_data %>% na.omit()
  
  # Check if there is sufficient data
  if(nrow(filled_facility_data) < 10) {
    next # Skip if not enough data
  }
  
  # Prepare data for columns containing "Currently.In.Use"
  currently_in_use_cols <- grep("Currently.In.Use", names(filled_facility_data), value = TRUE)
  ed_visits_cols <- grep("ED.Visits", names(filled_facility_data), value = TRUE)
  
  for (col in c(currently_in_use_cols, ed_visits_cols)) {
    if (col %in% ed_visits_cols) {
      temp_data <- filled_facility_data %>%
        select(reportingday, all_of(col)) %>%
        mutate(ds = reportingday + 1, y = !!sym(col)) %>%
        select(ds, y)
    } else {
      temp_data <- filled_facility_data %>% 
        select(reportingday, all_of(col)) %>%
        rename(ds = reportingday, y = !!sym(col))
    }
    temp_data$ds <- as.Date(temp_data$ds)
    temp_data$y <- as.numeric(temp_data$y)
    temp_data <- temp_data %>% na.omit()
    
    ts_data <- ts(temp_data$y, frequency = 7)
    fit <- auto.arima(ts_data)
    forecast_data <- forecast(fit, h = past_days + future_days)
    
    forecast_df <- data.frame(ds = seq.Date(from = current_date - past_days, by = "day", length.out = past_days + future_days),
                              yhat = forecast_data$mean)
    forecast_df <- forecast_df %>%
      mutate(yhat = floor(yhat)) %>%
      rename(!!col := yhat)
    
    # Merge forecasted data back to filled_facility_data
    filled_facility_data <- left_join(filled_facility_data, forecast_df, by = c("reportingday" = "ds"))
  }
  
  # Filter only necessary dates
  facility_forecast <- filled_facility_data %>%
    filter(reportingday >= current_date - past_days & reportingday <= current_date + future_days) %>%
    mutate(Facility = facility)
  
  predictions_list[[facility]] <- facility_forecast
}

# Combine all facilities into one dataframe
final_predictions <- bind_rows(predictions_list)

# View or save the final predictions
head(final_predictions)
write.csv(final_predictions, "Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/census_predictions.csv", row.names = FALSE)
