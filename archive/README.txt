Overview:

The WA-HELP project is a web-based application designed to visualize and forecast hospital data, including admissions, discharges, bed occupancy, primary diagnoses, and comorbidities. The application uses various datasets to generate graphs, heatmaps, and tables that provide insights into hospital operations.

1. Project Structure

    HTML: The primary structure of the web page is defined in index.html. It includes references to external stylesheets, JavaScript files, and other resources like the WA-HELP logo.

    CSS: The styling of the page is managed by styles.css, which utilizes Tailwind CSS for utility-based styling.

    JavaScript/TypeScript: The main logic of the application resides in index.ts, where data is imported, processed, and rendered onto the page using libraries such as Leaflet for maps and Plotly for graphs.

    Assets: The WA-HELP logo is included as an image asset and is displayed on the page.

2. Key Components
2.1. HTML Structure (index.html)

    Main Elements:
        Logo: Displays the WA-HELP logo at the top.
        Map Container: A div with ID map where the Leaflet map is rendered.
        Dropdown Menu: A dropdown for selecting a hospital, which triggers updates to the displayed data.
        Tables and Graphs: Containers for various tables and graphs displaying forecasts for admissions, discharges, bed occupancy, diagnoses, and comorbidities.

2.2. CSS (styles.css)

    Tailwind CSS: The styling uses Tailwind's utility classes to handle layout, spacing, and other visual aspects of the UI.

2.3. JavaScript Logic (index.ts)

    Libraries Used:
        Leaflet: For rendering the interactive map that displays hospital locations.
        Plotly: For creating dynamic graphs such as admissions, discharges, and length of stay forecasts.

    Data Handling:
        The JavaScript file imports various datasets in JSON format (e.g., admissionsForecastData, dischargesForecastData, bedOccupancyForecastData).
        These datasets are filtered and processed to generate visual representations like graphs, tables, and heatmaps.

    DOM Manipulation:
        Dropdown: The hospital selection dropdown dynamically updates the content on the page based on the selected hospital.
        Graphs: Functions like drawAdmissionsGraph, drawDischargesGraph, and drawLengthOfStaysGraph generate graphs using Plotly based on the selected hospital.
        Tables: Functions like populateBedOccupancyTable, populateDiagnosisTable, and populateComorbidityTable update tables with relevant data.

3. Functionality Overview
3.1. Map Visualization

    Hospital Locations: The map shows hospital locations with markers. The color of the markers (red or blue) indicates whether the bed occupancy is above or below average.
    Interactions: Clicking on a marker updates the dropdown and the rest of the visualizations to reflect the selected hospital's data.

3.2. Graphs

    Admissions Graph: Displays a forecast of hospital admissions over time with upper and lower confidence bounds.
    Discharges Graph: Similar to the admissions graph, but for hospital discharges.
    Length of Stay (LOS) Graph: Shows forecasted lengths of stay for patients.

3.3. Heatmaps

    Admissions Heatmap: Displays the percentage of admissions throughout the week, broken down by hour of the day.
    Discharges Heatmap: Similar to the admissions heatmap but for discharges.

3.4. Tables

    Bed Occupancy Table: Shows bed occupancy details for specific dates.
    Diagnosis Tables: Tables for the primary diagnoses and comorbidities, broken down by current, previous, and next week's data.

4. Using the Application

    Select a Hospital: Use the dropdown menu to select a hospital. The maps, graphs, and tables will update automatically.
    Interact with the Map: Hover or click on the markers to see details about each hospital and update the visualizations accordingly.
    View Forecasts: Examine the various graphs to understand the hospital's admissions, discharges, and length of stay trends.
    Analyze Data: Use the tables to get detailed insights into bed occupancy, primary diagnoses, and comorbidities.

5. Important Notes

    Data Limitations: The visualizations are based on the latest available data. Some datasets may not cover all hospitals or may have missing information for certain dates.
    Customization: The application can be customized by altering the datasets or modifying the JavaScript code to change how data is processed and displayed.

6. Future Improvements

    Expand Data Sources: Incorporate more datasets for a comprehensive view of hospital operations.
    Enhanced UI/UX: Improve the user interface and experience, possibly by adding more interactive features or visualizations.
    Real-Time Data: Integrate real-time data sources to provide up-to-date insights.