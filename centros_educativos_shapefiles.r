library(foreign)
library(sp)
library(rgdal)
library(sm)
library(shapefiles)
library(rgeos)

files <- list.files("data/Centros educativos/")
shapefiles <- files[grep(pattern=".shp$",x=files)]
shapefiles <- gsub(".shp",replacement="",shapefiles)

spatial_data <- lapply(shapefiles,FUN=function(file){
  readOGR("data/Centros educativos/",layer=file)
})

x <- 16
shapefiles[[x]]
spatial_data[[x]]
plot(spatial_data[[x]])
