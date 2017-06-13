#### PACKAGES ####
install.packages(c("ggplot2", "raster", "rgdal", "dplyr", "maps", "ggthemes"))
require(ggplot2)
require(dplyr)
require(tidyverse)
require(maps)
require(ggthemes)
require (ggmap)
require (leaflet)

CA_map <- map('county', 'California')

setwd("C:/Users/Keller/Desktop/SpatialShiny/")

CAdata <- read.delim("CA.csv", 
                     sep = "|", 
                     as.is = TRUE,
                     na.strings=c("","NA"))
names(CAdata)

CAdata <- CAdata %>% select (id,name,class,state,county,lat,lon,elev) 
colnames(CAdata) <- c("featureID","feature_name","feature_class", "state",
                      "county", "primary_latitude", "primary_longitude","elevation")
CAdata$feature_name <- as.factor (CAdata$feature_name)
CAdata$feature_class <- as.factor (CAdata$feature_class)
CAdata$state <- as.factor(CAdata$state)
CAdata$county <- as.factor (CAdata$county)