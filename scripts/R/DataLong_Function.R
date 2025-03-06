
library(tidyverse)


reshape_data <- function(data, phrases = c("COVID", "prev_COVID", "Influenza", "prev_Influenza")){
  # Reshape the data from wide to long format
  data_long <- data %>%
    pivot_longer(
      cols = starts_with(phrases),
      names_to = c("Condition", "Metric"),
      names_sep = "(?<=\\D)(?=\\d)",
      values_to = "Value"
    ) %>%
    select(-epiyear)  # Remove the 'epiyear' column if not needed
  
  # Convert the date_start and date_end columns to Date format
  data_long$date_start <- as.Date(data_long$date_start, format = "%m/%d/%Y")
  data_long$date_end <- as.Date(data_long$date_end, format = "%m/%d/%Y")
  
  # View the transformed data
  return(data_long)
}