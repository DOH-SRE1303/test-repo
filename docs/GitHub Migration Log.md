#HELP #wa-health 
[[Cody Code Review]]
## WA HELP Files  → GitHub
Originally received zip dump of all project files. Sorting and removing confidential information before GitHub upload. See [[Cody Code Review]].

- initialized `renv` R project
- initialized git repository
- Added logo as `wa-health-logo.png`
### HELP_v2_Simulator
- Moved Simulator V2 to `simulator` folder
	- moved scripts to `scripts`
		- moved py files to `scripts/Py`
		- moved R files to `scripts/R`
- Moved style.css to `styles`
- [ ] Has data sources that need to be reviewed and relocated as needed. These data should be created dynamically when the project is run and not stored in GitHub.
	- census_predictions.csv
	- facility_predictions.csv
	- HOFIDAR_Yearly_Support_Schedule.20240513
- Removed Simulator markdown and R project as it was not used/only had Quarto boilerplate
### HELP_Show_Paul
- Moved scripts to `scripts`
	- moved JS files to `scripts/JS
- [ ] Some JS files contain data values that may be dynamically generated or need storage elsewhere.  These data should be created dynamically when the project is run and not stored in GitHub.
	- `Comorbidity_data.js`
	- `PrimaryDiagnosis_data.js`
### HELP_Sim_Sources 
- Has JS scripts that may be out of date
	- AdmitHeatMap.js
	- DischargeHeatMap.js
- [ ] Has data sources that need to be relocated.  These data should be created dynamically when the project is run and not stored in GitHub.
	- PrimaryDiagnosis_data.csv
	- Comorbidity_data.csv
### HELP_RScritps.zip
- Moved to `scripts/R`
### Remaining folders moved to `Archive`
- all folders except those noted above