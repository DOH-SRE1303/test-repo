import pandas as pd
import json

# Load the CSV files
beds_and_locations_df = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Beds_and_Hosp_Locations.csv')
census_predictions_df = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/census_predictions.csv')
flu_covid_est_df = pd.read_csv('Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/FluCOVID_est.csv')

# Convert DataFrames to JSON
beds_and_locations_json = beds_and_locations_df.to_json(orient='records')
census_predictions_json = census_predictions_df.to_json(orient='records')
flu_covid_est_json = flu_covid_est_df.to_json(orient='records')

# Create HTML content
html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Data</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }}
        table, th, td {{
            border: 1px solid black;
        }}
        th, td {{
            padding: 8px;
            text-align: left;
        }}
    </style>
</head>
<body>
    <h1>Hospital Data</h1>
    <label for="hospitalSelect">Select a Hospital:</label>
    <select id="hospitalSelect">
        <!-- Options will be populated by JavaScript -->
    </select>
    
    <div id="tablesContainer">
        <h2>COVID and Flu Predictions</h2>
        <table id="covidFluTable">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>COVID Predicted</th>
                    <th>Flu Predicted</th>
                </tr>
            </thead>
            <tbody>
                <!-- Rows will be populated by JavaScript -->
            </tbody>
        </table>

        <h2>Pediatric Bed Capacity</h2>
        <table id="pediatricTable">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Acute Care Beds In Use</th>
                    <th>Acute Care Bed Capacity</th>
                    <th>ICU Bed Capacity</th>
                    <th>ICU Beds In Use</th>
                </tr>
            </thead>
            <tbody>
                <!-- Rows will be populated by JavaScript -->
            </tbody>
        </table>

        <h2>Adult Bed Capacity</h2>
        <table id="adultTable">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Acute Care Beds In Use</th>
                    <th>ICU Beds In Use</th>
                    <th>Previous Day Adult ED Visits</th>
                    <th>Previous Day Pediatric ED Visits</th>
                </tr>
            </thead>
            <tbody>
                <!-- Rows will be populated by JavaScript -->
            </tbody>
        </table>
    </div>

    <script>
        const bedsAndLocations = {json.dumps(beds_and_locations_json)};
        const censusPredictions = {json.dumps(census_predictions_json)};
        const fluCovidEst = {json.dumps(flu_covid_est_json)};

        const hospitalSelect = document.getElementById('hospitalSelect');
        const tablesContainer = document.getElementById('tablesContainer');
        const covidFluTableBody = document.getElementById('covidFluTable').querySelector('tbody');
        const pediatricTableBody = document.getElementById('pediatricTable').querySelector('tbody');
        const adultTableBody = document.getElementById('adultTable').querySelector('tbody');

        // Populate the dropdown with hospital names
        JSON.parse(bedsAndLocations).forEach(hospital => {
            const option = document.createElement('option');
            option.value = hospital.WAHEALTH_names;
            option.textContent = hospital.WAHEALTH_names;
            hospitalSelect.appendChild(option);
        });

        // Event listener for dropdown selection
        hospitalSelect.addEventListener('change', () => {
            const selectedHospital = hospitalSelect.value;

            // Clear previous table rows
            covidFluTableBody.innerHTML = '';
            pediatricTableBody.innerHTML = '';
            adultTableBody.innerHTML = '';

            // Populate COVID and Flu predictions table
            JSON.parse(fluCovidEst).filter(record => record.Facility === selectedHospital)
                       .forEach(record => {
                const row = document.createElement('tr');
                row.innerHTML = `<td>${record.ds}</td><td>${record.COVID_Predicted}</td><td>${record.Influenza_Predicted}</td>`;
                covidFluTableBody.appendChild(row);
            });

            // Populate Pediatric bed capacity table
            JSON.parse(censusPredictions).filter(record => record.Facility === selectedHospital)
                             .forEach(record => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${record.reportingday}</td>
                    <td>${record['Pediatric.Acute.Care.Beds.Currently.In.Use.x']}</td>
                    <td>${record.Pediatric.Acute.Care.Bed.Capacity}</td>
                    <td>${record.Pediatric.ICU.Bed.Capacity}</td>
                    <td>${record['Pediatric.ICU.Beds.Currently.In.Use.y']}</td>`;
                pediatricTableBody.appendChild(row);
            });

            // Populate Adult bed capacity table
            JSON.parse(censusPredictions).filter(record => record.Facility === selectedHospital)
                             .forEach(record => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${record.reportingday}</td>
                    <td>${record['Adult.Acute.Care.Beds.Currently.In.Use.y']}</td>
                    <td>${record['Adult.ICU.Beds.Currently.In.Use.y']}</td>
                    <td>${record.Previous.Day.Adult.ED.Visits.y']}</td>
                    <td>${record.Previous.Day.Pediatric.ED.Visits.y']}</td>`;
                adultTableBody.appendChild(row);
            });

            tablesContainer.style.display = 'block';
        });

        tablesContainer.style.display = 'none'; // Hide tables initially
    </script>
</body>
</html>
"""

# Write HTML content to a file
with open('hospital_data.html', 'w') as file:
    file.write(html_content)

print("HTML file has been created successfully.")
