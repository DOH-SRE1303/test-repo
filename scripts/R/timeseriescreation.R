
load("Categorized_Hosp_Data.RData")

library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
### Create timeseries lists

ts_ED_Hosp_ad <- list()
ts_NED_Hosp_ad <- list()
ts_CAH_Hosp_ad <- list()

ts_ED_Hosp_ds <- list()
ts_NED_Hosp_ds <- list()
ts_CAH_Hosp_ds <- list()

ts_ED_Hosp_LOS <- list()
ts_NED_Hosp_LOS <- list()
ts_CAH_Hosp_LOS <- list()

ts_ED_Hosp_Cap <- list()
ts_NED_Hosp_Cap <- list()
ts_CAH_Hosp_Cap <- list()




## Function to create timeseries set dataframes
create_TS_series_df <- function(data){
  data <- data %>%
  group_by(hospital_name, admission_date) %>%
    dplyr::summarize(avg_length_of_stay = mean(round(time_of_stay/60/60,1), na.rm = TRUE),
                     sd_length_of_stay = sd(time_of_stay/60/60), 
                     number_admits = dplyr::n())
  
  data$avg_length_of_stay[data$avg_length_of_stay < 0] <- 0
  return(data)
}


### Create one for discharges as well.

create_TS_series_df_dis <- function(data){
  data <- data %>%
    group_by(hospital_name, discharge_date) %>%
    dplyr::summarize(number_discharges = dplyr::n())
  return(data)
}


### Create one for census

### Create timeseries for LOS
create_TS_list_LOS <- function(data){

ts_Fac <- list()
  
for (HospitalName in unique(data$hospital_name)) {
  AC_TS_DF <- data[data$hospital_name == HospitalName,]
  AC_TS_DF <- AC_TS_DF[complete.cases(AC_TS_DF$admission_date),]
  if(nrow(AC_TS_DF)==0){
    warning(paste("No data for facility:", HospitalName))
    next
  }
  
  inter_ts <- ts(AC_TS_DF$avg_length_of_stay, start = min(as.Date(AC_TS_DF$admission_date)), frequency = 365)
  ts_Fac[[HospitalName]] <- inter_ts
  rm(inter_ts)
  rm(AC_TS_DF)
}
return(ts_Fac)

}



create_TS_list_Admits <- function(data){
  
  ts_Fac <- list()
  
  for (HospitalName in unique(data$hospital_name)) {
    AC_TS_DF <- data[data$hospital_name == HospitalName,]
    AC_TS_DF <- AC_TS_DF[complete.cases(AC_TS_DF$admission_date),]
    if(nrow(AC_TS_DF)==0){
      warning(paste("No data for facility:", HospitalName))
      next
    }
    
    inter_ts <- ts(AC_TS_DF$number_admits, start = min(as.Date(AC_TS_DF$admission_date)), frequency = 365)
    ts_Fac[[HospitalName]] <- inter_ts
    rm(inter_ts)
    rm(AC_TS_DF)
  }
  return(ts_Fac)
  
}





create_TS_list_Discharge <- function(data){
  
  ts_Fac <- list()
  
  for (HospitalName in unique(data$hospital_name)) {
    AC_TS_DF <- data[data$hospital_name == HospitalName,]
    AC_TS_DF <- AC_TS_DF[complete.cases(AC_TS_DF$discharge_date),]
    if(nrow(AC_TS_DF)==0){
      warning(paste("No data for facility:", HospitalName))
      next
    }
    
    inter_ts <- ts(AC_TS_DF$number_discharges, start = min(as.Date(AC_TS_DF$discharge_date)), frequency = 365)
    ts_Fac[[HospitalName]] <- inter_ts
    rm(inter_ts)
    rm(AC_TS_DF)
  }
  return(ts_Fac)
  
}



## Function to create timeseries set dataframes for census
library(data.table)


