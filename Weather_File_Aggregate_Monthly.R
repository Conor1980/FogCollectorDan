sessionInfo() # (1) Check out "other attached packages" to see what's currently installed
# Install necessary packages 
install.packages(c("zoo", "xts", "tidyverse"), dependencies = TRUE) # (2)
library(tidyverse); library(zoo); library(xts); library(lubridate) # (3) ALWAYS call up installed packages to current workspace with library()

# This was all done in RStudio
R <- R.Version(); R$version.string; R$platform; S <- sessionInfo(); S$running # Check R version, platform, and computer # Paste these 3 (& hashtag out) to be polite
#[1] "R version 4.0.1 (2020-06-06)"
#[1] "x86_64-apple-darwin17.0"
#[1] "macOS Catalina 10.15.6"


# Put your files in your folder first


#### Do one push up with one file ####
## Two steps #POSXIlt to POSIXct
# Note that strptime converts to POSIXlt format and requires a step to convert from local time (lt) to calendar time (ct)
ldf_20$FONR_1$DateTime = strptime(ldf_20$FONR_1$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(ldf_20$FONR_1$DateTime)
# Convert time to POSIXct
ldf_20$FONR_1$DateTime  <- as.POSIXct(ldf_20$FONR_1$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(ldf_20$FONR_1$DateTime)

table(is.na(ldf_20$FONR_1$DateTime)) #Make sure their are no NA in raw data

# Pull out a dataframe of just FONR_1 first two columns
df.FONR_1 <- data.frame(ldf_20$FONR_1[1:2]); str(df.FONR_1); class(df.FONR_1$DateTime)

# Aggregate fog data as monthly as sum of observed events
FONR_1.monthly <- aggregate(df.FONR_1$Liters, list(DateTime=cut(df.FONR_1$DateTime, "1 month")), sum) ; str(FONR_1.monthly); head(FONR_1.monthly)
FONR_1.monthly$DateTime <- strptime(FONR_1.monthly$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONR_1.monthly); class(FONR_1.monthly$DateTime)
FONR_1.monthly$DateTime <- as.POSIXct(FONR_1.monthly$DateTime, format = "%Y-%m-%d %H:%M:%S"); str(FONR_1.monthly); head(FONR_1.monthly) #aggregate() and cut() coerce to time a factor
names(FONR_1.monthly) <- c("DateTime", "Liters"); str(FONR_1.monthly); head(FONR_1.monthly) # Aggregating also fouled up the names
# FONR_1.monthly$DateTime <- align.time(FONR_1.monthly$DateTime, n=60*30); str(FONR_1.monthly$DateTime); head(FONR_1.monthly)  #align.time is a function in library(xts)

# Create a new dataframe containing the span of dates for the dataset in monthly interval. 
date_span.FONR_1.monthly <- data.frame(DateTime = seq(as.POSIXct(floor_date(min(FONR_1.monthly$DateTime),unit = "1 month")), 
                                                      as.POSIXct(ceiling_date(max(FONR_1.monthly$DateTime),unit= "1 month")), 
                                                      by = "1 month")) ; str(date_span.FONR_1.monthly)

# Merge the span of dates at hourly interval with the event data. 
merged.FONR_1.monthly = merge(date_span.FONR_1.hlfhrly, FONR_1.hlfhrly, by = "DateTime", all.x = TRUE) ; str(merged.FONR_1.hlfhrly)

#Replace NA's in Liters with 0 values to represent no events recorded that hour.  
merged.FONR_1.hlfhrly$Liters[is.na(merged.FONR_1.hlfhrly$Liters)] <- 0; str(merged.FONR_1.hlfhrly); head(merged.FONR_1.hlfhrly)

