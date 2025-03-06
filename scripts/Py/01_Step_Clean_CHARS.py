import pandas as pd
import datetime
import os
import json
import re

# Script location
script_dir = os.path.dirname(os.path.abspath(__file__))

# Parent and data location
parent_dir = os.path.dirname(os.path.dirname(script_dir))
data_dir = os.path.join(parent_dir, 'data')  # Construct path to data folder

# Data paths
beds_and_hosp_locations_path = os.path.join(data_dir, 'Beds_and_Hosp_Locations.js')
comorbidity_path = os.path.join(data_dir, 'Comorbidity_data.js')
primary_diagnosis_path = os.path.join(data_dir, 'PrimaryDiagnosis_data.js')
discharge_heatmap_path = os.path.join(data_dir, 'DischargeHeatMap.js')
admit_heatmap_path = os.path.join(data_dir, 'AdmitHeatMap.js')

# Output data path
output_folder = os.path.join(data_dir, 'Time-Cleaned-CHARS-Sets')

# Load JSON data
def load_json(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        return json.load(file)
    
def load_js_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        raw_content = file.read()
    
    # Remove the variable declaration (e.g., `const Comorbidities = `)
    raw_content = re.sub(r'^const\s+\w+\s*=\s*', '', raw_content, flags=re.MULTILINE)
    
    # Remove comments (both single-line and inline comments)
    raw_content = re.sub(r'//.*', '', raw_content)
    raw_content = re.sub(r'/\*.*?\*/', '', raw_content, flags=re.DOTALL)
    
    # Strip trailing commas from arrays or objects
    raw_content = re.sub(r',\s*([}\]])', r'\1', raw_content)
    
    # Ensure it's valid JSON
    try:
        data = json.loads(raw_content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return None
    
    return data
    
# Print paths
print("Script Directory:", parent_dir)
print("Parent Directory:", parent_dir)
print("Script Directory:", data_dir)
print("Beds and Hosp Locations Path:", beds_and_hosp_locations_path)
print("Comorbidity Path:", comorbidity_path)
print("Primary Diagnosis Path:", primary_diagnosis_path)
print("Discharge Heatmap Path:", discharge_heatmap_path)
print("Admit Heatmap Path:", admit_heatmap_path)
print("Output Folder:", output_folder)

# # Read the CSV files into their own unique DataFrames
# try:
#     beds_and_hosp_locations_df = pd.read_csv(beds_and_hosp_locations_path)
#     print("Successfully read beds_and_hosp_locations_df")
# except Exception as e:
#     print(f"Failed to read beds_and_hosp_locations_df: {e}")

try:
    # comorbidity_df = pd.read_csv(comorbidity_path)
    comorbidity_df = load_js_data(comorbidity_path)
    print("Successfully read comorbidity_df")
    print(comorbidity_df[0])  # Print the first record
    print(len(comorbidity_df))  # Number of records
except Exception as e:
    print(f"Failed to read comorbidity_df: {e}")

# try:
#     primary_diagnosis_df = pd.read_csv(primary_diagnosis_path)
#     print("Successfully read primary_diagnosis_df")
# except Exception as e:
#     print(f"Failed to read primary_diagnosis_df: {e}")

# try:
#     discharge_heatmap_df = pd.read_csv(discharge_heatmap_path)
#     print("Successfully read discharge_heatmap_df")
# except Exception as e:
#     print(f"Failed to read discharge_heatmap_df: {e}")

# try:
#     admit_heatmap_df = pd.read_csv(admit_heatmap_path)
#     print("Successfully read admit_heatmap_df")
# except Exception as e:
#     print(f"Failed to read admit_heatmap_df: {e}")

# # Get the current month and year
# now = datetime.datetime.now()
# current_year = now.year
# current_month = now.month

# # Calculate the week numbers that fall within the current month
# weeks_in_month = [datetime.date(current_year, current_month, day).isocalendar()[1] for day in range(1, 32)
#                   if datetime.date(current_year, current_month, day).month == current_month]
# weeks_in_month = list(set(weeks_in_month))  # Remove duplicates

# # Filter the DataFrames by the current month
# try:
#     admit_heatmap_df_filtered = admit_heatmap_df[admit_heatmap_df['admission_month'] == current_month]
#     print("Successfully filtered admit_heatmap_df")
# except Exception as e:
#     print(f"Failed to filter admit_heatmap_df: {e}")

# try:
#     discharge_heatmap_df_filtered = discharge_heatmap_df[discharge_heatmap_df['discharge_month'] == current_month]
#     print("Successfully filtered discharge_heatmap_df")
# except Exception as e:
#     print(f"Failed to filter discharge_heatmap_df: {e}")

# # Filter the comorbidity_df and primary_diagnosis_df by the week numbers
# try:
#     comorbidity_df_filtered = comorbidity_df[comorbidity_df['week_number'].isin(weeks_in_month)]
#     print("Successfully filtered comorbidity_df")
# except Exception as e:
#     print(f"Failed to filter comorbidity_df: {e}")

# try:
#     primary_diagnosis_df_filtered = primary_diagnosis_df[primary_diagnosis_df['week_number'].isin(weeks_in_month)]
#     print("Successfully filtered primary_diagnosis_df")
# except Exception as e:
#     print(f"Failed to filter primary_diagnosis_df: {e}")

# # Save the cleaned DataFrames to the specified folder
# try:
#     admit_heatmap_df_filtered.to_csv(os.path.join(output_folder, 'AdmitHeatMap_filtered.csv'), index=False)
#     print("Successfully saved admit_heatmap_df_filtered")
# except Exception as e:
#     print(f"Failed to save admit_heatmap_df_filtered: {e}")

# try:
#     discharge_heatmap_df_filtered.to_csv(os.path.join(output_folder, 'DischargeHeatMap_filtered.csv'), index=False)
#     print("Successfully saved discharge_heatmap_df_filtered")
# except Exception as e:
#     print(f"Failed to save discharge_heatmap_df_filtered: {e}")

# try:
#     comorbidity_df_filtered.to_csv(os.path.join(output_folder, 'Comorbidity_data_filtered.csv'), index=False)
#     print("Successfully saved comorbidity_df_filtered")
# except Exception as e:
#     print(f"Failed to save comorbidity_df_filtered: {e}")

# try:
#     primary_diagnosis_df_filtered.to_csv(os.path.join(output_folder, 'PrimaryDiagnosis_data_filtered.csv'), index=False)
#     print("Successfully saved primary_diagnosis_df_filtered")
# except Exception as e:
#     print(f"Failed to save primary_diagnosis_df_filtered: {e}")

# # Display the first few rows of the filtered DataFrames to verify
# print("\nFiltered DataFrame 'admit_heatmap_df_filtered':")
# print(admit_heatmap_df_filtered.head())

# print("\nFiltered DataFrame 'discharge_heatmap_df_filtered':")
# print(discharge_heatmap_df_filtered.head())

# print("\nFiltered DataFrame 'comorbidity_df_filtered':")
# print(comorbidity_df_filtered.head())

# print("\nFiltered DataFrame 'primary_diagnosis_df_filtered':")
# print(primary_diagnosis_df_filtered.head())
