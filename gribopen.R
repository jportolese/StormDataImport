library(raster)

workdir <- "c:\\JP\\weatherdata\\"
setwd(workdir)


GRIB<-brick("GreatLakes.wind.7days.grb")
grib <- raster("GreatLakes.wind.7days.grb", band = 3) 
plot(grib)

writeRaster(grib, "C:\\JP\\weatherdata\\grib2.img")