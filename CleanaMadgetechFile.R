### Clean a Madgetech File ###

# (1) Check out "other attached packages" to see what's currently installed
sessionInfo()
# (2) Install the necessary packages you don't already have 
install.packages(c('googledrive',"googlesheets","readxl", "tidyverse"), dependencies = TRUE) ;install.packages()
# (3) ALWAYS call up installed packages to current workspace with library()
library(googledrive); library(googlesheets); library(readxl); library(tidyverse) 

# Cut from the console, paste, and hashtag out three lines, to be polite to others
R <- R.Version(); R$version.string; R$platform; S <- sessionInfo(); S$running 
#[1] "R version 4.0.1 (2020-06-06)"
#[1] "x86_64-apple-darwin17.0"
#[1] "macOS Catalina 10.15.6"
### This was all done in RStudio


#### Clean a Madgetech File ####
#(to be furthered by a ForLoop and accessing Google Drive)

# Put the files 

#### Read in your files #Set some stuff up ####
# Get a Madgetech excel file; clear the logger headers; make sure the excel is a dataframe
file<- read_excel("/Users/conorrickard/Documents/R_prog_files/_Git_Projects/MyFirstScriptsFONR/Import/FONR_STA_1_NN_20190710_20190914.xlsx",skip=6)
# Read in your calibration table too
cal.table <-as.data.frame(read_excel("/Users/conorrickard/Documents/R_prog_files/_Git_Projects/MyFirstScriptsFONR/Import/CalibrationTable.xlsx"))
# Designate the pattern of your station file name here in quotes: 
pattern = "FONR_STA_1"


# Make sure your excel file is a dataframe and get rid of an extra column 
file<- as.data.frame(file[,-2]); head(file)
# Rename the headers to our Lab standard (also easier to write within code)
names(file)[1:2]<- c("DateTime", "Liters"); head(file)


## Remember this? > cal.table <-as.data.frame(read_excel(
#### Set up the calibration table you read in ####
head(cal.table)
names(cal.table)[1] <- "CalDate"; head(cal.table)
Tcal.table<- setNames(data.frame(t(cal.table[,-1])), cal.table[,1]); head(Tcal.table) 
Tcal.table$CalDate<- rownames(Tcal.table)
row.names(Tcal.table)<- NULL; head(Tcal.table); class(Tcal.table$CalDate)
Tcal.table$CalDate<- as.POSIXct(as.Date(as.numeric(Tcal.table$CalDate), origin = "1899-12-30")); Tcal.table$CalDate; class(Tcal.table$CalDate)







#### Set up your header as a datatable ####
(noext<- unlist(strsplit(list.files(pattern=pattern),'[.]'))[1])
(R_name<- paste0(unlist(strsplit(noext, "_"))[c(1)],"_",unlist(strsplit(noext, "_"))[c(3)]))
(R_startdate<- unlist(strsplit(noext, "_"))[c(5)])
(R_enddate<- unlist(strsplit(noext, "_"))[c(6)])
(Calibration<- Tcal.table[])

## Still working on referencing the calibration table 
Tcal.table$CalDate
Calibration<- Tcal.table[Tcal.table %>% filter(Tcal.table$CalDate > as.POSIXct(as.Date(R_startdate, "%Y%m%d"), tz="UTC")),R_name]
(test<- as.Date(R_startdate, "%Y%m%d"))


# Still setting up
Astdrdhead<- rbind("R.name",
                  "R.startdate",
                  "R.enddate",
                  "Calibration",
                  "Latitude dec",
                  "Longitude dec",
                  "Elevation m",
                  "Azimuthal Orientation deg",
                  "Binned or Unbinned",
                  "Time Interval if Binned",
                  "Mesh Coating Type If Any",
                  "Ongoing Notes and Visit History")
Bstdrdhead<- rbind(paste0(unlist(strsplit(noext, "_"))[c(1)],"_",unlist(strsplit(noext, "_"))[c(3)]),
                   unlist(strsplit(noext, "_"))[c(5)],
                   unlist(strsplit(noext, "_"))[c(6)],
                   4,5,6,7,8,9,10,11,12)


### Scratch

Bstdrdhead


unlist(strsplit(noext, "_"))[c(5)]





