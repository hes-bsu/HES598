install.packages("fasterize")
install.packages("velox")
install.packages("tigris")
install.packages("tidyverse")
install.packages("sf")
install.packages("sp")
install.packages("raster")

library(sp)
library(rgdal)
library(tidyverse)
library(fasterize)
library(velox)
library(tigris)
library()

idaho <- readOGR("./data/idaho_cty.shp")
library(sp)
library(rgdal)

idaho <- readOGR("./data/idaho_cty.shp")  ## Loading a shapefile with 'sp' and 'rgdal' (imports 'OGR' vector into r)

## Inspecting a 'Spatial*' object

##```{r spinspect, echo = true, eval = FALSE}

str(idaho) ## Compact way to display the structure of an R object - best for displaying contents of lists

head(idaho)  ## Examines all lines of the dataframe

proj4string(idaho)  ## Sets or retrieves projection attributes using the CSR object 

head(geometry(idaho)) 

bbox(idaho)  ## Retrieves spatial bounding box from spatial data

spsample()  ## Sampling of spatial points within the spatial extent of objects

plot(idaho) ## Plots the object

## Always check that the data you bring in is what you expect it to be (ArcGIS has algorithims to show what it thinks it should be, R does not)

library(sf)

idaho.sf <- st_read("./data/idaho_cty.shp")

str(idaho.sf) #used to display the structure of an 'R' object

head(idaho.sf) #returns the first n rows and m columns in a dataset

proj4string(idaho.sf) #retrieves the CRS for a spatial object (doesn't seem to work for this package)

st_crs(idaho.sf) #Also retrieves the CRS from the spatial oject

st_bbox(idaho.sf) #returns the bounding of a simple feature or simple feature set

st_geometry(idaho.sf) #return, set, or replace geometry from an sf object

plot(idaho.sf)

install.packages("raster")

library(raster)

id.elev <- raster("./data/id_elev.tif")

id.elev

head(id.elev)

summary(id.elev) #rasters are single variables so can summarize them like you would any other vector or matrix

crs(id.elev) #provides projection info

bbox(id.elev) #provides the extent of the raster dataset

r <- raster(ncol=10, nrow=10, xmx=-80, xmn=-150, ymn=20, ymx=60)

r

values(r) <- runif(ncell(r)) #values on the left side of <- allows you to assign new values to the empty raster

extent(r) <- bbox(id.elev) #sets the extent of r to match that of the id.elev dataset

