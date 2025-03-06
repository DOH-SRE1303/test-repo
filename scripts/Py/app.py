import pandas as pd
import plotly.express as px
from flask import Flask, render_template_string, request
from datetime import datetime

# Load data
admit_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/AdmitHeatMap.csv')
discharge_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/DischargeHeatMap.csv')
hospitals_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Beds_and_Hosp_Locations.csv')
primary_diagnosis_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/PrimaryDiagnosis_data.csv')
comorbidity_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Comorbidity_data.csv')

flu_covid_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/FluCOVID_est.csv')
census_predictions = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/census_predictions.csv')



# Renaming columns for consistency
flu_covid_data.rename(columns={'Facility': 'WAHEALTH_names', 'COVID_Predicted': 'COVID_Estimate', 'Influenza_Predicted': 'Flu_Estimate'}, inplace=True)
census_predictions.rename(columns={'Facility': 'WAHEALTH_names'}, inplace=True)

# Get current month
current_month = datetime.now().month

# Initialize Flask app
app = Flask(__name__)

# HTML template for the web page
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Hospital Heatmaps and Data</title>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
</head>
<body>
    <h1>Select Hospital</h1>
    <form method="post">
        <select name="hospital_name" onchange="this.form.submit()">
            <option value="">Select a hospital</option>
            {% for hospital in hospitals %}
                <option value="{{ hospital }}" {% if hospital == selected_hospital %}selected{% endif %}>{{ hospital }}</option>
            {% endfor %}
        </select>
    </form>
    <div id="heatmap_admit">{{ heatmap_admit|safe }}</div>
    <div id="heatmap_discharge">{{ heatmap_discharge|safe }}</div>
    <h2>Weekly Discharge Data</h2>
    <div id="weekly_discharge">{{ weekly_discharge|safe }}</div>
    <h2>Top 10 Comorbidity Data</h2>
    <div id="comorbidity_table">{{ comorbidity_table|safe }}</div>
    <h2>Top 10 Primary Diagnosis Data</h2>
    <div id="primary_diagnosis_table">{{ primary_diagnosis_table|safe }}</div>
    <h2>Flu and COVID Estimates</h2>
    <div id="flu_covid_table">{{ flu_covid_table|safe }}</div>
    <h2>Pediatric Census/Capacity</h2>
    <div id="pediatric_census">{{ pediatric_census|safe }}</div>
    <h2>Adult Census/Capacity</h2>
    <div id="adult_census">{{ adult_census|safe }}</div>
</body>
</html>
'''

@app.route('/', methods=['GET', 'POST'])
def index():
    selected_hospital = request.form.get('hospital_name')
    hospitals = hospitals_data['hospital_name'].unique()
    heatmap_admit = ""
    heatmap_discharge = ""
    weekly_discharge = ""
    comorbidity_table = ""
    primary_diagnosis_table = ""
    flu_covid_table = ""
    pediatric_census = ""
    adult_census = ""
    
    if selected_hospital:
        # Match hospital names using WAHEALTH_names
        matched_hospital = hospitals_data[hospitals_data['hospital_name'] == selected_hospital]['WAHEALTH_names'].values[0]

        # Filter data for the selected hospital and current month
        admit_filtered = admit_data[(admit_data['hospital_name'] == selected_hospital) & (admit_data['admission_month'] == current_month)]
        discharge_filtered = discharge_data[(discharge_data['hospital_name'] == selected_hospital) & (discharge_data['discharge_month'] == current_month)]
        primary_diagnosis_filtered = primary_diagnosis_data[primary_diagnosis_data['hospital_name'] == selected_hospital]
        comorbidity_filtered = comorbidity_data[comorbidity_data['hospital_name'] == selected_hospital]
        flu_covid_filtered = flu_covid_data[flu_covid_data['WAHEALTH_names'] == matched_hospital]
        census_filtered = census_predictions[census_predictions['WAHEALTH_names'] == matched_hospital]

        # Prepare data for heatmaps
        admit_pivot = admit_filtered.pivot_table(index='admission_hour', columns='admit_weekday', values='percentage', aggfunc='sum', fill_value=0)
        discharge_pivot = discharge_filtered.pivot_table(index='discharge_hour', columns='discharge_weekday', values='percentage', aggfunc='sum', fill_value=0)

        # Plot admit heatmap
        fig_admit = px.imshow(admit_pivot, labels=dict(x="Weekday", y="Hour", color="Admits"), title=f"Admit Heatmap for {selected_hospital}")
        heatmap_admit = fig_admit.to_html(full_html=False)

        # Plot discharge heatmap
        fig_discharge = px.imshow(discharge_pivot, labels=dict(x="Weekday", y="Hour", color="Discharges"), title=f"Discharge Heatmap for {selected_hospital}")
        heatmap_discharge = fig_discharge.to_html(full_html=False)

        # Generate weekly discharge table
        weekly_discharge = discharge_filtered.groupby('discharge_weekday')['percentage'].sum().reset_index().to_html(index=False)

        # Generate top 10 comorbidity table
        top_comorbidities = comorbidity_filtered.nlargest(10, 'percentage')[['Comorbidity_Description', 'percentage']].to_html(index=False)

        # Generate top 10 primary diagnosis table
        top_primary_diagnoses = primary_diagnosis_filtered.nlargest(10, 'percentage')[['Primary_Diagnosis_Description', 'percentage']].to_html(index=False)

        # Generate flu and COVID estimates table with date
        flu_covid_table = flu_covid_filtered[['ds', 'Flu_Estimate', 'COVID_Estimate']].to_html(index=False)

        # Generate pediatric census/capacity table
        pediatric_census = census_filtered[['reportingday', 'Pediatric.Acute.Care.Beds.Currently.In.Use.x', 'Pediatric.Acute.Care.Bed.Capacity', 'Pediatric.ICU.Bed.Capacity', 'Pediatric.ICU.Beds.Currently.In.Use.x']].to_html(index=False)

        # Generate adult census/capacity table
        adult_census = census_filtered[['reportingday', 'Adult.Acute.Care.Beds.Currently.In.Use.x', 'Adult.Acute.Care.Bed.Capacity', 'Adult.ICU.Bed.Capacity', 'Adult.ICU.Beds.Currently.In.Use.x']].to_html(index=False)

    return render_template_string(HTML_TEMPLATE, hospitals=hospitals, heatmap_admit=heatmap_admit, heatmap_discharge=heatmap_discharge, weekly_discharge=weekly_discharge, comorbidity_table=top_comorbidities, primary_diagnosis_table=top_primary_diagnoses, flu_covid_table=flu_covid_table, pediatric_census=pediatric_census, adult_census=adult_census, selected_hospital=selected_hospital)

if __name__ == '__main__':
    app.run(debug=True)
