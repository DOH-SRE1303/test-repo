library(plotly)

plot_control_chart <- function(df) {
  # Convert the "Date" column to Date format

  # Calculate the mean and standard deviation
  mean_data <- mean(df$Data)
  sd_data <- sd(df$Data)
  
  # Create the Control Chart
  control_chart <- plot_ly(data = df, x = ~Date, y = ~Data, type = 'scatter', mode = 'lines', name = 'Data') %>%
    add_trace(y = rep(mean_data, nrow(df)), name = 'Mean') %>%
    add_trace(y = rep(mean_data + 3 * sd_data, nrow(df)), name = 'Upper Control Limit') %>%
    add_trace(y = rep(mean_data - 3 * sd_data, nrow(df)), name = 'Lower Control Limit') %>%
    layout(title = 'Control Chart',
           xaxis = list(title = 'Date'),
           yaxis = list(title = 'Data'),
           showlegend = TRUE)
  
  return(control_chart)
}

# Usage:

data <- c(25.1, 25.4, 25.2, 25.6, 25.3)
date <- c("2021-01-01","2021-06-01", "2022-01-01", "2022-06-01",  "2023-01-01")
df <- data.frame(Data = data, Date = date)
df$date <- as.Date(df$Date, format = "%Y-%m-%d")
# Assuming you have a dataframe named "df" with columns "Date" and "Data"
control_chart_plot <- plot_control_chart(df)
control_chart_plot

