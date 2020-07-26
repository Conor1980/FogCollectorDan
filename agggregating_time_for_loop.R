#### Script to aggregate events based on time interval ####

sessionInfo() # (1) Check out "other attached packages" to see what's currently installed
# Install necessary packages and call up to current workspace with library
install.packages(c("zoo", "xts", "tidyverse"), dependencies = TRUE) # (2)
library(tidyverse); library(zoo); library(xts); library(lubridate) # (3) ALWAYS call up installed packages to current workspace with library()

R <- R.Version(); R$version.string; R$platform; S <- sessionInfo(); S$running # Check R version, platform, and computer # Paste these 3 (& hashtag out) to be polite
#[1] "R version 4.0.1 (2020-06-06)"
#[1] "x86_64-apple-darwin17.0"
#[1] "macOS Catalina 10.15.6"

# Set the working directory   
setwd("C:/Users/jdetk/Desktop/fog_rainfall/Fog_data"); getwd()

# For Loop to read and create a new copy of each file with correct POSIXct formated time:

# Set some parameters 
extension <- "csv"  # Type of files
fileNames <- Sys.glob(paste("*.", extension, sep = "")) # List of file names in the working directory
fileNumbers <- seq(fileNames); fileNumbers # A counter to identify each files position in the for loop sequence

for (fileNumber in fileNumbers) {
  
  # The structure of the new files
  newFileName     <-  paste("hlfhrly-", sub(paste("\\.", extension, sep = ""), "", fileNames[fileNumber]),  ".", extension, sep = "")
  
  # read original data files
  sample          <- read.csv(fileNames[fileNumber], header = TRUE, sep = ",", skip = 12)
  
  # Convert DateTime to POSIXlt time from character using striptime function
  sample$DateTime <- strptime(sample$DateTime, format = "%m/%d/%y %H:%M:%S") 
  # Note that strptime converts to POSIXlt format and requires a step to convert from local time (lt) to calendar time (ct)
  sample$DateTime <- as.POSIXct(sample$DateTime, format = "%m/%d/%y %H:%M:%S") 
  
  # Aggregate fog data as half hourly sum of observed events
  output          <- aggregate(sample$Liters, list(DateTime=cut(sample$DateTime, "30 min")), sum) 
  output$DateTime <- as.POSIXct(as.factor(output$DateTime), format = "%Y-%m-%d %H:%M:%S")
  output$DateTime <- align.time(output$DateTime, n=60*30)
  names(output)   <- c("DateTime", "Liters")
  
  # Create a new dataframe containing the span of dates for the dataset in hourly interval.   
  date_span       <- data.frame(DateTime = seq(as.POSIXct(floor_date(min(output$DateTime),unit = "30 min")), 
                                               as.POSIXct(ceiling_date(max(output$DateTime),unit= "30 min")), 
                                               by = "30 min")) 
  
  # Merge the span of dates at hourly interval with the event data. 
  merged.output <- merge(date_span, output, by = "DateTime", all.x = TRUE) 
  
  #Replace NA's in Liters with 0 values to represent no events recorded that hour.  
  merged.output$Liters[is.na(merged.output$Liters)] <- 0
  
  # write old data revised to new files:
  write.table(merged.output, newFileName, append = FALSE, quote = FALSE, sep = ",", row.names = FALSE, col.names = TRUE)
  
}
