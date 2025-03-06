# App and Code Structure

### HTML
- The primary structure of the web page is defined in `index.html`.
- Includes references to:
  - External stylesheets
  - JavaScript files
  - Other resources like the WA-HELP logo

### CSS
- The styling of the page is managed by `styles.css`.
- Utilizes Tailwind CSS for utility-based styling.

### JavaScript/TypeScript
- The main logic of the application resides in `index.ts`.
- Handles data import, processing, and rendering onto the page.
- Uses libraries such as:
  - Leaflet for maps
  - Plotly for graphs

### Assets
- The WA-HELP logo is included as an image asset and displayed on the page.

# Key Components

## 1. HTML Structure (`index.html`)

### 1.1 Main Elements
- **Logo:** Displays the WA-HELP logo at the top.
- **Map Container:** A `div` with ID `map` where the Leaflet map is rendered.
- **Dropdown Menu:** A dropdown for selecting a hospital, which triggers updates to the displayed data.
- **Tables and Graphs:** Containers for various tables and graphs displaying:
  - Forecasts for admissions
  - Discharges
  - Bed occupancy
  - Diagnoses
  - Comorbidities

## 2. CSS (`styles.css`)
- Utilizes Tailwind's utility classes to handle:
  - Layout
  - Spacing
  - Other visual aspects of the UI

## 3. JavaScript Logic (`index.ts`)

### 3.1 Libraries Used
- **Leaflet:** For rendering the interactive map that displays hospital locations.
- **Plotly:** For creating dynamic graphs, such as:
  - Admissions forecasts
  - Discharges forecasts
  - Length of stay forecasts

### 3.2 Data Handling
- Imports various datasets in JSON format, such as:
  - `admissionsForecastData`
  - `dischargesForecastData`
  - `bedOccupancyForecastData`
- Filters and processes these datasets to generate visual representations like:
  - Graphs
  - Tables
  - Heatmaps

### 3.3 DOM Manipulation
- **Dropdown:** The hospital selection dropdown dynamically updates the content based on the selected hospital.
- **Graphs:** Functions such as `drawAdmissionsGraph`, `drawDischargesGraph`, and `drawLengthOfStaysGraph` generate graphs using Plotly based on the selected hospital.
- **Tables:** Functions like `populateBedOccupancyTable`, `populateDiagnosisTable`, and `populateComorbidityTable` update tables with relevant data.

# Functionality Overview

## 3.1 Map Visualization
- **Hospital Locations:** 
  - The map shows hospital locations with markers.
  - Marker colors (red or blue) indicate whether bed occupancy is above or below average.
- **Interactions:** 
  - Clicking on a marker updates the dropdown and the rest of the visualizations to reflect the selected hospital's data.

## 3.2 Graphs
- **Admissions Graph:** 
  - Displays a forecast of hospital admissions over time with upper and lower confidence bounds.
- **Discharges Graph:** 
  - Similar to the admissions graph, but for hospital discharges.
- **Length of Stay (LOS) Graph:** 
  - Shows forecasted lengths of stay for patients.

## 3.3 Heatmaps
- **Admissions Heatmap:** 
  - Displays the percentage of admissions throughout the week, broken down by hour of the day.
- **Discharges Heatmap:** 
  - Similar to the admissions heatmap but for discharges.

## 3.4 Tables
- **Bed Occupancy Table:** 
  - Shows bed occupancy details for specific dates.
- **Diagnosis Tables:** 
  - Tables for the primary diagnoses and comorbidities, broken down by:
    - Current week's data
    - Previous week's data
    - Next week's data
