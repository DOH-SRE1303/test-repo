### Final date cut, geographic almagamation, summary stats. 

load("heatmaps.RData")

load("All_ML.RData")

for (facility_name in names(Admit_LOS_prophet_CAH)) {
  
  Admit_LOS_prophet_CAH[[facility_name]]$Hospital_Name <- facility_name
  cap_dur_prophet_CAH[[facility_name]]$Hospital_Name <- facility_name
  Complete_LOS_tables_CAH[[facility_name]]$Hospital_Name <- facility_name
  dis_prophet_CAH[[facility_name]]$Hospital_Name <- facility_name
  
  
  Admit_LOS_prophet_CAH[[facility_name]]$Hospital_Type <- "CAH"
  cap_dur_prophet_CAH[[facility_name]]$Hospital_Type <- "CAH"
  Complete_LOS_tables_CAH[[facility_name]]$Hospital_Type <- "CAH"
  dis_prophet_CAH[[facility_name]]$Hospital_Type <- "CAH"
  
}

for (facility_name in names(Admit_LOS_prophet_NED)) {
  
  Admit_LOS_prophet_NED[[facility_name]]$Hospital_Name <- facility_name
  cap_dur_prophet_NED[[facility_name]]$Hospital_Name <- facility_name
  Complete_LOS_tables_NED[[facility_name]]$Hospital_Name <- facility_name
  dis_prophet_NED[[facility_name]]$Hospital_Name <- facility_name
  
  Admit_LOS_prophet_NED[[facility_name]]$Hospital_Type <- "NED"
  cap_dur_prophet_NED[[facility_name]]$Hospital_Type <- "NED"
  Complete_LOS_tables_NED[[facility_name]]$Hospital_Type <- "NED"
  dis_prophet_NED[[facility_name]]$Hospital_Type <- "NED"
  
}


for (facility_name in names(Admit_LOS_prophet_ED)) {
  
  Admit_LOS_prophet_ED[[facility_name]]$Hospital_Name <- facility_name
  cap_dur_prophet_ED[[facility_name]]$Hospital_Name <- facility_name
  Complete_LOS_tables_ED[[facility_name]]$Hospital_Name <- facility_name
  dis_prophet_ED[[facility_name]]$Hospital_Name <- facility_name
  
  
  Admit_LOS_prophet_ED[[facility_name]]$Hospital_Type <- "ED"
  cap_dur_prophet_ED[[facility_name]]$Hospital_Type <- "ED"
  Complete_LOS_tables_ED[[facility_name]]$Hospital_Type <- "ED"
  dis_prophet_ED[[facility_name]]$Hospital_Type <- "ED"
  
  
}

library(dplyr)

Merged_Admit_LOS <- as.data.frame(do.call(bind_rows, c(Admit_LOS_prophet_CAH, Admit_LOS_prophet_ED, Admit_LOS_prophet_NED)))
Merged_cap_dur <- do.call(bind_rows, c(cap_dur_prophet_CAH, cap_dur_prophet_ED, cap_dur_prophet_NED))


#Merged_Comorb <- do.call(bind_rows, c(lapply(Complete_comorb_tables_CAH, as.data.frame), lapply(Complete_comorb_tables_ED, as.data.frame), lapply(Complete_comorb_tables_NED, as.data.frame)))
#Merged_Diag  <- do.call(bind_rows, c(Complete_diag_tables_CAH, Complete_diag_tables_ED, Complete_diag_tables_NED))
#Merged_diag_LOS <- do.call(bind_rows, c(Complete_LOS_tables_CAH, Complete_LOS_tables_ED, Complete_LOS_tables_NED))


Merged_dis <- do.call(bind_rows, c(dis_prophet_CAH, dis_prophet_ED, dis_prophet_NED))


Complete_comorb_tables_CAH[[1]]










save(Merged_Admit_LOS, Merged_cap_dur, Merged_dis, admit_heatmap, discharge_heatmap, file = "Completed_Dataframes.RData")
