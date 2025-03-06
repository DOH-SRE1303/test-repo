## Heatmaps 

load("CHARS_Data.RData")


### create weeks by year? 

df <- df %>% 
  mutate(
    admission_hour = as.factor(admission_hour),
    discharge_hour = as.factor(discharge_hour), 
    admit_weekday = as.factor(weekdays(as.Date(admission_date))),
    discharge_weekday = as.factor(weekdays(as.Date(discharge_date)))
    )

admit_heatmap <- df %>%
  select(hospital_name, admission_hour, admit_weekday) %>%
  group_by(hospital_name, admission_hour, admit_weekday) %>%
  count() %>%
  group_by(hospital_name) %>%
  mutate(percentage = n/sum(n) *100)
  
discharge_heatmap <- df %>%
  select(hospital_name, discharge_hour, discharge_weekday) %>%
  group_by(hospital_name, discharge_hour, discharge_weekday) %>%
  count() %>%
  group_by(hospital_name) %>%
  mutate(percentage = n/sum(n) *100)



save(admit_heatmap, discharge_heatmap, file = "heatmaps.RData")