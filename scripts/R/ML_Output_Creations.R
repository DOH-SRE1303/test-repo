load("AllTSData.RData")

library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
library(prophet)

## Create timeseries of all frames as needed. 



## Create weeks predictor for ICD-10
### Comorbs list are in order: top_diagnoses, top_comorbidities, top_los
Complete_diag_tables_ED <- list()
Complete_diag_tables_NED <- list()
Complete_diag_tables_CAH <- list()

Complete_comorb_tables_ED <- list()
Complete_comorb_tables_NED <- list()
Complete_comorb_tables_CAH <- list()

Complete_LOS_tables_ED <- list()
Complete_LOS_tables_NED <- list()
Complete_LOS_tables_CAH <- list()




########### For each hospital, iterate down each week, and combine and weigh ICD groups
create_week_PD_pred <- function(list1, date1 = week(Sys.Date())){
  

  date_neg_1 = week(Sys.Date())-1
  date1 = week(Sys.Date())
  date2 = week(Sys.Date())+1 
  
  ### NEED TO GO BACK AND MAKE WEEK AND YEAR 
  #     average_census = total_by_week / 7) %>%
  
  ### This can be used as fractional. 
 Current_Week_Diags <-  as.data.frame(list1) %>%
 
    filter(admission_date == date1) %>%
    select(hospital_name, admission_date, primary_diagnosis_desc) %>%
    group_by(hospital_name, admission_date, primary_diagnosis_desc) %>% 
    summarise( "total_visits" = n()) %>%
    group_by(hospital_name, admission_date) %>%
    mutate(total_by_week = sum(total_visits),
           percent_of_visits  = (total_visits/ total_by_week)*100 ) %>%
    arrange(desc(total_visits)) %>%
   head(10)
  ## Check Historical Census rotation
 Previous_Week_Diags <-  as.data.frame(list1) %>%

   filter(admission_date == date_neg_1) %>%
   select(hospital_name, admission_date, primary_diagnosis_desc) %>%
   group_by(hospital_name, admission_date, primary_diagnosis_desc) %>% 
   summarise( "total_visits" = n()) %>%
   group_by(hospital_name, admission_date) %>%
   mutate(total_by_week = sum(total_visits),
          percent_of_visits  = (total_visits/ total_by_week)*100) %>%
   arrange(desc(total_visits))  %>%
   head(10)
 
Next_Week_Diags <-   as.data.frame(list1) %>%
  filter(admission_date == date2) %>%
  select(hospital_name, admission_date, primary_diagnosis_desc) %>%
  group_by(hospital_name, admission_date, primary_diagnosis_desc) %>% 
  summarise( "total_visits" = n()) %>%
  group_by(hospital_name, admission_date) %>%
  mutate(total_by_week = sum(total_visits) ,
         percent_of_visits  = (total_visits/ total_by_week)*100) %>%
  arrange(desc(total_visits))  %>%
  head(10)

result_list <- list(Previous_Week_Diags, Current_Week_Diags, Next_Week_Diags)
 
return(result_list)
}

