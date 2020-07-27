
# Install necessary packages
install.packages(c("zoo", "xts", "tidyverse"), dependencies = TRUE)
library(tidyverse); library(zoo); library(xts)

# Sets the working directory to where my files are. 
setwd("/Users/conorrickard/Documents/R_prog_files/_Projects/WendyTrouble"); getwd()

# Makes a list of the files inside the working directory. 
file.names <- list.files(pattern = "*.csv"); file.names

# uses the lapply function from tidyverse package to apply the function
# read.csv to all files in the list 'file.names'.
ldf <- lapply(file.names, read.csv, skip = 12); ldf # Data in files extracted into a list by collector
hdf <- lapply(file.names, read.csv, nrows = 11); hdf # metadata headers of files extracted

# Rename the list 
names(ldf)[1:10] <- c("CSLB_0","CSLB_1","CSLB_2","CSLB_3","CSLB_4","CSLB_5","CSLB_6","CSLB_7","CSLB_8","CSLB_9")

# Example workflow for processing fog data to hourly observations

# Convert DateTime to POSIXct time from character using striptime function
ldf$CSLB_0$DateTime  <- as.POSIXct(ldf$CSLB_0$DateTime, format = "%m/%d/%y %H:%M:%S") ; str(ldf$CSLB_0$DateTime)

# ldf$CSLB_0$DateTime = strptime(ldf$CSLB_0$DateTime, format = "%m/%d/%y %H:%M:%S"); str(ldf$CSLB_0$DateTime)

# make dataframe of just CSLB_0 first two columns
df.CSLB_0 <- data.frame(ldf$CSLB_0[1:2]); str(df.CSLB_0)

# Aggregate data hourly as sum of events. 
CSLB_0.hrly <- aggregate(df.CSLB_0$Liters, list(hour=cut(df.CSLB_0$DateTime, "1 hour")), sum)
CSLB_0.monthly <- aggregate(df.CSLB_0$Liters, list(month=cut(df.CSLB_0$DateTime, "1 month")), sum)
str(CSLB_0.monthly); head(CSLB_0.monthly)

# Rename the columns back to DateTime and Liters. Aggregate renames them in process. 
colnames(CSLB_0.hrly) <- c("DateTime", "Liters")
colnames(CSLB_0.monthly) <- c("DateTime", "Liters")

# Convert DateTime back to POSIXct again. Aggregate function treats as a factor in the output produced
CSLB_0.hrly$DateTime = as.POSIXct(as.factor(CSLB_0.hrly$DateTime))
CSLB_0.monthly$DateTime = as.POSIXct(as.factor(CSLB_0.monthly$DateTime))


# Create a new dataframe containing the span of dates for the dataset in hourly interval.   
date_span.CSLB_0.monhtly <- data.frame(DateTime = seq(as.POSIXct(min(CSLB_0.hourly$DateTime)), 
                                                      as.POSIXct(max(CSLB_0.hourly$DateTime)), 
                                                      by = "1 month")) 

date_span.CSLB_0.monthly <- data.frame(DateTime = seq(as.POSIXct(min(CSLB_0.monthly$DateTime)), 
                                        as.POSIXct(max(CSLB_0.monthly$DateTime)), 
                                        by = "1 month")) 

# Merge the span of dates at hourly interval with the event data. 
merged.CSLB_0.hrly = merge(date_span.CSLB_0.hrly, CSLB_0.hrly, by = "DateTime", all.x = TRUE)
str(merged.CSLB_0.hrly)
merged.CSLB_0.monthly = merge(date_span.CSLB_0.monthly, CSLB_0.monthly, by = "DateTime", all.x = TRUE)
str(merged.CSLB_0.monthly)
#Replace NA's in Liters with 0 values to represent no events recorded that hour.  
merged.CSLB_0.hrly$Liters[is.na(merged.CSLB_0.hrly$Liters)] <- 0
str(merged.CSLB_0.hrly)
merged.CSLB_0.monthly$Liters[is.na(merged.CSLB_0.monthly$Liters)] <- 0
str(merged.CSLB_0.monthly)
#Optional: Export revised aggregated data with zero event observations to a new CSV. 
write.csv(merged.CSLB_0.monthly, "/Users/conorrickard/Documents/R_prog_files/_Projects/WendyTrouble/Export/wendy",row.names = FALSE)

