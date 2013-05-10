library(sp)
library(rgdal)
library('sm')
library(shapefiles)
library(rgeos)


costa_rica_sp <- readOGR("CRI_adm/",layer="CRI_adm0")

plot(costa_rica_sp)