create_TS_series_df_Cap <- function(hospital_visits_df){
  

  
  result <- hospital_visits_df %>%
    mutate(admission_datetime = ymd_h(paste(admission_date, admission_hour, sep = " ")),
           discharge_datetime = ymd_h(paste(discharge_date, discharge_hour, sep = " ")),
           hourly_timestamps = map2(admission_datetime, discharge_datetime, seq, by = "hour")) %>%
    unnest(hourly_timestamps) %>%
    group_by(hospital_name, hourly_timestamps, Beds_Total) %>%
    summarize(patient_count = n(), .groups = "drop") %>%
    group_by(date = date(hourly_timestamps), hour = hour(hourly_timestamps), Beds_Total, patient_count, .drop = TRUE) %>%
    summarize(hourly_occupancy = sum(patient_count) / first(Beds_Total)) %>%
    group_by(date, hour, Beds_Total, patient_count, .drop = TRUE) %>%
    summarize(max_patient_count = max(patient_count)) %>%
    filter(patient_count == max_patient_count) %>% 
    group_by(date, max_patient_count) %>% 
    summarize(duration = n()) %>%
    filter(duration == max(duration)) %>%
    filter(date >= "2018-01-01")
  
  result$Total_Beds <- first(hospital_visits_df$Total_Beds)
  
  return(result)
  
  
}






### Create Timeseries for Admits  and Discharges




## Create ts_dfs, maybe use these to compare across? 
ts_df_NED <- create_TS_series_df(Hosp_without_ED)
ts_df_ED <- create_TS_series_df(Hosp_with_ED)
ts_df_CAH <- create_TS_series_df(CAH_Hosp)


ts_df_NED_dis <- create_TS_series_df_dis(Hosp_without_ED)
ts_df_ED_dis <- create_TS_series_df_dis(Hosp_with_ED)
ts_df_CAH_dis <- create_TS_series_df_dis(CAH_Hosp)




## Create TS lists
#ts_ED_Hosp_LOS <- create_TS_list_LOS(ts_df_ED)
#ts_NED_Hosp_LOS <- create_TS_list_LOS(ts_df_NED)
#ts_CAH_Hosp_LOS <- create_TS_list_LOS(ts_df_CAH)


#ts_ED_Hosp_ad <- create_TS_list_Admits(ts_df_ED)
#ts_NED_Hosp_ad <- create_TS_list_Admits(ts_df_NED)
#ts_CAH_Hosp_ad <- create_TS_list_Admits(ts_df_CAH)

#ts_ED_Hosp_ds <- create_TS_list_Discharge(ts_df_ED_dis)
#ts_NED_Hosp_ds <- create_TS_list_Discharge(ts_df_NED_dis)
#ts_CAH_Hosp_ds <- create_TS_list_Discharge(ts_df_CAH_dis)



### Not actual TS but useful to format it similar to.
for (HospitalName in unique(Hosp_with_ED$hospital_name)) {
ts_ED_Hosp_Cap[[HospitalName]] <- create_TS_series_df_Cap(Hosp_with_ED[Hosp_with_ED$hospital_name == HospitalName,])
}


for (HospitalName in unique(Hosp_without_ED$hospital_name)) {
  ts_NED_Hosp_Cap[[HospitalName]] <- create_TS_series_df_Cap(Hosp_without_ED[Hosp_without_ED$hospital_name == HospitalName,])
}



for (HospitalName in unique(CAH_Hosp$hospital_name)) {
  ts_CAH_Hosp_Cap[[HospitalName]] <- create_TS_series_df_Cap(CAH_Hosp[CAH_Hosp$hospital_name == HospitalName,])
}



### Need to filter out 1 year of backfill to ensure numbers look better. 








### Find ICD-10 BY  MONTH

### first isolate to ID, Hospital, Admission Date, LOS_Hours (stay type for later)

ICD_CAH <- select(CAH_Hosp, discharge_record_id, staytype, hospital_name, admission_date, LOS_Hours, DiagnosisCodes ) %>%
  separate_rows("DiagnosisCodes", sep = " ")
ICD_CAH$DiagnosisCodes <- substr(ICD_CAH$DiagnosisCodes, 1, 3)


ICD_ED <- select(Hosp_with_ED, discharge_record_id, staytype, hospital_name, admission_date, LOS_Hours, DiagnosisCodes )%>%
  separate_rows("DiagnosisCodes", sep = " ")
ICD_ED$DiagnosisCodes <- substr(ICD_ED$DiagnosisCodes, 1, 3)