stdrdhead<- data.frame(Astdrdhead, Bstdrdhead); names(stdrdhead)<- NULL
sapply(stdrdhead,class)
stdrdhead_t<- setNames(data.frame(t(stdrdhead[,-1])), stdrdhead[,1]); head(stdrdhead_t)
stdrdhead_t[, c(2,3)] <- sapply(stdrdhead_t[, c(2,3)], as.numeric)



class(stdrdhead_t$R.enddate)


str(stdrdhead_t)
View(stdrdhead_t)

stringsAsFactors = FALSE





newfile<- as.data.frame(write.table(newfile,col.names = FALSE, row.names = FALSE))
View(newfile)
str(newfile)




write.table(iris, file = "iris.csv", col.names = FALSE, row.names = FALSE, sep = ",")


View(file)








### Scratch

?strptime


convertToDateTime(file$Time, origin = "1900-01-01")
strsplit(list.files(pattern=pattern), "\\.")[[1]]
ymd(basename(file))
gsub("^[^0-9]+\\.|\\.[A-Za-z]+$", "", file)
data.frame(c(1,2,3),c("a","b","c"))
df_name(1,"a")
mydf <- data.frame(A = c(letters[1:10]), M1 = c(11:20), M2 = c(31:40), M3 = c(41:50))
mydf
t(mydf)
tmydf = data.frame(t(mydf))
tmydf
names(tmydf) <- tmydf[1,]

tmydf = setNames(data.frame(t(mydf[,-1])), mydf[,1])

mydf <- data.table(A = c(letters[1:10]), M1 = c(11:20), M2 = c(31:40), M3 = c(41:50))
tmydf <- setNames(data.table(t(mydf[,-"A"])), mydf[["A"]])
(tmydf = setNames(data.frame(t(mydf[,-1])), mydf[,1]))
tmp <- as.data.frame(t(mydf[,-1]))
colnames(tmp) <- mydf$A
tmp


df %>%
  t() %>%
  as.data.frame(stringsAsFactors = F) %>%
  rownames_to_column("value") %>%
  `colnames<-`(.[1,]) %>%
  .[-1,] %>%
  `rownames<-`(NULL)


pp<- data.frame(3:6,c("a","b","c","d"));head(pp)
colnames(pp)


(z <- Sys.time())             # the current datetime, as class "POSIXct"
unclass(z)                    # a large integer
floor(unclass(z)/86400)       # the number of days since 1970-01-01 (UTC)
(now <- as.POSIXlt(Sys.time())) # the current datetime, as class "POSIXlt"
unlist(unclass(now))          # a list shown as a named vector
now$year + 1900               # see ?DateTimeClasses
months(now); weekdays(now)    # see ?months

## suppose we have a time in seconds since 1960-01-01 00:00:00 GMT
## (the origin used by SAS)
z <- 1472562988
# ways to convert this
as.POSIXct(z, origin = "1960-01-01")                # local
as.POSIXct(z, origin = "1960-01-01", tz = "GMT")    # in UTC

## SPSS dates (R-help 2006-02-16)
z <- c(10485849600, 10477641600, 10561104000, 10562745600)
as.Date(as.POSIXct(z, origin = "1582-10-14", tz = "GMT"))

## Stata date-times: milliseconds since 1960-01-01 00:00:00 GMT
## format %tc excludes leap-seconds, assumed here
## For format %tC including leap seconds, see foreign::read.dta()
z <- 1579598122120
op <- options(digits.secs = 3)
# avoid rounding down: milliseconds are not exactly representable
as.POSIXct((z+0.1)/1000, origin = "1960-01-01")
options(op)

## Matlab 'serial day number' (days and fractional days)
z <- 7.343736909722223e5 # 2010-08-23 16:35:00
as.POSIXct((z - 719529)*86400, origin = "1970-01-01", tz = "UTC")

as.POSIXlt(Sys.time(), "GMT") # the current time in UTC

## These may not be correct names on your system
as.POSIXlt(Sys.time(), "America/New_York")  # in New York
as.POSIXlt(Sys.time(), "EST5EDT")           # alternative.
as.POSIXlt(Sys.time(), "EST" )   # somewhere in Eastern Canada
as.POSIXlt(Sys.time(), "HST")    # in Hawaii
as.POSIXlt(Sys.time(), "Australia/Darwin")





# Tcal.table[2,paste0(unlist(strsplit(noext, "_"))[c(1)],"_",unlist(strsplit(noext, "_"))[c(3)])]



# rownames(Tcal.table)<- colnames(cal.table)