## for comorbidities
create_week_CM_pred  <- function(list1, date1 = week(Sys.Date())){
  date_neg_1 = week(Sys.Date())-1
  date1 = week(Sys.Date())
  date2 = week(Sys.Date())+1 
  
  ### NEED TO GO BACK AND MAKE WEEK AND YEAR 
  #    average_census = total_by_week / 7) %>%
  ### This can be used as fractional. 
  Current_Week_CMs <-  as.data.frame(list1) %>%
    filter(admission_date == date1) %>%
    select(hospital_name, admission_date, comorbidity_descs)
  
  if(nrow(Current_Week_CMs) == 0){
    Current_Week_CMs <- data.frame(
      comorbidity_descs = 'No value',
      total_CMs = 0,
      total_by_week = 0,
      percent_of_Cms = 0
    )
  }else{
  
 Current_Week_CMs <-   data.frame( "CMs" = unlist(strsplit( Current_Week_CMs$comorbidity_descs, ";"))) %>%
    group_by(CMs) %>% 
    summarise( "total_CMs" = n()) %>%
  #  group_by(hospital_name, admission_date) %>%
    mutate(total_by_week = sum(total_CMs),
           percent_of_CMs  = (total_CMs/ total_by_week)*100 ) %>%
    arrange(desc(percent_of_CMs)) %>%
    head(5)
  }
  ## Check Historical Census rotation
   Previous_Week_CMs <-  as.data.frame(list1) %>%
    filter(admission_date == date_neg_1) %>%
    select(hospital_name, admission_date, comorbidity_descs)
   
   
   if(nrow(Previous_Week_CMs) == 0){
     Previous_Week_CMs <- data.frame(
       comorbidity_descs = 'No value',
       total_CMs = 0,
       total_by_week = 0,
       percent_of_Cms = 0
     )
   }else{
  
   Previous_Week_CMs <-   data.frame( "CMs" = unlist(strsplit( Previous_Week_CMs$comorbidity_descs, ";"))) %>%
    group_by(CMs) %>% 
    summarise( "total_CMs" = n()) %>%
    # group_by(hospital_name, admission_date) %>%
    mutate(total_by_week = sum(total_CMs),
           percent_of_CMs  = (total_CMs/ total_by_week)*100 ) %>%
    arrange(desc(percent_of_CMs)) %>%
    head(5)
   }
  
   
   
   
  Next_Week_CMs <-   as.data.frame(list1) %>%
    filter(admission_date == date2) %>%
    select(hospital_name, admission_date, comorbidity_descs)
  
  
  
  
  if(nrow(Next_Week_CMs) == 0){
    Next_Week_CMs <- data.frame(
      comorbidity_descs = 'No value',
      total_CMs = 0,
      total_by_week = 0,
      percent_of_Cms = 0
    )
  }else{
  Next_Week_CMs <-   data.frame( "CMs" = unlist(strsplit( Next_Week_CMs$comorbidity_descs, ";"))) %>%
    group_by(CMs) %>% 
    summarise( "total_CMs" = n()) %>%
    #  group_by(hospital_name, admission_date) %>%
   mutate(total_by_week = sum(total_CMs),
           percent_of_CMs  = (total_CMs/ total_by_week)*100 ) %>%
    arrange(desc(percent_of_CMs)) %>%
    head(5)
  }
   
CM_List <- list(Previous_Week_CMs, Current_Week_CMs, Next_Week_CMs)  

return(CM_List)  
  
}


Create_week_LOS_pred <- function(list1, date1 = week(Sys.Date())){
  
 
  date_neg_1 = week(Sys.Date())-1
  date1 = week(Sys.Date())
  date2 = week(Sys.Date())+1 
  
  
  
  
  Current_Week_LOS <-  as.data.frame(list1) %>%
    filter(admission_date == date1) %>%
    select(hospital_name, admission_date, DiagnosisDescript, LOS_Hours) %>%
    group_by(hospital_name, admission_date, DiagnosisDescript) %>% 
    summarise( "Average_LOS" = mean(LOS_Hours), 
               "Median_LOS" = median(LOS_Hours),
               "SD_LOS" = sd(LOS_Hours)) %>%
    arrange(desc(Average_LOS)) %>%
    head(5)
  
  
  Last_Week_LOS <- as.data.frame(list1) %>%
    filter(admission_date == date_neg_1) %>%
    select(hospital_name, admission_date, DiagnosisDescript, LOS_Hours) %>%
    group_by(hospital_name, admission_date, DiagnosisDescript) %>% 
    summarise( "Average_LOS" = mean(LOS_Hours), 
               "Median_LOS" = median(LOS_Hours),
               "SD_LOS" = sd(LOS_Hours)) %>%
    arrange(desc(Average_LOS)) %>%
    head(5)
  
  Next_Week_LOS <- as.data.frame(list1) %>%
    filter(admission_date == date2 ) %>%
    select(hospital_name, admission_date, DiagnosisDescript, LOS_Hours) %>%
    group_by(hospital_name, admission_date, DiagnosisDescript) %>% 
    summarise( "Average_LOS" = mean(LOS_Hours), 
               "Median_LOS" = median(LOS_Hours),
               "SD_LOS" = sd(LOS_Hours)) %>%
    arrange(desc(Average_LOS)) %>%
    head(5)
  
  
  result_list <- list(Last_Week_LOS, Current_Week_LOS, Next_Week_LOS)
  
  return(result_list)    
    
    
}




