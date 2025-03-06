import pandas as pd
import statsmodels as sm
import warnings
warnings.filterwarnings("ignore")
# Sample data based on your provided structure
input_folder = 'Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-HEALTH-Sets'

# Define the file names
files = ['/WAHEALTH_illness_filtered.csv']


WAHEALTH_illness_filtered = pd.read_csv(input_folder + files[0])




# Convert reportingday to datetime
WAHEALTH_illness_filtered['reportingday'] = pd.to_datetime(WAHEALTH_illness_filtered['reportingday'])

# Function to fit ARIMA model and make predictions
def forecast_arima(df, value_column, periods=1):
    df.set_index('reportingday', inplace=True)
    model = sm.tsa.ARIMA(df[value_column], order=(5,1,0))  # you can adjust the order parameters
    model_fit = model.fit(disp=0)
    forecast = model_fit.forecast(steps=periods)
    return forecast

# Apply the forecasting function to each facility
results = []

for facility, group in WAHEALTH_illness_filtered.groupby('Facility'):
    covid_forecast = forecast_arima(group, 'COVID Confirmed')
    flu_forecast = forecast_arima(group, 'Previous Day Influenza Admission')
    
    dates = pd.date_range(start=group['reportingday'].max(), periods=365, closed='right')
    forecast_df = pd.DataFrame({
        'reportingday': dates,
        'COVID Predicted': covid_forecast[0],
        'Influenza Predicted': flu_forecast[0],
        'Facility': facility
    })
    
    results.append(forecast_df)

# Combine results into a single DataFrame
forecast_df = pd.concat(results).reset_index(drop=True)

# Merging the forecast results back to the original dataframe
WAHEALTH_illness_filtered = pd.concat([WAHEALTH_illness_filtered, forecast_df], ignore_index=True)

# Display the updated DataFrame
import ace_tools as tools; tools.display_dataframe_to_user(name="Updated WAHEALTH DataFrame", dataframe=WAHEALTH_illness_filtered)
