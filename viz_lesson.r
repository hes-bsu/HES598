library(tidycensus)
library(tidyverse)
library(sf)
library(raster)
library(tmap)
library(rasterVis)
library(latticeExtra)
library(RColorBrewer)
library(viridis)
library(tigris)

setwd('C:/users/nicho/BSU/rgeo/HES598')

## building a vector dataset
## not an object!
census_api_key('5f23fe74f5d1e4893b610d4a591a9226900a55da')

## accessing census data
id.income <- get_acs(geography = 'county', 
                     variables = c('B19013_001', 'B01002_001'), ## using load_variables())
                     state = 'ID',
                     year = 2018, geometry = TRUE) %>% 
  ## tidyverse
  mutate(rename = str_replace_all(.$variable, (c('B19013_001' = 'income','B01002_001' = 'age' )))) %>% 
            dplyr::select(c(GEOID, rename, estimate)) %>% 
  ## select column to keep - have to use spread bc pivot_wider not currently woring for sf objects
  ## necessary to remove problem of duplicates for GEOID (formerly 2 -> one each age, income)
            spread(., key = rename, value = estimate)   

## join with the nonprofit dataset

id.nonprof <-read.csv('./data/bmfcount.csv', stringsAsFactors = F, colClasses = 'character')

## sf object -> joining using the GEOID/FIPS
id.census.sf <- id.income %>% 
  left_join(., id.nonprof, by = c("GEOID" = "FIPS"))

## sp object
id.census.sp <- as(id.census.sf, "Spatial")

## plotting the sp object
plot(id.census.sp, main = "Idaho Counties", sub="2018 Census Data", col="blue", border="white")

## plottin the simple features object
plot(id.census.sf, main= "Idaho Counties", sub="2018 Census Data", col="blue", border="white")

#if you just want the sf geometry
plot(st_geometry(id.census.sf), col="blue", border="white")


#hard to plot by attributes in base plot with Spatial* objects
plot(id.census.sp$income)
#Easier with sf
plot(id.census.sf["income"], main= "Idaho Income", sub="Median county value as of 2018")

## RASTER
id.elev <- raster('./data/id_elev.tif')
plot(id.elev)

## create a rasterBrick of terrain properties
id.terrain <- terrain(id.elev, opt=c('slope', 'aspect', 'TRI', 'TPI', 'flowdir'))
plot(id.terrain)

## adding functionality with spplot -> works for BOTH Spatial* and simple features
## creating a color brewer
income.pal <- brewer.pal(n=7, name = "Greens")

## sucks because the same color ramp is used for all plots
spplot(id.census.sp, col.regions = income.pal, cuts = 6)

## specifying age for a sensible scale
spplot(id.census.sp, 'age', col.regions = brewer.pal(n = 7, name = "Blues"), cuts = 6)

##Drawing polygons over raster or other vector data 
county.layer <- list("sp.polygons", id.census.sp, fill="transparent", col = "green", lwd = 1.5, first=FALSE)

spplot(id.census.sp, "income", sp.layout = county.layer)

#also works with rasters
spplot(id.elev, sp.layout = county.layer)
## specifying one of the terrain layers from the terrain brick
spplot(id.terrain, 'slope', sp.layout = county.layer)
