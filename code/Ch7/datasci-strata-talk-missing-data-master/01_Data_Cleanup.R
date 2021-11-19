library(xlsx)
# setwd("~/GitHub/datasci-strata-talk-missing-data")

##### load data ###############################################
raw_df <- read.xlsx("Yan 2 Glucose Data.xlsx", 
                    sheetName = "Sheet1",
                    startRow = 2)
head(raw_df)

proc_df <- raw_df
proc_df <- proc_df[with(proc_df, order(proc_df$Time)), ] 
proc_df["Inferred_Glucose"] = rowMeans(proc_df[c('Historic.Glucose..mmol.L.', 'Scan.Glucose..mmol.L.')], na.rm = TRUE)

plot(proc_df$Time, proc_df$Inferred_Glucose, type = "l")

sub_proc_df <- subset(proc_df, Time >= as.POSIXct('2019-08-04 00:00:00', tz = 'UTC') & Time < as.POSIXct('2019-08-05 00:00:00', tz = 'UTC'))
plot(sub_proc_df$Time, sub_proc_df$Inferred_Glucose, type = "l")

df <- sub_proc_df[c("Time", "Inferred_Glucose")]
head(df)  

# add minute_of_day
t.str <- strptime(df$Time, "%Y-%m-%d %H:%M:%S")
m.str <- as.numeric(format(t.str, "%H"))*60 + as.numeric(format(t.str, "%M"))
df$Minute_of_Day <- m.str

# sort by minute_of_day
df <- df[with(df, order(df$Minute_of_Day)), ]
plot(df$Minute_of_Day, df$Inferred_Glucose, type = "l")
plot(df$Minute_of_Day, df$Inferred_Glucose)

glucose_ser <- aggregate(df['Inferred_Glucose'], 
                         list(df$Minute_of_Day), 
                         mean)

colnames(glucose_ser) <- c('Minute_of_Day', 'Inferred_Glucose')
glucose_ser
plot(glucose_ser)
plot(glucose_ser, type = 'l')

# save glucose series
write.xlsx(glucose_ser, "glucose_ser.xlsx")

##### Handling the Gap ###############################################
df <- glucose_ser
rownames(df) <- glucose_ser$Minute_of_Day

gap_sizes <- diff(as.matrix(df$Minute_of_Day))

GAP_LEFT_INDEX = 58
GAP_RIGHT_INDEX = 59
GAP_LEFT_MINUTES <- df$Minute_of_Day[GAP_LEFT_INDEX]
GAP_RIGHT_MINUTES <- df$Minute_of_Day[GAP_RIGHT_INDEX]

print(c(GAP_LEFT_INDEX, GAP_RIGHT_INDEX, GAP_LEFT_MINUTES, GAP_RIGHT_MINUTES))

missing_indices = floor((GAP_RIGHT_MINUTES - GAP_LEFT_MINUTES)/15)
missing_minutes <- sapply(c(0:missing_indices), function(x) GAP_LEFT_MINUTES + x*15)
missing_minutes

# add new minute of day
new_index_labels <- setdiff(missing_minutes, df$Minute_of_Day) 
new_df <- as.data.frame(matrix(nrow = length(new_index_labels), ncol = 2, dimnames = list(new_index_labels, colnames(df))))
new_df$Minute_of_Day <- rownames(new_df)

df <- rbind(df, new_df)
df$Minute_of_Day <- as.numeric(df$Minute_of_Day)

# sort by minute of day
df <- df[with(df, order(df$Minute_of_Day)), ]

# save glucose series
write.xlsx(df, "glucose.xlsx")






