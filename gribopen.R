library(raster)

workdir <- "c:\\JP\\weatherdata\\"
setwd(workdir)

GRIB<-brick("EastAtlantic.wind.7days.grb")
grib <- raster("EastAtlantic.wind.7days.grb", band = 1) 
plot(grib)