for (HospitalName in unique(diag_comorb_LOS_CAH[[1]]$hospital_name)) {
  Complete_diag_tables_CAH[[HospitalName]] <- create_week_PD_pred(diag_comorb_LOS_CAH[[1]][diag_comorb_LOS_CAH[[1]]$hospital_name == HospitalName,])
}

for (HospitalName1 in unique(diag_comorb_LOS_CAH[[2]]$hospital_name)) {
  Complete_comorb_tables_CAH[[HospitalName1]] <- create_week_CM_pred(diag_comorb_LOS_CAH[[2]][diag_comorb_LOS_CAH[[2]]$hospital_name == HospitalName1,])
}



for (HospitalName2 in unique(diag_comorb_LOS_CAH[[3]]$hospital_name)) {
  Complete_LOS_tables_CAH[[HospitalName2]] <- Create_week_LOS_pred(diag_comorb_LOS_CAH[[3]][diag_comorb_LOS_CAH[[3]]$hospital_name == HospitalName2,])
}





for (HospitalName in unique(diag_comorb_LOS_ED[[1]]$hospital_name)) {
  Complete_diag_tables_ED[[HospitalName]] <- create_week_PD_pred(diag_comorb_LOS_ED[[1]][diag_comorb_LOS_ED[[1]]$hospital_name == HospitalName,])
}

for (HospitalName1 in unique(diag_comorb_LOS_ED[[2]]$hospital_name)) {
  Complete_comorb_tables_ED[[HospitalName1]] <- create_week_CM_pred(diag_comorb_LOS_ED[[2]][diag_comorb_LOS_ED[[2]]$hospital_name == HospitalName1,])
}



for (HospitalName2 in unique(diag_comorb_LOS_ED[[3]]$hospital_name)) {
  Complete_LOS_tables_ED[[HospitalName2]] <- Create_week_LOS_pred(diag_comorb_LOS_ED[[3]][diag_comorb_LOS_ED[[3]]$hospital_name == HospitalName2,])
}



for (HospitalName in unique(diag_comorb_LOS_NED[[1]]$hospital_name)) {
  Complete_diag_tables_NED[[HospitalName]] <- create_week_PD_pred(diag_comorb_LOS_NED[[1]][diag_comorb_LOS_NED[[1]]$hospital_name == HospitalName,])
}

for (HospitalName1 in unique(diag_comorb_LOS_NED[[2]]$hospital_name)) {
  Complete_comorb_tables_NED[[HospitalName1]] <- create_week_CM_pred(diag_comorb_LOS_NED[[2]][diag_comorb_LOS_NED[[2]]$hospital_name == HospitalName1,])
}



for (HospitalName2 in unique(diag_comorb_LOS_NED[[3]]$hospital_name)) {
  Complete_LOS_tables_NED[[HospitalName2]] <- Create_week_LOS_pred(diag_comorb_LOS_NED[[3]][diag_comorb_LOS_NED[[3]]$hospital_name == HospitalName2,])
}


### LOS, PRIMARY, COMORB TABLES DONE



### Now do TS for Capacity, admits, discharge

