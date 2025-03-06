
library(dplyr)
load("Completed_Dataframes.RData")
load("CapacityCounts.RData")
load("All_ML.RData")
current_date <- Sys.Date()
date_plus_day <- current_date +1
date_plus_48 <- current_date +2
date_plus_72 <- current_date +3
last_week <- Sys.Date() - 7


### Filter to display the last week to 3 days ahead. 


## Re-examine Capacity and Duration 


## Shows how many discharges are likely to happen.
Discharge_Display <- Merged_dis %>%
  filter(ds >= as.POSIXct(last_week)) %>%
  filter(ds <= as.POSIXct(date_plus_72))

Admit_LOS_Hours_Display <- Merged_Admit_LOS %>%
  filter(ds >= as.POSIXct(last_week)) %>%
  filter(ds <= as.POSIXct(date_plus_72))






write.csv(Discharge_Display, file = "DischargeTable.csv")
write.csv(Admit_LOS_Hours_Display, file = "AdmitTable.csv")
write.csv(admit_heatmap, file = "AdmitHeatMap.csv")
write.csv(discharge_heatmap, file = "DischargeHeatMap.csv")








last_week_comorb <- list()
this_week_comorb <- list()
next_week_comorb <- list()
last_week_diag <- list()
this_week_diag <- list()
next_week_diag <- list()


