---
editor_options: 
  markdown: 
    wrap: 72
---

# Code Usage

Data files ending with `Data` are used, filtered, processed, to generate
graphs, tables, and heatmaps.

-   admissionsForecastData
-   dischargesForecastData
-   bedOccupancyForecastData
-   ?Comorbidity_data
-   ?PrimaryDiagnosis_data

## Data storage locations

### CHARS (01_Step_Clean_CHARS.py):

-   beds_and_hosp_locations_path =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Beds_and_Hosp_Locations.csv`
-   comorbidity_path =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Comorbidity_data.csv`
-   primary_diagnosis_path =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/PrimaryDiagnosis_data.csv`
-   discharge_heatmap_path =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/DischargeHeatMap.csv`
-   admit_heatmap_path =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/AdmitHeatMap.csv`

### WA HEALTH (02_Step_WA_HEALTH.py):

-   base_path = 'Y:/Confidential/ORHS/HSRE/WAHEALTH/data_tables/'
    -   `./influenza.csv`
    -   `./staff.csv`
    -   `./covid.csv`
    -   `./census.csv`

## Data output locations

### CHARS (01_Step_Clean_CHARS.py)

-   output_folder =
    `Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-CHARS-Sets`

-   AdmitHeatMap_filtered.csv

-   DischargeHeatMap_filtered.csv

-   Comorbidity_data_filtered.csv

-   PrimaryDiagnosis_data_filtered.csv

### WA HEALTH (02_Step_WA_HEALTH.py)

-   output_folder =
    'Y:/Confidential/ORHS/HSRE/HELP/HELP-SIM/HELP_Sim_Sources/Time-Cleaned-HEALTH-Sets'

-   WAHEALTH_illness_filtered.csv

-   WAHEALTH_census_filtered.csv

-   WAHEALTH_staff_filtered.csv

### (Re)Generating the Landing Page

0.  Update datasets as needed: [CHARS](), [CENSUS](), [WA HEALTH]()

1.  

2.  

3.  
