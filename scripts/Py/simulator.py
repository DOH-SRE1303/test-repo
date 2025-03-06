import pandas as pd
from flask import Flask, render_template_string, request
from geopy.distance import geodesic

# Load data
hospitals_data = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Beds_and_Hosp_Locations.csv')
census_predictions = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/census_predictions.csv')

# Renaming columns for consistency
census_predictions.rename(columns={'Facility': 'WAHEALTH_names'}, inplace=True)

# Initialize Flask app
app = Flask(__name__)

# HTML template for the simulator
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Hospital Simulator</title>
</head>
<body>
    <h1>Simulator</h1>
    <form method="post" action="/run_simulation">
        <label for="facility">Facility:</label>
        <select name="facility" id="facility">
            <option value="">Select a facility</option>
            {% for facility in facilities %}
                <option value="{{ facility }}">{{ facility }}</option>
            {% endfor %}
        </select>
        <br>
        <label for="num_adults">Number of Adults:</label>
        <input type="number" id="num_adults" name="num_adults" min="0">
        <br>
        <label for="num_children">Number of Children:</label>
        <input type="number" id="num_children" name="num_children" min="0">
        <br>
        <label for="severity">Average Severity:</label>
        <select name="severity" id="severity">
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
            <option value="critical">Critical</option>
        </select>
        <br>
        <button type="submit">Run</button>
    </form>
    <h2>RESULTS</h2>
    <div id="results">{{ results|safe }}</div>
</body>
</html>
'''

@app.route('/', methods=['GET'])
def index():
    facilities = hospitals_data['WAHEALTH_names'].unique()
    return render_template_string(HTML_TEMPLATE, facilities=facilities, results="")

@app.route('/run_simulation', methods=['POST'])
def run_simulation():
    facility = request.form.get('facility')
    num_adults = int(request.form.get('num_adults', 0))
    num_children = int(request.form.get('num_children', 0))
    severity = request.form.get('severity')

    if not facility or severity not in ['low', 'medium', 'high', 'critical']:
        return render_template_string(HTML_TEMPLATE, facilities=hospitals_data['WAHEALTH_names'].unique(), results="Invalid input.")

    # Get the facility type and coordinates
    facility_data = hospitals_data[hospitals_data['WAHEALTH_names'] == facility].iloc[0]
    facility_type = facility_data['U_R_CAH_BEH_TRA']
    facility_coords = (facility_data['Lat'], facility_data['Long'])

    severity_map = {'low': 'CAH', 'medium': 'RUR', 'high': 'URB', 'critical': 'TRA'}
    if facility_type != severity_map[severity]:
        # Find the closest facility of the required type
        closest_facility = None
        min_distance = float('inf')
        for _, row in hospitals_data[hospitals_data['U_R_CAH_BEH_TRA'] == severity_map[severity]].iterrows():
            distance = geodesic(facility_coords, (row['Lat'], row['Long'])).miles
            if distance < min_distance:
                min_distance = distance
                closest_facility = row
        facility_data = closest_facility
        facility = facility_data['WAHEALTH_names']
    
    # Simulate the bed capacity
    results = f"Initial Facility: {facility_data['WAHEALTH_names']}<br>"

    census_data = census_predictions[census_predictions['WAHEALTH_names'] == facility].iloc[0]
    pediatric_beds_available = census_data['Pediatric.ICU.Bed.Capacity'] - census_data['Pediatric.ICU.Beds.Currently.In.Use.x']
    adult_beds_available = census_data['Adult.ICU.Bed.Capacity'] - census_data['Adult.ICU.Beds.Currently.In.Use.x']

    if num_children > pediatric_beds_available:
        overflow_children = num_children - pediatric_beds_available
        num_children = pediatric_beds_available
    else:
        overflow_children = 0
    
    if num_adults > adult_beds_available:
        overflow_adults = num_adults - adult_beds_available
        num_adults = adult_beds_available
    else:
        overflow_adults = 0

    results += f"Updated Facility: {facility_data['WAHEALTH_names']}<br>"
    results += f"Pediatric Beds Used: {census_data['Pediatric.ICU.Beds.Currently.In.Use.x']} -> {census_data['Pediatric.ICU.Beds.Currently.In.Use.x'] + num_children}<br>"
    results += f"Adult Beds Used: {census_data['Adult.ICU.Beds.Currently.In.Use.x']} -> {census_data['Adult.ICU.Beds.Currently.In.Use.x'] + num_adults}<br>"

    if overflow_children > 0 or overflow_adults > 0:
        results += "Overflow:<br>"
        if overflow_children > 0:
            results += f"Children: {overflow_children}<br>"
        if overflow_adults > 0:
            results += f"Adults: {overflow_adults}<br>"

    return render_template_string(HTML_TEMPLATE, facilities=hospitals_data['WAHEALTH_names'].unique(), results=results)

if __name__ == '__main__':
    app.run(debug=True)
