library(sp)
library(rgdal)
library('sm')
library(shapefiles)
library(rgeos)


costa_rica_sp_0 <- readOGR("CRI_adm/",layer="CRI_adm0")
costa_rica_sp_1 <- readOGR("CRI_adm/",layer="CRI_adm1")
costa_rica_sp_2 <- readOGR("CRI_adm/",layer="CRI_adm2")

save(costa_rica_sp_0,costa_rica_sp_1,costa_rica_sp_2,file="cr_spatial_polygons.rdata")


plot(costa_rica_sp)