ICD_NED <- select(Hosp_without_ED, discharge_record_id, staytype, hospital_name, admission_date, LOS_Hours, DiagnosisCodes )%>%
  separate_rows("DiagnosisCodes", sep = " ")

ICD_NED$DiagnosisCodes <- substr(ICD_NED$DiagnosisCodes, 1, 3)



ICD_Groupings <- function(df){
  result <- df
  
  labels <- c("Certain infectious and parasitic diseases",  
              "Neoplasms",
              "Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism",
              "Endocrine, nutritional and metabolic diseases",
              "Mental, Behavioral and Neurodevelopmental disorders", 
              "Diseases of the nervous system",
              "Diseases of the eye and adnexa",
              "Diseases of the ear and mastoid process",
              "Diseases of the circulatory system",
              "Diseases of the respiratory system",
              "Diseases of the digestive system",
              "Diseases of the skin and subcutaneous tissue", 
              "Diseases of the musculoskeletal system and connective tissue",
              "Diseases of the genitourinary system",
              "Pregnancy, childbirth and the puerperium",
              "Certain conditions originating in the perinatal period", 
              "Congenital malformations, deformations and chromosomal abnormalities",
              "Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified",
              "Injury, poisoning and certain other consequences of external causes",
              "External causes of morbidity",
              "Factors influencing health status and contact with health services"
              )
  
 
  
  
   regex1 <- "^[A-B][0-9]{2}$"
  
  ## PAIRED
  regex2 <- "^[C][0-9]{2}$"
  regex2_1 <- "^[D][0-4][0-9]$"
  regex3 <- "^[D][5-8][0-9]$"
  regex4 <- "^[E][0-8][0-9]$"
  regex5 <- "^[F][0-9][0-9]$"
  regex6 <- "^[G][0-9][0-9]$"
  regex7 <- "^[H][0-5][0-9]$"
  regex8 <- "^[H][6-9][0-9]$"
  regex9 <- "^[I][0-9][0-9]$"
  regex10 <- "^[J][0-9][0-9]$"
  regex11 <- "^[K][0-9][0-9]$"
  regex12 <- "^[L][0-9][0-9]$"
  regex13 <- "^[M][0-9][0-9]$"
  regex14 <- "^[N][0-9][0-9]$"
  regex15 <- "^[O][0-9][0-9]$"
  regex16 <- "^[P][0-9][0-9]$"
  regex17 <- "^[Q][0-9][0-9]$"
  regex18 <- "^[R][0-9][0-9]$"
  regex19 <- "^[S-T][0-9][0-9]$"
  regex20 <- "^[V-Y][0-9][0-9]$"
  regex21 <- "^[Z][0-9][0-9]$"
  
  
  result$DiagnosisDescript <- ""
  
  result$DiagnosisDescript[grep(regex1, result$DiagnosisCodes)] <- labels[1]
  result$DiagnosisDescript[grep(regex2_1, result$DiagnosisCodes)] <- labels[2]
  result$DiagnosisDescript[grep(regex2, result$DiagnosisCodes)] <- labels[2]
  result$DiagnosisDescript[grep(regex3, result$DiagnosisCodes)] <- labels[3]
  result$DiagnosisDescript[grep(regex4, result$DiagnosisCodes)] <- labels[4]
  result$DiagnosisDescript[grep(regex5, result$DiagnosisCodes)] <- labels[5]
  result$DiagnosisDescript[grep(regex6, result$DiagnosisCodes)] <- labels[6]
  result$DiagnosisDescript[grep(regex7, result$DiagnosisCodes)] <- labels[7]
  result$DiagnosisDescript[grep(regex8, result$DiagnosisCodes)] <- labels[8]
  result$DiagnosisDescript[grep(regex9, result$DiagnosisCodes)] <- labels[9]
  result$DiagnosisDescript[grep(regex10, result$DiagnosisCodes)] <- labels[10]
  result$DiagnosisDescript[grep(regex11, result$DiagnosisCodes)] <- labels[11]
  result$DiagnosisDescript[grep(regex12, result$DiagnosisCodes)] <- labels[12]
  result$DiagnosisDescript[grep(regex13, result$DiagnosisCodes)] <- labels[13]
  result$DiagnosisDescript[grep(regex14, result$DiagnosisCodes)] <- labels[14]
  result$DiagnosisDescript[grep(regex15, result$DiagnosisCodes)] <- labels[15]
  result$DiagnosisDescript[grep(regex16, result$DiagnosisCodes)] <- labels[16]
  result$DiagnosisDescript[grep(regex17, result$DiagnosisCodes)] <- labels[17]
  result$DiagnosisDescript[grep(regex18, result$DiagnosisCodes)] <- labels[18]
  result$DiagnosisDescript[grep(regex19, result$DiagnosisCodes)] <- labels[19]
  result$DiagnosisDescript[grep(regex20, result$DiagnosisCodes)] <- labels[20]
  result$DiagnosisDescript[grep(regex21, result$DiagnosisCodes)] <- labels[21]
  
  
  
  return(result)
}





