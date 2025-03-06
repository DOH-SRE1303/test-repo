## Handle WA HEALTH data

import pandas as pd
from datetime import datetime, timedelta
import os


# Define the base path
base_path = 'Y:/Confidential/ORHS/HSRE/WAHEALTH/data_tables/'

output_folder = 'Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-HEALTH-Sets'

# Define the file names
files = ['influenza.csv', 'staff.csv', 'covid.csv', 'census.csv']

# Read each file into a DataFrame
influenza_df = pd.read_csv(base_path + files[0], sep='\t')
staff_df = pd.read_csv(base_path + files[1], sep='\t')
covid_df = pd.read_csv(base_path + files[2], sep='\t')
census_df = pd.read_csv(base_path + files[3], sep='\t')

# Optionally, print the first few rows of each DataFrame to verify
print(influenza_df.head())
print(staff_df.head())
print(covid_df.head())
print(census_df.head())


# Retain specific columns for census_df
census_columns = [
    'Facility',
    'reportingday',
    'Pediatric Acute Care Beds Currently In Use',
    'Pediatric Acute Care Bed Capacity',
    'Pediatric ICU Bed Capacity', 
    'Pediatric ICU Beds Currently In Use',
    'Adult Acute Care Beds Currently In Use', 
    'Adult Acute Care Bed Capacity',
    'Adult ICU Bed Capacity', 
    'Adult ICU Beds Currently In Use',
    'Is Staffed For Full Capacity', 
    'Previous Day Adult ED Visits',
    'Previous Day Pediatric ED Visits'
]
census_df = census_df[census_columns]

# Retain specific columns for covid_df
covid_columns = ['Facility', 'Date Reported For', 'COVID Confirmed']
covid_df = covid_df[covid_columns]

# Convert 'Date Reported For' to datetime and format to 'YYYY-MM-DD'
covid_df['reportingday'] = pd.to_datetime(covid_df['Date Reported For']).dt.strftime('%Y-%m-%d')


# Retain specific columns for influenza_df
influenza_columns = ['Facility', 'Previous Day Influenza Admission', 'reportingday']
influenza_df = influenza_df[influenza_columns]

# Retain specific columns for staff_df
staff_columns = [
    'Facility', 'reportingday', 'Total Staff COVID-19 infections (past week)', 
    'Staffing Type', 'Critical staffing shortage today?', 'Critical staffing shortage in a week?'
]
staff_df = staff_df[staff_columns]


covid_df['reportingday'] = pd.to_datetime(covid_df['reportingday'], errors='coerce')
influenza_df['reportingday'] = pd.to_datetime(influenza_df['reportingday'], errors='coerce')
census_df['reportingday'] = pd.to_datetime(census_df['reportingday'], errors='coerce')
staff_df['reportingday'] = pd.to_datetime(staff_df['reportingday'], errors='coerce')


illness_df = pd.merge(covid_df, influenza_df, on=['Facility', 'reportingday'])


# Find the range of 'reportingday' in the merged DataFrame
reportingday_range = (illness_df['reportingday'].min(), illness_df['reportingday'].max())


print(f"Illness DataFrame reportingday range: {reportingday_range}")




# Get the current date and calculate the date two years ago
current_date = datetime.now()
two_years_ago = current_date - timedelta(days=2*365)

# Filter the DataFrame to include only rows from two years ago onwards
illness_df_filtered = illness_df[illness_df['reportingday'] >= two_years_ago]
census_df_filtered = census_df[census_df['reportingday'] >= two_years_ago]
staff_df_filtered = staff_df[staff_df['reportingday'] >= two_years_ago]




try:
    illness_df_filtered.to_csv(os.path.join(output_folder, 'WAHEALTH_illness_filtered.csv'), index=False)
    print("Successfully saved WAHEALTH_illness_filtered")
except Exception as e:
    print(f"Failed to save WAHEALTH_illness_filtered: {e}")
    


try:
    census_df_filtered.to_csv(os.path.join(output_folder, 'WAHEALTH_census_filtered.csv'), index=False)
    print("Successfully saved WAHEALTH_census_filtered")
except Exception as e:
    print(f"Failed to save WAHEALTH_census_filtered: {e}")



try:
    staff_df_filtered.to_csv(os.path.join(output_folder, 'WAHEALTH_staff_filtered.csv'), index=False)
    print("Successfully saved WAHEALTH_staff_filtered")
except Exception as e:
    print(f"Failed to save WAHEALTH_staff_filtered: {e}")
    
    
