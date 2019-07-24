library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2)

workdir <- "c:\\JP\\lightning\\"
setwd(workdir)

ncname <- "nldn-19860101.nc"

# open a NetCDF file
lightning <- nc_open(ncname)
print(lightning)

ncatt_get(lightning,"y")

#lon <- ncvar_get(lightning, "lon")
#lat <- ncvar_get(lightning, "lat", verbose = F)
xcoord <- ncvar_get(lightning, "x")
ycoord <- ncvar_get(lightning, "y")


lightning.array <- ncvar_get(lightning, "value") 
dim(lightning.array) 

grid_mapping_name <- ncatt_get(lightning, "crs", "grid_mapping_name")
standard_parallel <- ncatt_get(lightning, "crs", "standard_parallel")
longitude_of_central_meridian <- ncatt_get(lightning, "crs", "longitude_of_central_meridian")
latitude_of_projection_origin <- ncatt_get(lightning, "crs", "latitude_of_projection_origin")
false_easting <- ncatt_get(lightning, "crs", "false_easting")
false_northing <- ncatt_get(lightning, "crs", "false_northing")

nc_close(lightning)



strikes <- raster(t(lightning.array)
            , xmn=min(xcoord)
            , xmx=max(xcoord)
            , ymn=min(ycoord)
            , ymx=max(ycoord)
            , crs=CRS("+proj=aea +lat_1=27.5 +lat_2=35 +lat_0=18 +lon_0=-100 +x_0=1500000 +y_0=6000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
)
            #            , crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

 
strikes <- flip(strikes, direction='y')
class(strikes)

plot(strikes)

writeRaster(strikes, "C:\\JP\\weatherdata\\lightning01011986.img")