create_prophet <- function(df, HospitalName, bedcap = HospNameandBeds){
  
  #Create STLF Model and params
  # fitets <- stlf(ts, s.window = "periodic")
  horizon = 1000
  #  intervalSTLF <- forecast(fitets, h = horizon, level = c(80, 95))
  #  STLF_DF <- data.frame(MeanSTLF = intervalSTLF$mean, UpperSTLF = intervalSTLF$upper[1:10], LowerSTLF = intervalSTLF$lower[1:10])
  
  bedcap <- bedcap[bedcap$hospital_name == HospitalName,]
  
  df <- df[df$hospital_name == HospitalName,]
  
  df <- df[complete.cases(df$admission_date),]
  
  prophet_df <- data.frame(ds = df$admission_date, y = df$avg_length_of_stay)
  
  prophet_df_admit <- data.frame(ds = df$admission_date, y = df$number_admits)
  
  m <- prophet(yearly.seasonality = TRUE)
  
  adm <- prophet(yearly.seasonality = TRUE)
  
  m <- fit.prophet(m, prophet_df)
  
  adm <- fit.prophet(adm, prophet_df_admit)
  
  future <- make_future_dataframe(m, periods = horizon)
  
  future_admit <- make_future_dataframe(adm, periods = horizon)
  
  
  forecast <- predict(m, future)
  ## If trend is negative, mark as zero, same with yhat lower
  forecast <- select(forecast, ds, yhat, yhat_lower, yhat_upper)
  forecast$yhat <- ifelse(forecast$yhat < 0, 0, forecast$yhat)
  forecast$yhat_upper <- ifelse(forecast$yhat_upper < 0, 0, forecast$yhat_upper)
  forecast$yhat_lower <- ifelse(forecast$yhat_lower < 0, 0, forecast$yhat_lower)
  
  
  forecast_admits <- predict(adm, future_admit)
  
  
  forecast_admits <- select(forecast_admits, ds, yhat, yhat_lower, yhat_upper)
  forecast_admits$yhat <- ifelse(forecast_admits$yhat < 0, 0, forecast_admits$yhat)
  forecast_admits$yhat_upper <- ifelse(forecast_admits$yhat_upper < 0, 0, forecast_admits$yhat_upper)
  forecast_admits$yhat_lower <- ifelse(forecast_admits$yhat_lower < 0, 0, forecast_admits$yhat_lower)
  forecast_admits$yhat <- ifelse(forecast_admits$yhat > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat)
  forecast_admits$yhat_upper <- ifelse(forecast_admits$yhat_upper > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat_upper)
  forecast_admits$yhat_lower <- ifelse(forecast_admits$yhat_lower > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat_lower)

 
  return_list <- as.list(forecast, forecast_admits)
  return(return_list)
}




create_prophet_dis <- function(df, HospitalName, bedcap = HospNameandBeds){
  
  #Create STLF Model and params
  # fitets <- stlf(ts, s.window = "periodic")
  horizon = 1000
  #  intervalSTLF <- forecast(fitets, h = horizon, level = c(80, 95))
  #  STLF_DF <- data.frame(MeanSTLF = intervalSTLF$mean, UpperSTLF = intervalSTLF$upper[1:10], LowerSTLF = intervalSTLF$lower[1:10])
  
  bedcap <- bedcap[bedcap$hospital_name == HospitalName,]
  
  df <- df[df$hospital_name == HospitalName,]
  
  df <- df[complete.cases(df$discharge_date),]
  
  prophet_df <- data.frame(ds = df$discharge_date, y = df$number_discharges)
  
  m <- prophet(yearly.seasonality = TRUE)

  m <- fit.prophet(m, prophet_df)
  

  future <- make_future_dataframe(m, periods = horizon)
  
  
  forecast <- predict(m, future)
  ## If trend is negative, mark as zero, same with yhat lower
  forecast <- select(forecast, ds, yhat, yhat_lower, yhat_upper)
  forecast$yhat <- ifelse(forecast$yhat < 0, 0, forecast$yhat)
  forecast$yhat_upper <- ifelse(forecast$yhat_upper < 0, 0, forecast$yhat_upper)
  forecast$yhat_lower <- ifelse(forecast$yhat_lower < 0, 0, forecast$yhat_lower)
  

  
  return_list <- as.list(forecast)
  return(return_list)
}












