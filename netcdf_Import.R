library(ncdf4) 
library(raster) 
library(rgdal) 
library(ggplot2)

# set working directory where the netcdf file is stored
workdir <- "c:\\JP\\weatherdata\\"
setwd(workdir)

# NDVI Time Series of AVHRR imagery for growing season images 
#processed for each year 1982 -2012
ncname <- "gimms3g_ndvi_1982-2012.nc4"

netfile <- nc_open(ncname)
# print info on this file
print(netfile)

lon <- ncvar_get(netfile, "lon")
lat <- ncvar_get(netfile, "lat", verbose = F)
t <- ncvar_get(netfile, "time")

# store the data in a 3-dimensional array
ndvi.array <- ncvar_get(netfile, "NDVI") 
dim(ndvi.array) 

# identify the fill value for water areas for conversion to NA in the later step
fillvalue <- ncatt_get(netfile, "NDVI", "_FillValue")
fillvalue

# Through reading the file so close the connection to it in R
nc_close(netfile) 

# Update the fill value to NA instead of -9999
ndvi.array[ndvi.array == fillvalue$value] <- NA

# pull the first year time slice (1982)
ndvi.slice <- ndvi.array[, , 1] 

# Convert the slice to a rasterlayer 
r <- raster(t(ndvi.slice)
            , xmn=min(lon)
            , xmx=max(lon)
            , ymn=min(lat)
            , ymx=max(lat)
            , crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

# most netcdf files record data from the bottom left so the image needs to be flipped
r <- flip(r, direction='y')
class(r)

# plot the image
plot(r)

# write to geotiff
writeRaster(r, "AVHRR_1982.tif", "GTiff", overwrite=TRUE)

# convert the entire array to raster brick
r_brick <- brick(ndvi.array, xmn=min(lat), xmx=max(lat), ymn=min(lon)
                 , ymx=max(lon)
                 , crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

# same issue with the r_brick it needs to be flipped due to the way the 
# netcdf file records the data
r_brick <- flip(t(r_brick), direction='y')


# Identfy and graph the NDVI values at Topeka Kansas 39.106 latitude, -95.7828 longitude
 
topeka_lon <- -95.782793
topeka_lat <- 39.106060
# pull the datapoints for Topeka from the raster brick for all years
topeka_series <- extract(r_brick, SpatialPoints(cbind(topeka_lon,topeka_lat))
                         , method='simple')
 # Create Graph
topeka_df <- data.frame(year= seq(from=1982, to=2012, by=1), NDVI=t(topeka_series))
ggplot(data=topeka_df, aes(x=year, y=NDVI, group=1)) +
  geom_line() + 
  ggtitle("NDVI at Topeka Kansas 1982 - 2012") +   
  theme_bw() 


# compute the difference from first year to the last (1982 vs 2012) for the entire array
# all lat long grid cells
ndvi_1982 <- ndvi.array[, , 1]
ndvi_2012 <- ndvi.array[, , 31] 

# get the difference by subtracting the slices
ndvi_diff <- ndvi_2012 - ndvi_1982
plot(ndvi_diff)

r_diff <- raster(t(ndvi_diff), xmn=min(lon), xmx=max(lon), ymn=min(lat), ymx=max(lat)
                 , crs=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0"))

# Again the data needs to be flipped
r_diff <- flip(r_diff, direction='y')

# plot the difference values to compare the NDVI values from 1982 to 2012
plot(r_diff)