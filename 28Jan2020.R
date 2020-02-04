install.packages('fasterize')
install.packages('velox')
install.packages('tigris')
install.packages('tidyverse')
install.packages('sf')
install.packages('sp')
install.packages('raster')
-----
  
library(fasterize)
library(velox)
library(tigris)
library(tidyverse)
library(sf)
library(sp)
library(raster)

#HOW YOU LOOK AT THE PROJECTION AND SPATIAL INFO 
idaho <- rgdal::readOGR("./data/idaho_cty.shp")
#sp::proj4string(idaho) --required package

idaho.sf <- sf::st_read("./data/idaho_cty.shp")
#sf::st_crs(idaho.sf) --required package


#How to bring in a projection or change it. 
#create a variable with that spatial info. You can look up an epsg catalog number. You can
#find a very local projection in the epsg database. In some cases, you can't use a code, and 
#will have to

#choose a few projections
nad83 <- "+init=epsg:4269"
idaho.cent <- "+proj=tmerc +lat_0=41.66666666666666 +lon_0=-114 +k=0.9999473679999999 +x_0=500000.0001016001 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs " 


idaho.83 <- spTransform(idaho, CRS(nad83))
idaho.c <- spTransform(idaho, CRS(idaho.cent))

#are they different?
identicalCRS(idaho.83, idaho.c)

#reproject idaho.cent
idaho.reproj <- spTransform(idaho.83, proj4string(idaho.c))

#are they different?
identicalCRS(idaho.c, idaho.reproj)

#be careful to look through the rmd document for today--
