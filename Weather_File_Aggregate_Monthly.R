sessionInfo() # (1) Check out "other attached packages" to see what's currently installed
# Install necessary packages 
install.packages(c("zoo", "xts", "tidyverse","xlsx"), dependencies = TRUE) # (2)
library(tidyverse); library(zoo); library(xts); library(lubridate);library(xlsx) # (3) ALWAYS call up installed packages to current workspace with library()


# This was all done in RStudio
R <- R.Version(); R$version.string; R$platform; S <- sessionInfo(); S$running # Check R version, platform, and computer # Paste these 3 (& hashtag out) to be polite
#[1] "R version 4.0.1 (2020-06-06)"
#[1] "x86_64-apple-darwin17.0"
#[1] "macOS Catalina 10.15.6"


# Past the path with file name of your weather file
FONRmet <- read.csv("/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/IMPORT/FONR_Weather_07182019_06192020.csv")
# Rename the headers
names(FONRmet)[1:2] <- c("DateTime", "millimeters")
## Two steps #POSXIlt to POSIXct
FONRmet$DateTime = strptime(FONRmet$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet$DateTime)
# Convert time to POSIXct
FONRmet$DateTime  <- as.POSIXct(FONRmet$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet$DateTime)
# How many NA are in the raw data
table(is.na(FONRmet$DateTime)) 
# Pull out a dataframe
df.FONRmet <- data.frame(FONRmet[1:2]); str(df.FONRmet); class(df.FONRmet$DateTime)
# Aggregate fog data as monthly and as sum of observed events
FONRmet.monthly <- aggregate(df.FONRmet$millimeters, list(DateTime=cut(df.FONRmet$DateTime, "1 month")), sum) ; str(FONRmet.monthly); head(FONRmet.monthly)
class(df.FONRmet$DateTime)
# FONRmet.monthly$DateTime <- strptime(FONRmet.monthly$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet.monthly); class(FONRmet.monthly$DateTime)
# FONRmet.monthly$DateTime <- as.POSIXct(FONRmet.monthly$DateTime, format = "%Y-%m-%d %H:%M:%S"); str(FONRmet.monthly); head(FONRmet.monthly) #aggregate() and cut() coerce coerce time to a factor
names(FONRmet.monthly) <- c("DateTime", "millimeters"); str(FONRmet.monthly); head(FONRmet.monthly) # Aggregating also fouled up the names
# FONRmet.monthly$DateTime <- align.time(FONRmet.monthly$DateTime, n=60*30); str(FONRmet.monthly$DateTime); head(FONRmet.monthly)  #align.time is a function in library(xts)

write.csv(FONRmet.monthly,"/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/FONRmetExport/FONRMetMonthly", row.names = FALSE)



### ???????????????????
# Can't run below without codes yet...  Plus the above output isn't a csv, it's a text file


# Create a new dataframe containing the span of dates for the dataset in monthly interval. 
date_span.FONRmet.monthly <- data.frame(seq(min(as.POSIXct(FONRmet.monthly$DateTime)), 
                                                      max(as.POSIXct(FONRmet.monthly$DateTime)), 
                                                      by = "1 month")) 
class(df.FONRmet$DateTime)
# Merge the span of dates at hourly interval with the event data. 
merged.FONRmet.monthly = merge(date_span.FONRmet.monthly, FONRmet.monthly, by = "DateTime", all.x = TRUE) ; str(merged.FONRmet.hlfhrly)

#Replace NA's in millimeters with 0 values to represent no events recorded that hour.  
merged.FONRmet.hlfhrly$millimeters[is.na(merged.FONRmet.hlfhrly$millimeters)] <- 0; str(merged.FONRmet.hlfhrly); head(merged.FONRmet.hlfhrly)



#### Alternative Aggregation ####
FONRmet <- read.csv("/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/IMPORT/FONR_Weather_07182019_06192020.csv")
names(FONRmet)[1:2] <- c("DateTime", "millimeters")
FONRmet$DateTime = strptime(FONRmet$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet$DateTime)
# FONRmet$DateTime  <- as.POSIXct(FONRmet$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet$DateTime)
# FONRmet$DateTime <- as.Date(FONRmet$DateTime)
FONRmet$Month <- month(as.POSIXct(FONRmet$DateTime), label = TRUE)
FONRmet$Year <- format(FONRmet$DateTime,format="%Y")
FONRmet.monthly <- aggregate( millimeters ~ Year + Month , FONRmet , sum )
FONRmet.monthly <- data.frame(FONRmet.monthly)
write.csv(FONRmet.monthly, file= "/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/FONRmetExport/FONRmet.monthly.csv",row.names = FALSE)


### Scratch
# Note that strptime converts to POSIXlt format and requires a step to convert from local time (lt) to calendar time (ct)