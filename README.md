# <img src="wa-help-logo.png" width="85" align="left"/>Washington State Health Ecosystem Landing Page (WA HELP)

The WA-HELP is an experimental web-based application designed to visualize and forecast hospital data, including admissions, discharges, bed occupancy, primary diagnoses, and comorbidities. The application uses various datasets to generate graphs, heatmaps, and tables for deriving insights from the operational realities of WA State health systems.

-   Creates a baseline and projections for "normal operations" of our Healthcare Ecosystem
-   Includes patient population demographics in baselines used for projections
-   Projects how stressor events might impact Healthcare Ecosystem operations.
-   Assists decision making for public health responses in coordination with other agency tools
-   Accepts new data and information to update or improve its outputs

Decision making tools in this product can:

-   Aid in determining when and where future healthcare resources might be allocated.
-   Provides both strategic overviews and granular details
-   WIP: Predict staffing needs in advance of anticipated stressors
-   WIP: Help reduce costs of response exercise creation

## Usage

### Data Requirements

-   **CHARS** - Admissions and Discharge data (quarterly)
-   **CENSUS** or other Population Estimates
-   **WA HEALTH Facility Data** - Hospital Pediatric Beds, Bed Availability

### For end-users

1.  **Select a Hospital**: Use the dropdown menu to select a hospital. The maps, graphs, and tables will update automatically.
2.  **Interact with the Map**: Hover or click on the markers to see details about each hospital and update the visualizations accordingly.
3.  **View Forecasts**: Examine the various graphs to understand the hospital's admissions, discharges, and length of stay trends.
4.  **Analyze Data**: Use the tables to get detailed insights into bed occupancy, primary diagnoses, and comorbidities.

### For Project Developers and Maintainers

See [Code Structure](#./docs/code-structure.md) and [Code Usage](#./docs/code-structure.md).

## Important Notes

### Data Limitations

The visualizations are based on the latest available data. Some datasets may not cover all hospitals or may have missing information for certain dates.

### Customization

The application can be customized by altering the datasets or modifying the JavaScript code to change how data is processed and displayed.

## Future Improvements

-   Expand Data Sources: Incorporate more datasets for a comprehensive view of hospital operations.
-   Enhanced UI/UX: Improve the user interface and experience, possibly by adding more interactive features or visualizations.
-   Real-Time Data: Integrate real-time data sources to provide up-to-date insights.