#### Example Plotting aggregated hourly data. 

# Hist
hist.POSIXt(merged.CSLB_0.monthly$Liters,"months")
#(merged.CSLB_0.monthly$Liters, "month")
# hist(CSLB_0.mon)

# Convert to a zoo object. Two ways to order by date. 
merged.CSLB_0.hrly.zoo<- zoo(merged.CSLB_0.hrly$Liters, order.by=merged.CSLB_0.hrly[,1])

# Plot zoo object. Limited format but will allow for time series analysis and plotting using xts format
plot.zoo(merged.CSLB_0.hrly.zoo[,2], xlab = "Time", ylab = "Fog", col = "mediumblue", lwd = 2) 

merged.CSLB_0.hrly.xts <- as.xts(merged.CSLB_0.hrly.zoo)

par(mfrow = c(1,1)) 

plot(merged.CSLB_0.hrly.xts[,1], 
     main = 'Fog Bucket #0', 
     xlab = 'Date',
     ylab = 'Fog Water',  
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=1, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty')

# Plotting a subset of observations

merged.CSLB_0.hrly.subset.xts <- merged.CSLB_0.hrly.xts["2020-04-04 00:00 /2020-04-07 00:00"] # Subsetting a range of dates

par(mfrow = c(1,1)) 

plot(merged.CSLB_0.hrly.subset.xts[,1], 
     main = 'Fog Bucket #0', 
     xlab = 'Date',
     ylab = 'Fog Water (Liters)', 
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=1, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty')

#### 0 Monthly 
# Convert DateTime to POSIXct time from character using striptime function
ldf$CSLB_0$DateTime = strptime(ldf$CSLB_0$DateTime, format = "%m/%d/%y %H:%M:%S")

# make dataframe of just FONR_1 first two columns
df.CSLB_0 <- data.frame(ldf$CSLB_0[1:2]); str(df.CSLB_0)

# Aggregate data hourly as sum of events. 
CSLB_0.monthly <- aggregate(df.CSLB_0$Liters, list(month=cut(df.CSLB_0$DateTime, "month")), sum)
bymonth <- aggregate(cbind(Melbourne,Southern,Flagstaff)~month(Date),
                     data=data,FUN=sum)

# Rename the columns back to DateTime and Liters. Aggregate renames them in process. 
colnames(CSLB_0.hrly) <- c("DateTime", "Liters")

# Convert DateTime back to POSIXct again. Aggregate function treats as a factor in the output produced
CSLB_0.hrly$DateTime = as.POSIXct(as.factor(CSLB_0.hrly$DateTime))

# Create a new dataframe containing the span of dates for the dataset in hourly interval.   
date_span.CSLB_0.hrly <- data.frame(DateTime = seq(as.POSIXct(min(CSLB_0.hrly$DateTime)), 
                                                   as.POSIXct(max(CSLB_0.hrly$DateTime)), 
                                                   by = "1 hour")) 

# Merge the span of dates at hourly interval with the event data. 
merged.CSLB_0.hrly = merge(date_span.CSLB_0.hrly, CSLB_0.hrly, by = "DateTime", all.x = TRUE)
str(merged.CSLB_0.hrly)
#Replace NA's in Liters with 0 values to represent no events recorded that hour.  
merged.CSLB_0.hrly$Liters[is.na(merged.CSLB_0.hrly$Liters)] <- 0
str(merged.CSLB_0.hrly)
#Optional: Export revised aggregated data with zero event observations to a new CSV. 
write.csv(merged.CSLB_0.hrly, file.choose(),row.names = FALSE)











