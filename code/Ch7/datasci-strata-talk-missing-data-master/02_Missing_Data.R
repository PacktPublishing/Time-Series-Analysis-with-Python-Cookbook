#02_Missing_Data.R

library(xlsx)
library(imputeTS)
library(VIM)
# setwd("~/GitHub/datasci-strata-talk-missing-data")

##### load data ###############################################
df <- read.xlsx("glucose.xlsx", 
                sheetName = "Sheet1")
df[1] <- NULL
rownames(df) <- df$Minute_of_Day

head(df)
plot(df$Minute_of_Day, df$Inferred_Glucose, type = 'b')

# find missing minutes
missing_minutes <- df[which(is.na(df$Inferred_Glucose)), 'Minute_of_Day']

##### Last-Observed Carry Forward (LOCF)  ###############################################
df['Glucose_LOCF'] <- na_locf(df$Inferred_Glucose)
plot(df$Minute_of_Day, df$Glucose_LOCF, type = 'b')

##### Mean Value  ###############################################
df['Glucose_Mean'] <- na_mean(df$Inferred_Glucose)
plot(df$Minute_of_Day, df$Glucose_Mean, type = 'b')

##### Nearest Neighbor  ###############################################
library(pracma)
df['Glucose_nearest_neighbor'] <- interp1(df$Minute_of_Day, df$Inferred_Glucose, method = 'nearest')
plot(df$Minute_of_Day, df$Glucose_nearest_neighbor, type = 'b')

##### Linear Interpolation ###############################################
df['Glucose_LI'] <- na_interpolation(df$Inferred_Glucose,
                                      option = 'linear')
plot(df$Minute_of_Day, df$Glucose_LI, type = 'b')

##### Polinomial Interpolation ###############################################
library(spatialEco)
df['Glucose_PI'] <- na_interpolation(df$Inferred_Glucose,
                                      option = 'stine')
plot(df$Minute_of_Day, df$Glucose_PI, type = 'b')

##### Spline Interpolation ###############################################
df['Glucose_Spline'] <- na_interpolation(df$Inferred_Glucose,
                                      option = 'spline')
plot(df$Minute_of_Day, df$Glucose_Spline, type = 'b')

##### Kalman Filtering ###############################################
df['Glucose_Kalman_StructTS'] <- na_kalman(df$Inferred_Glucose,
                                      model = 'StructTS')

df['Glucose_Kalman_Arima'] <- na_kalman(df$Inferred_Glucose,
                                                 model = 'auto.arima')

plot(df$Minute_of_Day, df$Glucose_Kalman_StructTS, type = 'b')
plot(df$Minute_of_Day, df$Glucose_Kalman_Arima, type = 'b')

##### Moving Average ###############################################
df['Glucose_Moving_Average'] <- na_ma(df$Inferred_Glucose, k = 4)
plot(df$Minute_of_Day, df$Glucose_Moving_Average, type = 'b')
                                          
##### KNN imputation  ###############################################
df['Glucose_knn'] <- VIM::kNN(df, variable = "Inferred_Glucose", k = 5)$Inferred_Glucose
plot(df$Minute_of_Day, df$Glucose_knn, type = 'b')
