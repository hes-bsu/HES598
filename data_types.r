install.packages('sp')
install.packages('rgdal')
install.packages('sf')

## ubiquitous - creates Spatial* objects often necessary
library(sp)
library(rgdal)

## reading the shapefile
idaho <- readOGR("./data/idaho_cty.shp")

## structure of the data
str(idaho)

## all attributes for the first 5 polygons
head(idaho)

## sp command for returning projection
proj4string(idaho)

## bounding box coordinates
bbox(idaho)

## plot
plot(idaho)

## simple features library - works well for plots, calculations, etc
library(sf)

##load ID as a simple feature
idaho.sf <- st_read("./data/idaho_cty.shp")

## structure of idaho.sf
str(idaho.sf)

## exploring head
head(idaho.sf)
## column of geometry data exists - tidyverse exclusive - allows for lists in dataframe

## this barfs - proj4string requires an sp object
proj4string(idaho.sf)

## simple feature alternative to proj4string
st_crs(idaho.sf)

## similarly, simple feature version of bbox
st_bbox(idaho.sf)

## geometry for simple features
st_geometry(idaho.sf)

## RASTERS!
#install.packages('raster')
library(raster)

## usually faster, but reprojection can be problematic
## velox - takes entire raster into memory and runs the operation
## being replaced by terra
## rasterstacks are more flexible than bricks - do not require identical extent
## stars is a new approach to deal with vector/raster data together