create_prophet_cap <- function(df, HospitalName, bedcap = HospNameandBeds){
  
  
  #Create STLF Model and params
  # fitets <- stlf(ts, s.window = "periodic")
  horizon = 1000
  #  intervalSTLF <- forecast(fitets, h = horizon, level = c(80, 95))
  #  STLF_DF <- data.frame(MeanSTLF = intervalSTLF$mean, UpperSTLF = intervalSTLF$upper[1:10], LowerSTLF = intervalSTLF$lower[1:10])
  
  bedcap <- bedcap[bedcap$hospital_name == HospitalName,]
  
  df <- as.data.frame(df[names(df) == HospitalName])
  colnames(df) <- c("date", "max_patient_count", "duration")
  
  df <- df[complete.cases(df$date),]
  
  prophet_df <- data.frame(ds = df$date, y = df$max_patient_count)
  
  prophet_df_dur <- data.frame(ds = df$date, y = df$duration)
  
  m <- prophet(yearly.seasonality = TRUE)
  
  adm <- prophet(yearly.seasonality = TRUE)
  
  m <- fit.prophet(m, prophet_df)
  
  adm <- fit.prophet(adm, prophet_df_dur)
  
  future <- make_future_dataframe(m, periods = horizon)
  
  future_dur <- make_future_dataframe(adm, periods = horizon)
  
  
  forecast <- predict(m, future)
  ## If trend is negative, mark as zero, same with yhat lower
  forecast <- select(forecast, ds, yhat, yhat_lower, yhat_upper)
  forecast$yhat <- ifelse(forecast$yhat < 0, 0, forecast$yhat)
  forecast$yhat_upper <- ifelse(forecast$yhat_upper < 0, 0, forecast$yhat_upper)
  forecast$yhat_lower <- ifelse(forecast$yhat_lower < 0, 0, forecast$yhat_lower)
  
  
  forecast_admits <- predict(adm, future_dur)
  
  
  forecast_admits <- select(forecast_admits, ds, yhat, yhat_lower, yhat_upper)
  forecast_admits$yhat <- ifelse(forecast_admits$yhat < 0, 0, forecast_admits$yhat)
  forecast_admits$yhat_upper <- ifelse(forecast_admits$yhat_upper < 0, 0, forecast_admits$yhat_upper)
  forecast_admits$yhat_lower <- ifelse(forecast_admits$yhat_lower < 0, 0, forecast_admits$yhat_lower)
  forecast_admits$yhat <- ifelse(forecast_admits$yhat > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat)
  forecast_admits$yhat_upper <- ifelse(forecast_admits$yhat_upper > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat_upper)
  forecast_admits$yhat_lower <- ifelse(forecast_admits$yhat_lower > bedcap$Beds_Total, bedcap$Beds_Total, forecast_admits$yhat_lower)
  
  
  return_list <- as.list(forecast, forecast_admits)
  return(return_list)
}



Admit_LOS_prophet_CAH <- list()
for (HospitalName in unique(ts_df_CAH$hospital_name)) {
  Admit_LOS_prophet_CAH[[HospitalName]] <- create_prophet(ts_df_CAH, HospitalName = HospitalName)
}
Admit_LOS_prophet_NED <- list()
for (HospitalName in unique(ts_df_NED$hospital_name)) {
  Admit_LOS_prophet_NED[[HospitalName]] <- create_prophet(ts_df_NED, HospitalName = HospitalName)
}
Admit_LOS_prophet_ED <- list()
for (HospitalName in unique(ts_df_ED$hospital_name)) {
  Admit_LOS_prophet_ED[[HospitalName]] <- create_prophet(ts_df_ED, HospitalName = HospitalName)
}




dis_prophet_CAH <- list()
for (HospitalName in unique(ts_df_CAH_dis$hospital_name)) {
  dis_prophet_CAH[[HospitalName]] <- create_prophet_dis(ts_df_CAH_dis, HospitalName = HospitalName)
}

dis_prophet_NED <- list()
for (HospitalName in unique(ts_df_NED_dis$hospital_name)) {
  dis_prophet_NED[[HospitalName]] <- create_prophet_dis(ts_df_NED_dis, HospitalName = HospitalName)
}

dis_prophet_ED <- list()
for (HospitalName in unique(ts_df_ED_dis$hospital_name)) {
  dis_prophet_ED[[HospitalName]] <- create_prophet_dis(ts_df_ED_dis, HospitalName = HospitalName)
}

  


cap_dur_prophet_CAH <- list()
for (HospitalName in unique(names(ts_CAH_Hosp_Cap))){
  cap_dur_prophet_CAH[[HospitalName]] <- create_prophet_cap(ts_CAH_Hosp_Cap[names(ts_CAH_Hosp_Cap) == HospitalName], HospitalName = HospitalName)
}
cap_dur_prophet_NED <- list()
for (HospitalName in unique(names(ts_NED_Hosp_Cap))){
  cap_dur_prophet_NED[[HospitalName]] <- create_prophet_cap(ts_NED_Hosp_Cap, HospitalName = HospitalName)
}
cap_dur_prophet_ED <- list()
for (HospitalName in unique(names(ts_ED_Hosp_Cap))) {
  cap_dur_prophet_ED[[HospitalName]] <- create_prophet_cap(ts_ED_Hosp_Cap, HospitalName = HospitalName)
}