### Do this by week/year instead of by day. 
comorbs_counts <- function(df){

 df$admission_date <- week(df$admission_date)
  
diagnosis_counts <-  df %>%
  group_by(hospital_name, admission_date, discharge_record_id) %>%
  summarize(primary_diagnosis_code = first(DiagnosisCodes),
            primary_diagnosis_desc = first(DiagnosisDescript),
            comorbidity_codes = paste0(DiagnosisCodes[-1], collapse = ";"),
            comorbidity_descs = paste0(DiagnosisDescript[-1], collapse = ";")) %>%
  ungroup()


## WEEK NOT DAY
# Get the top 10 primary diagnosis descriptions with comorbidities for each hospital and day
top_diagnoses <- diagnosis_counts %>%
  group_by(hospital_name, admission_date, primary_diagnosis_desc) %>%
  summarize(comorbidity_descs = unique(comorbidity_descs)) %>%
  ungroup() %>%
  group_by(hospital_name, admission_date) %>%
  top_n(5, wt = n_distinct(primary_diagnosis_desc)) %>%
  ungroup()

# Get the top 10 primary diagnosis descriptions and comorbidities for each hospital and day
top_comorbidities <- diagnosis_counts %>%
  group_by(hospital_name, admission_date, primary_diagnosis_desc, comorbidity_descs) %>%
  summarize(n = n()) %>%
  filter(primary_diagnosis_desc != comorbidity_descs) %>%
  arrange(hospital_name, admission_date, desc(n)) %>%
  group_by(hospital_name, admission_date) %>%
  top_n(5, n) %>%
  ungroup()



top_los <- df %>%
  group_by(hospital_name, admission_date, DiagnosisDescript) %>%
  top_n(5, LOS_Hours) %>%
  arrange(hospital_name, admission_date, desc(LOS_Hours))



result_list <- list(top_diagnoses, top_comorbidities, top_los)

return(result_list)
}




ICD_CAH <- ICD_Groupings(ICD_CAH) %>%
  distinct()
ICD_ED <- ICD_Groupings(ICD_ED) %>%
  distinct()
ICD_NED <- ICD_Groupings(ICD_NED) %>%
  distinct()


diag_comorb_LOS_CAH <- comorbs_counts(ICD_CAH)

diag_comorb_LOS_ED <- comorbs_counts(ICD_ED)

diag_comorb_LOS_NED <- comorbs_counts(ICD_NED)


## What do I want to answer: What are daily trends in ICD-10 diagnosis + comorbs ? Weel;y. done







## Create a list of Hospital Names, number of beds, geographic coords

HospNameandBeds <- rbind(CAH_Hosp, Hosp_with_ED, Hosp_without_ED) %>%
  select(hospital_name, Beds_Total) %>%
  unique()



### Change ds_ad_cap all to the same dataframe. Maybe keep it 

save( ts_df_CAH, ts_df_CAH_dis, diag_comorb_LOS_CAH, ts_CAH_Hosp_Cap,
      ts_df_ED, ts_df_ED_dis, diag_comorb_LOS_ED, ts_ED_Hosp_Cap,
      ts_df_NED, ts_df_NED_dis, diag_comorb_LOS_NED, ts_NED_Hosp_Cap,
      HospNameandBeds,
      file = "AllTSData.RData"
      )




