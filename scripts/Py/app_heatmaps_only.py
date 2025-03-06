import pandas as pd
import plotly.express as px
from flask import Flask, render_template_string, request
from datetime import datetime

# Load data
admit_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/AdmitHeatMap.csv')
discharge_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/DischargeHeatMap.csv')
hospitals_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Beds_and_Hosp_Locations.csv')

# Get current month
current_month = datetime.now().month

# Initialize Flask app
app = Flask(__name__)

# HTML template for the web page
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Hospital Heatmaps</title>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
</head>
<body>
    <h1>Select Hospital</h1>
    <form method="post">
        <select name="hospital_name" onchange="this.form.submit()">
            <option value="">Select a hospital</option>
            {% for hospital in hospitals %}
                <option value="{{ hospital }}">{{ hospital }}</option>
            {% endfor %}
        </select>
    </form>
    <div id="heatmap_admit">{{ heatmap_admit|safe }}</div>
    <div id="heatmap_discharge">{{ heatmap_discharge|safe }}</div>
</body>
</html>
'''

@app.route('/', methods=['GET', 'POST'])
def index():
    selected_hospital = request.form.get('hospital_name')
    hospitals = hospitals_data['hospital_name'].unique()
    heatmap_admit = ""
    heatmap_discharge = ""
    
    if selected_hospital:
        # Filter data for the selected hospital and current month
        admit_filtered = admit_data[(admit_data['hospital_name'] == selected_hospital) & (admit_data['admission_month'] == current_month)]
        discharge_filtered = discharge_data[(discharge_data['hospital_name'] == selected_hospital) & (discharge_data['discharge_month'] == current_month)]

        # Prepare data for heatmaps
        admit_pivot = admit_filtered.pivot_table(index='admission_hour', columns='admit_weekday', values='percentage', aggfunc='sum', fill_value=0)
        discharge_pivot = discharge_filtered.pivot_table(index='discharge_hour', columns='discharge_weekday', values='percentage', aggfunc='sum', fill_value=0)

        # Plot admit heatmap
        fig_admit = px.imshow(admit_pivot, labels=dict(x="Weekday", y="Hour", color="Admits"), title=f"Admit Heatmap for {selected_hospital}")
        heatmap_admit = fig_admit.to_html(full_html=False)

        # Plot discharge heatmap
        fig_discharge = px.imshow(discharge_pivot, labels=dict(x="Weekday", y="Hour", color="Discharges"), title=f"Discharge Heatmap for {selected_hospital}")
        heatmap_discharge = fig_discharge.to_html(full_html=False)

    return render_template_string(HTML_TEMPLATE, hospitals=hospitals, heatmap_admit=heatmap_admit, heatmap_discharge=heatmap_discharge)

if __name__ == '__main__':
    app.run(debug=True)
