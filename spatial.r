#packages
library(sp)
library(rgdal)
library(sm)
library(shapefiles)
library(rgeos)

#r at home cant open these
costa_rica_sp_0 <- readOGR("CRI_adm/",layer="CRI_adm0")
costa_rica_sp_1 <- readOGR("CRI_adm/",layer="CRI_adm1")
costa_rica_sp_2 <- readOGR("CRI_adm/",layer="CRI_adm2")
save(costa_rica_sp_0,costa_rica_sp_1,costa_rica_sp_2,file="cr_spatial_polygons.rdata")

#so I can load them instead...
load(file="cr_spatial_polygons.rdata")

#province
plot(costa_rica_sp_1)
head(costa_rica_sp_1@data)

#cantones
plot(costa_rica_sp_2)
head(costa_rica_sp_2@data)