for (facility in names(Complete_comorb_tables_ED)) {
  
  Complete_comorb_tables_ED[[facility]][[1]]$Hospital_Name <- facility
  Complete_comorb_tables_ED[[facility]][[2]]$Hospital_Name <- facility
  Complete_comorb_tables_ED[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_comorb[facility] <- Complete_comorb_tables_ED[[facility]][1]
  this_week_comorb[facility] <- Complete_comorb_tables_ED[[facility]][2]
  next_week_comorb[facility] <- Complete_comorb_tables_ED[[facility]][3]
  
  Complete_diag_tables_ED[[facility]][[1]]$Hospital_Name <- facility
  Complete_diag_tables_ED[[facility]][[2]]$Hospital_Name <- facility
  Complete_diag_tables_ED[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_diag[facility] <- Complete_diag_tables_ED[[facility]][1]
  this_week_diag[facility] <- Complete_diag_tables_ED[[facility]][2]
  next_week_diag[facility] <- Complete_diag_tables_ED[[facility]][3]
}

for (facility in names(Complete_comorb_tables_NED)) {
  
  Complete_comorb_tables_NED[[facility]][[1]]$Hospital_Name <- facility
  Complete_comorb_tables_NED[[facility]][[2]]$Hospital_Name <- facility
  Complete_comorb_tables_NED[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_comorb[facility] <- Complete_comorb_tables_NED[[facility]][1]
  this_week_comorb[facility] <- Complete_comorb_tables_NED[[facility]][2]
  next_week_comorb[facility] <- Complete_comorb_tables_NED[[facility]][3]
  
  Complete_diag_tables_NED[[facility]][[1]]$Hospital_Name <- facility
  Complete_diag_tables_NED[[facility]][[2]]$Hospital_Name <- facility
  Complete_diag_tables_NED[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_diag[facility] <- Complete_diag_tables_NED[[facility]][1]
  this_week_diag[facility] <- Complete_diag_tables_NED[[facility]][2]
  next_week_diag[facility] <- Complete_diag_tables_NED[[facility]][3]
}

for (facility in names(Complete_comorb_tables_CAH)) {
  
  Complete_comorb_tables_CAH[[facility]][[1]]$Hospital_Name <- facility
  Complete_comorb_tables_CAH[[facility]][[2]]$Hospital_Name <- facility
  Complete_comorb_tables_CAH[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_comorb[facility] <- Complete_comorb_tables_CAH[[facility]][1]
  this_week_comorb[facility] <- Complete_comorb_tables_CAH[[facility]][2]
  next_week_comorb[facility] <- Complete_comorb_tables_CAH[[facility]][3]
  
  Complete_diag_tables_CAH[[facility]][[1]]$Hospital_Name <- facility
  Complete_diag_tables_CAH[[facility]][[2]]$Hospital_Name <- facility
  Complete_diag_tables_CAH[[facility]][[3]]$Hospital_Name <- facility
  
  last_week_diag[facility] <- Complete_diag_tables_CAH[[facility]][1]
  this_week_diag[facility] <- Complete_diag_tables_ED[[facility]][2]
  next_week_diag[facility] <- Complete_diag_tables_CAH[[facility]][3]
}





Merged_lastweek_comorb <- do.call(bind_rows, last_week_comorb)
Merged_lastweek_diag <- do.call(bind_rows, last_week_diag)


Merged_thisweek_comorb <- do.call(bind_rows, this_week_comorb)
Merged_thisweek_diag <- do.call(bind_rows, this_week_diag)

Merged_nextweek_comorb <- do.call(bind_rows, next_week_comorb)
Merged_nextweek_diag <-   do.call(bind_rows, next_week_diag)


write.csv(Merged_lastweek_comorb, file = "lastweek_CM.csv")
write.csv(Merged_thisweek_comorb, file = "thisweek_CM.csv")
write.csv(Merged_nextweek_comorb, file = "nextweek_CM.csv")

write.csv(Merged_lastweek_diag, file = "lastweek_Diag.csv")
write.csv(Merged_thisweek_diag, file = "thisweek_Diag.csv")
write.csv(Merged_nextweek_diag, file = "nextweek_Diag.csv")







write.csv(Admit_LOS_Hours_Display, file = "LOS_Overall.csv")
### Now I have to do: 


## Diagnosis LOS

last_week_LOS <- list()
this_week_LOS <- list()
next_week_LOS <- list()


for (facility in names(Complete_LOS_tables_ED)) {
  
  
  last_week_LOS[facility] <- Complete_LOS_tables_ED[[facility]][1]
  this_week_LOS[facility] <- Complete_LOS_tables_ED[[facility]][2]
  next_week_LOS[facility] <- Complete_LOS_tables_ED[[facility]][3]
  
}



for (facility in names(Complete_LOS_tables_NED)) {
  
  
  last_week_LOS[facility] <- Complete_LOS_tables_NED[[facility]][1]
  this_week_LOS[facility] <- Complete_LOS_tables_NED[[facility]][2]
  next_week_LOS[facility] <- Complete_LOS_tables_NED[[facility]][3]
  
}


for (facility in names(Complete_LOS_tables_CAH)) {
  
  
  last_week_LOS[facility] <- Complete_LOS_tables_CAH[[facility]][1]
  this_week_LOS[facility] <- Complete_LOS_tables_CAH[[facility]][2]
  next_week_LOS[facility] <- Complete_LOS_tables_CAH[[facility]][3]
  
}

Merged_lastweek_diagLOS <- do.call(bind_rows, last_week_LOS)
Merged_thisweek_diagLOS <- do.call(bind_rows, this_week_LOS)
Merged_nextweek_diagLOS <- do.call(bind_rows, next_week_LOS)


write.csv(Merged_lastweek_diagLOS, file = "DLOS_lastweek.csv")
write.csv(Merged_thisweek_diagLOS, file = "DLOS_thisweek.csv")
write.csv(Merged_nextweek_diagLOS, file = "DLOS_nextweek.csv")


## Capacity and amount of time 
CapacityDuration <- list()


for (facility in names(cap_dur_prophet_CAH)) {
cap_dur_prophet_CAH[[facility]]$Hospital_Name <- facility

CapacityDuration[[facility]] <- as.data.frame(cap_dur_prophet_CAH[[facility]]) %>%
  filter(ds >= as.POSIXct(last_week)) %>%
  filter(ds <= as.POSIXct(date_plus_72))

}

for (facility in names(cap_dur_prophet_ED)) {
  cap_dur_prophet_ED[[facility]]$Hospital_Name <- facility
  
  CapacityDuration[[facility]] <- as.data.frame(cap_dur_prophet_ED[[facility]]) %>%
    filter(ds >= as.POSIXct(last_week)) %>%
    filter(ds <= as.POSIXct(date_plus_72))
  
}

for (facility in names(cap_dur_prophet_NED)) {
  cap_dur_prophet_NED[[facility]]$Hospital_Name <- facility
  
  CapacityDuration[[facility]] <- as.data.frame(cap_dur_prophet_NED[[facility]]) %>%
    filter(ds >= as.POSIXct(last_week)) %>%
    filter(ds <= as.POSIXct(date_plus_72))
  
}

##Patient count
## Need TS_DF_CAH 


## Maybe change so that way yhat and yhat upper max is 24 hours. 
## cap dur shows duration of max level of beds for the day
## filter down to the week 
Merged_Duration <- do.call(bind_rows, CapacityDuration)

Merged_Duration$yhat <- ifelse(Merged_Duration$yhat > 24, 24, Merged_Duration$yhat)
Merged_Duration$yhat_upper <- ifelse(Merged_Duration$yhat_upper > 24, 24, Merged_Duration$yhat_upper)
Merged_Duration$yhat_lower <- ifelse(Merged_Duration$yhat_lower > 24, 24, Merged_Duration$yhat_lower)


write.csv(Merged_Duration, file = "Duration.csv")




for (facility in names(cap_prophet)) {
  cap_prophet[[facility]]$Hospital_Name <- facility
}



Merged_cap <- do.call(bind_rows, cap_prophet) %>%
  filter(ds >= as.POSIXct(last_week)) %>%
  filter(ds <= as.POSIXct(date_plus_72))

write.csv(Merged_cap, file = "Capacity.csv")






Merged_cap_avg <- do.call(bind_rows, cap_prophet) 

cap_avg <- Merged_cap_avg %>%
  group_by(Hospital_Name) %>%
  summarize(Average = mean(yhat))
  

Merged_cap_avg_all <- merge(Merged_cap_avg, cap_avg, by ="Hospital_Name")

Merged_cap_avg_all$AboveAverage <- ifelse(Merged_cap_avg_all$yhat > Merged_cap_avg_all$Average, 1, 0)

perday_hosp_above_average <- Merged_cap_avg_all %>%
  group_by(ds) %>%
  summarize(NumHosp_Above = sum(AboveAverage, na.rm = TRUE)) %>%
  ungroup() %>%
  summarize(AVGNumHosp_Above = mean(NumHosp_Above), SDNumHosp_Above = sd(NumHosp_Above))

## Check how many hospitals are above average today, tomorrow, next day. Add category for below average, average, 1+SD, 2+SD
today_comparison <- Merged_cap_avg_all %>%
  filter(as.Date(ds) == as.Date(current_date)) %>%
  summarize(NumHosp_Above = sum(AboveAverage, na.rm = TRUE))
today_comparison$Code <- ifelse(today_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above, "Below Average", 
                                ifelse(today_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above & today_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average$SDNumHosp_Above, "Within Average Range",
                                       ifelse(today_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average & today_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Above Average",
                                              ifelse(today_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Far Above Average", NA))))
today_comparison$day <- "Today"

tomorrow_comparison <- Merged_cap_avg_all %>%
  filter(as.Date(ds) == as.Date(date_plus_day)) %>%
  summarize(NumHosp_Above = sum(AboveAverage, na.rm = TRUE))

tomorrow_comparison$Code <- ifelse(tomorrow_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above, "Below Average", 
                                   ifelse(tomorrow_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above & tomorrow_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average$SDNumHosp_Above, "Within Average Range",
                                          ifelse(tomorrow_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average & tomorrow_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Above Average",
                                                 ifelse(tomorrow_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Far Above Average", NA))))
tomorrow_comparison$day <- "24 Hours Ahead"

nextday_comparison <-  Merged_cap_avg_all %>%
  filter(as.Date(ds) == as.Date(date_plus_48)) %>%
  summarize(NumHosp_Above = sum(AboveAverage, na.rm = TRUE))
nextday_comparison$Code <- ifelse(nextday_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above, "Below Average", 
                                  ifelse(nextday_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above & nextday_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average$SDNumHosp_Above, "Within Average Range",
                                         ifelse(nextday_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + perday_hosp_above_average & nextday_comparison$NumHosp_Above < perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Above Average",
                                                ifelse(nextday_comparison$NumHosp_Above >= perday_hosp_above_average$AVGNumHosp_Above + (perday_hosp_above_average$SDNumHosp_Above*2), "Far Above Average", NA))))

nextday_comparison$day <- "48 Hours Ahead"


DayComparisons <- rbind(today_comparison, tomorrow_comparison, nextday_comparison)

write.csv(DayComparisons, file = "DayComparisonSummary.csv")


MapLatLong <- read.csv("hospitals_lat_long.csv")




### Now just map for now. 

Beds_and_LatLong <- inner_join(HospNameandBeds, MapLatLong, by = "hospital_name")
Merged_cap_avg_all$hospital_name <- Merged_cap_avg_all$Hospital_Name 


MapReady <- inner_join(Beds_and_LatLong, Merged_cap_avg_all, by ="hospital_name") %>%
  filter(ds == as.POSIXct(current_date))

MapReady <- select(MapReady, hospital_name, lat, long, ds, yhat, Average, Beds_Total, AboveAverage)

write.csv(MapReady, file = "MapReady.csv")