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
WAH_Ill <- read.csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-HEALTH-Sets/WAHEALTH_illness_filtered.csv')

# Get the current date
current_date <- Sys.Date()
past_days <- 14 # Number of past days to predict
future_days <- 7
cutoff_date <- current_date - past_days

# Ensure dates are in Date format
WAH_Ill$reportingday <- as.Date(WAH_Ill$reportingday)

# Create a sequence of dates for the entire range
date_seq <- seq.Date(min(WAH_Ill$reportingday), current_date, by = "day")

# Function to fill missing dates with the average of the closest filled dates
fill_missing_dates <- function(data, date_seq) {
  full_data <- data.frame(reportingday = date_seq) %>%
    left_join(data, by = "reportingday")
  full_data <- full_data %>%
    mutate(COVID.Confirmed = zoo::na.approx(COVID.Confirmed, na.rm = FALSE),
           Previous.Day.Influenza.Admission = zoo::na.approx(Previous.Day.Influenza.Admission, na.rm = FALSE))
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
  
  # Prepare COVID data
  covid_data <- filled_facility_data %>% 
    select(reportingday, COVID.Confirmed) %>%
    rename(ds = reportingday, y = COVID.Confirmed)
  
  # Prepare influenza data
  influenza_data <- filled_facility_data %>%
    select(reportingday, Previous.Day.Influenza.Admission) %>%
    mutate(ds = reportingday + 1, y = Previous.Day.Influenza.Admission) %>% # Adjust date to represent current day
    select(ds, y)
  
  # Ensure dates are in Date format and no NA values
  covid_data$ds <- as.Date(covid_data$ds)
  influenza_data$ds <- as.Date(influenza_data$ds)
  covid_data <- covid_data %>% na.omit()
  influenza_data <- influenza_data %>% na.omit()
  
  # Fit ARIMA models
  covid_ts <- ts(covid_data$y, frequency = 7) # Weekly seasonality
  influenza_ts <- ts(influenza_data$y, frequency = 7) # Weekly seasonality
  
  covid_fit <- auto.arima(covid_ts)
  influenza_fit <- auto.arima(influenza_ts)
  
  # Forecast next week and fill the last two weeks
  covid_forecast <- forecast(covid_fit, h = past_days + 7)
  influenza_forecast <- forecast(influenza_fit, h = past_days + 7)
  
  # Combine forecasts with facility info
  forecast_dates <- seq.Date(from = current_date - past_days, by = "day", length.out = past_days + 7)
  covid_forecast_df <- data.frame(ds = forecast_dates, COVID_Predicted = covid_forecast$mean)
  influenza_forecast_df <- data.frame(ds = forecast_dates, Influenza_Predicted = influenza_forecast$mean)
  
  facility_forecast <- covid_forecast_df %>%
    inner_join(influenza_forecast_df, by = "ds") %>%
    mutate(Facility = facility)
  
  predictions_list[[facility]] <- facility_forecast
}

# Combine all facilities into one dataframe
final_predictions <- bind_rows(predictions_list)



# Round down the estimates to the nearest 1
final_predictions <- final_predictions %>%
  mutate(COVID_Predicted = floor(COVID_Predicted),
         Influenza_Predicted = floor(Influenza_Predicted))

# Filter the dates to only those from the current date to a week in advance
final_predictions <- final_predictions %>%
  filter(ds >= current_date & ds <= (current_date + future_days))

# View or save the final predictions


head(final_predictions)
write.csv(final_predictions, "Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/FluCOVID_est.csv", row.names = FALSE)