create_prophet_beds <- function(df, HospitalName, bedcap = HospNameandBeds){
  
  
  #Create STLF Model and params
  # fitets <- stlf(ts, s.window = "periodic")
  horizon = 1000
  #  intervalSTLF <- forecast(fitets, h = horizon, level = c(80, 95))
  #  STLF_DF <- data.frame(MeanSTLF = intervalSTLF$mean, UpperSTLF = intervalSTLF$upper[1:10], LowerSTLF = intervalSTLF$lower[1:10])
  
  bedcap <- bedcap[bedcap$hospital_name == HospitalName,]
  
  df <- as.data.frame(df[names(df) == HospitalName])
  colnames(df) <- c("date", "max_patient_count", "duration")
  
  df <- df[complete.cases(df$date),]
  
  prophet_df <- data.frame(ds = df$date, y = df$max_patient_count)
  

  m <- prophet(yearly.seasonality = TRUE)
  

  m <- fit.prophet(m, prophet_df)
  
 
  future <- make_future_dataframe(m, periods = horizon)
  
  
  forecast <- predict(m, future)
  ## If trend is negative, mark as zero, same with yhat lower
  forecast <- select(forecast, ds, yhat, yhat_lower, yhat_upper)
  forecast$yhat <- ifelse(forecast$yhat < 0, 0, forecast$yhat)
  forecast$yhat_upper <- ifelse(forecast$yhat_upper < 0, 0, forecast$yhat_upper)
  forecast$yhat_lower <- ifelse(forecast$yhat_lower < 0, 0, forecast$yhat_lower)
  forecast$yhat <- ifelse(forecast$yhat > bedcap$Beds_Total, bedcap$Beds_Total, forecast$yhat)
  forecast$yhat_upper <- ifelse(forecast$yhat_upper > bedcap$Beds_Total, bedcap$Beds_Total, forecast$yhat_upper)
  forecast$yhat_lower <- ifelse(forecast$yhat_lower > bedcap$Beds_Total, bedcap$Beds_Total, forecast$yhat_lower)
  
  
  
  
  
  return_list <- as.list(forecast)
  return(return_list)
}






cap_prophet <- list()
for (HospitalName in unique(names(ts_CAH_Hosp_Cap))){
  cap_prophet[[HospitalName]] <- create_prophet_beds(ts_CAH_Hosp_Cap[names(ts_CAH_Hosp_Cap) == HospitalName], HospitalName = HospitalName)
}

for (HospitalName in unique(names(ts_NED_Hosp_Cap))){
  cap_prophet[[HospitalName]] <- create_prophet_beds(ts_NED_Hosp_Cap, HospitalName = HospitalName)
}

for (HospitalName in unique(names(ts_ED_Hosp_Cap))) {
  cap_prophet[[HospitalName]] <- create_prophet_beds(ts_ED_Hosp_Cap, HospitalName = HospitalName)
}




### Now for discharges


### Files to save

## ICD 10 Diagnoses, Comorbidities, Length of Stay ICD rankings
save(
Complete_diag_tables_CAH,
Complete_comorb_tables_CAH,
Complete_LOS_tables_CAH,
Complete_diag_tables_ED,
Complete_comorb_tables_ED,
Complete_LOS_tables_ED,
Complete_diag_tables_NED,
Complete_comorb_tables_NED,
Complete_LOS_tables_NED,

## Admits, Length of Stay, Discharge trends per day
Admit_LOS_prophet_CAH,
Admit_LOS_prophet_NED,
Admit_LOS_prophet_ED,
dis_prophet_CAH,
dis_prophet_NED,
dis_prophet_ED,
cap_dur_prophet_CAH,
cap_dur_prophet_NED,
cap_dur_prophet_ED
, file = "All_ML.RData")

save(cap_prophet, HospNameandBeds, file = "CapacityCounts.RData")

### What do I have? 

## Just need geographic linkages