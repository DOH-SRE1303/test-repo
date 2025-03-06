load("CHARS_Data.RData")

library(dplyr)

## Create time of stay in Hours estimate
 df$LOS_Hours <- round(df$time_of_stay /60/60, 0 )


### Create interim facility label for ED/NOT ED based on admit type code. 1 == Emergency, so any facility with emergency goes through ESSENCE validation.

Interim_ED_Classifier <- df %>%
  group_by(hospital_name) %>%
  summarize(has_admit_1 = any(admit_type_code == 1))

Interim_CAH_Classifier <- df %>%
  group_by(hospital_name) %>%
  summarize(CAH_Hosp = any(critical_access_hospital))


### FOR PURE CHARS ESTIMATES, NEED ANY FACILITY WITHOUT 1 IN ADMIT TYPE
Hosp_without_ED <- df %>%
  filter(!(hospital_name %in% Interim_ED_Classifier$hospital_name[Interim_ED_Classifier$has_admit_1])) %>%
  filter(!(hospital_name %in% Interim_CAH_Classifier$hospital_name[Interim_CAH_Classifier$CAH_Hosp])) %>%
  arrange(hospital_name)
  



### FOR CHARS/RHINO MERGE, NEED ANY FACILITY WITH 1 IN ADMIT TYPE
Hosp_with_ED <- df %>%
  filter(hospital_name %in% Interim_ED_Classifier$hospital_name[Interim_ED_Classifier$has_admit_1]) %>%
  filter(!(hospital_name %in% Interim_CAH_Classifier$hospital_name[Interim_CAH_Classifier$CAH_Hosp])) %>%
  arrange(hospital_name)


### FOR CAH Hospitals


CAH_Hosp <- df %>%  
  filter((hospital_name %in% Interim_CAH_Classifier$hospital_name[Interim_CAH_Classifier$CAH_Hosp])) %>%
  arrange(hospital_name)
  

##remove interim and DF to clear extra space. 
rm(df)
rm(Interim_ED_Classifier)

## Deal with non-EDs first


save(CAH_Hosp, Hosp_with_ED, Hosp_without_ED, file = "Categorized_Hosp_Data.RData")