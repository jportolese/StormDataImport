library(RCurl)
library(tseries)

setwd("C:\\temp\\")


url <- 'ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/' #StormEvents_details-ftp_v1.0_d1950_c20170120.csv.gz'
#url <- 'https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/'
filenames <- getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
filenames <- paste(url, strsplit(filenames, "\r*\n")[[1]], sep = "") 

# storm details

a <- data.frame(z = filenames)
filterFileNames<- a[ grep("details", a$z) , ]


i = 0;
for (x in filterFileNames) {
  tmp_filename <- tempfile()
  download.file(x, tmp_filename)
  dat <- read.csv(tmp_filename)
  write.table(dat, file = "C:\\temp\\StormData\\StormDataDetails.csv", append = T, sep = ",", row.names = F, col.names = ifelse(i==0, T, F))
  file.remove(tmp_filename)
  i = i+1
}



# storm locations

a <- data.frame(z = filenames)
filterFileNames<- a[ grep("locations", a$z) , ]


i = 0; 
for (x in filterFileNames) {
  tmp_filename <- tempfile()
  download.file(x, tmp_filename)
  dat <- read.csv(tmp_filename)
  write.table(dat, file = "C:\\temp\\StormDataLocations.csv", append = T, sep = ",", row.names = F, col.names = ifelse(i==0, T, F))
  file.remove(tmp_filename) 
  i = i+1 
}


# storm fatalities

a <- data.frame(z = filenames)
filterFileNames<- a[ grep("fatalities", a$z) , ]


i = 0;
for (x in filterFileNames) {
  tmp_filename <- tempfile()
  download.file(x, tmp_filename)
  dat <- read.csv(tmp_filename)
  write.table(dat, file = "C:\\temp\\StormDataFatalities.csv", append = T, sep = ",", row.names = F, col.names = ifelse(i==0, T, F))
  file.remove(tmp_filename)
  i = i+1 
}

dfTest <- read.csv("h:\\Stormdata\\StormDataDetails.csv")
nrow(dfTest)

head(dfTest)
colnames(dfTest)
dfTest[89862,49:51]