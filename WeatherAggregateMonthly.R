sessionInfo() # (1) Check out "other attached packages" to see what's currently installed
# (2) Install the necessary packages you don't already have 
install.packages(c("zoo", "xts", "tidyverse"), dependencies = TRUE) 
library(tidyverse); library(zoo); library(xts) # (3) ALWAYS call up installed packages to current workspace with library()

### This was all done in RStudio
# Cut from the console, paste, and hashtag out three lines, to be polite to others
R <- R.Version(); R$version.string; R$platform; S <- sessionInfo(); S$running # Check R version, platform, and computer # Paste these 3 (& hashtag out) to be polite
#[1] "R version 4.0.1 (2020-06-06)"
#[1] "x86_64-apple-darwin17.0"
#[1] "macOS Catalina 10.15.6"

#### Alternative Aggregation ####

## I attained and formatted weather data with two columns and one row of header and saved to my computer as a .csv 
# Read in the file # Copy the entire file path and past below with quotes (and make sure slashes are forward)
FONRmet <- read.csv("/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/IMPORT/FONR_Weather_07182019_06192020.csv")

# Rename the (first two) column headers
names(FONRmet)[1:2] <- c("DateTime", "millimeters")

# Convert to POSIX format # Must call out the the format that your read in data come in # see https://statistics.berkeley.edu/computing/r-dates-times 
FONRmet$DateTime = strptime(FONRmet$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(FONRmet$DateTime)

# Create a month vector # For some reason POSIXct works, even though we made it POSIXlt in the line above
FONRmet$Month <- month(as.POSIXct(FONRmet$DateTime), label = TRUE)

# Creat a year format # Reference the berkely link again if you want 2 numbers instead of 4 
FONRmet$Year <- format(FONRmet$DateTime,format="%Y")

# Aggregate!
FONRmet.monthly <- aggregate( millimeters ~ Year + Month , FONRmet , sum )

## Write a .csv to your computer
# Copy and past the path you want to export to and add quotes (make slashes forwrad if you have to)
PathofYourExportFolder <-"/Users/conorrickard/Documents/R_prog_files/_Git_Projects/ForLoop_Aggregate_MonthlyTotalsFONR/FONRmetExport/"
NameYourFile <- "Monthly2"  # Name your file, with quotes
write.csv(FONRmet.monthly, file= paste(PathofYourExportFolder,NameYourFile,".csv"),row.names = FALSE)