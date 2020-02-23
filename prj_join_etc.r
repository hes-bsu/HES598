## Objectives
## Projections, joins, zonal stats, etc

## CRS stored as proj4 string or a EPSG code; WKT (Well known text) ~ ENVI, etc.


library(fasterize)
library(raster)
library(velox)
library(sf)
library(sp)
library(tigris)
library(tidyverse)
library(maps)
library(mapproj)
library(patchwork)

setwd('.')

## Reprojections in using sp
## double colon -> don't have to library() or require()
idaho <- rgdal::readOGR("./data/idaho_cty.shp")
sp::proj4string(idaho)

idaho.sf <- sf::st_read("./data/idaho_cty.shp")
sf::st_crs(idaho.sf)

## EPSG number -> compact syntax!
nad83 <- "+init=epsg:4269"

## reprojected
idaho_83 <- spTransform(idaho, CRS(nad83))

##checking units for the above -> no_defs
proj4string(idaho_83)

## proj4 string - heinous
idaho_cent <- "+proj=tmerc +lat_0=41.66666666666666 +lon_0=-114 +k=0.9999473679999999 +x_0=500000.0001016001 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs " 

## reprojections
idaho_83 <- spTransform(idaho, CRS(nad83))
idaho_c <- spTransform(idaho, CRS(idaho_cent))

## are they different? -> FALSE -> NEED TO BE Spatial* objects
identicalCRS(idaho_83, idaho_c)

## reproject to idaho_c
idaho_reprj <- spTransform(idaho_83, proj4string(idaho_c))

identicalCRS(idaho_reprj, idaho_c) ##TRUE

## USING sf
#choose a few projections
nad83 <- "+init=epsg:4269"
idaho_cent <- "+proj=tmerc +lat_1=41.66666666666666 +lon_0=-114 +k=0.9999473679999999 +x_0=500000.0001016001 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs " 

idaho_sf <- sf::st_read("./data/idaho_cty.shp")
sf::st_crs(idaho.sf)

idaho_sf_83 <- sf::st_transform(idaho_sf, nad83)
idaho_sf_c <- sf::st_transform(idaho_sf, idaho_cent)
## are they the same?
st_crs(idaho_sf_83) == st_crs(idaho_sf_c)

##reproject using sf syntax
idaho_sf_reproj <- st_transform(idaho_sf_83, st_crs(idaho_sf_c))

## are they the same?
st_crs(idaho_sf_reproj) == st_crs(idaho_sf_c)

##JOINS

head(idaho_83@data)

#load a tabular dataset
idaho_nonprof <- read.csv("./data/bmfcount.csv", stringsAsFactors = FALSE, colClasses = "character")
head(idaho_nonprof)

#join based on the columns that match
## geo_join joining based on the columns we want to join!
idaho_join <- tigris::geo_join(idaho_83, data_frame = idaho_nonprof, by_sp = "GEOID", by_df="FIPS", how="left")
head(idaho_join@data)
str(idaho_join@data)


## Joining by attrbutes using `sf`
head(idaho_sf_83)
str(idaho_sf_83)

idaho_join_sf <- idaho_sf_83 %>% 
  left_join(., idaho_nonprof, by = c("GEOID" = "FIPS"))
head(idaho_join_sf)
str(idaho_join_sf)

##continue with raster stuff
