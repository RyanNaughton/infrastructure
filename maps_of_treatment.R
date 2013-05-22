library(foreign)
library(sp)
library(rgdal)
library(sm)
library(shapefiles)
library(rgeos)


data <- read.dta(file="data/school_data_complete.dta")
costa_rica_provincia <- readOGR("CRI_adm",layer="CRI_adm1")
costa_rica_cantones <- readOGR("CRI_adm",layer="CRI_adm2")

table(subset(data,treatment==1)[,c('tipo','ano')])

data_2007_colegios <- subset(data,ano == 2007 & tipo == "COLEGIOS")
data_2007_escuelas <- subset(data,ano == 2007 & tipo == "ESCUELAS")

# lat_lon <- data_2007[,c('longitud','latitud')][complete.cases(data_2007[,c('longitud','latitud')]),]
# 
# clusters <- kmeans(lat_lon,centers=30,iter.max=10000)
# plot(lat_lon$longitud,lat_lon$latitud,col=clusters$cluster,pch=20)
# points(data_2007$longitud,data_2007$latitud,col=as.factor(data_2007$provincia))

plot(costa_rica_cantones,border=rgb(0,0,0,0.2))
plot(costa_rica_provincia,add=TRUE,border=rgb(0,0,0,0.4))
points(data_2007_colegios$longitud,data_2007_colegios$latitud,pch=20)

plot(costa_rica_cantones,border=rgb(0,0,0,0.2))
plot(costa_rica_provincia,add=TRUE,border=rgb(0,0,0,0.4))
data_2007_escuelas_treatment <- subset(data_2007_escuelas,treatment==1)
data_2007_escuelas_control <- subset(data_2007_escuelas,treatment==0)
points(data_2007_escuelas_control$longitud,data_2007_escuelas_control$latitud,pch=20,col=rgb(0,0,0,0.2))
points(data_2007_escuelas_treatment$longitud,data_2007_escuelas_treatment$latitud,pch=20,col=rgb(1,0,0,1))


plot(costa_rica_cantones,border=rgb(0,0,0,0.2))
plot(costa_rica_provincia,add=TRUE,border=rgb(0,0,0,0.4))
data_2007_colegios_treatment <- subset(data_2007_colegios,treatment==1)
data_2007_colegios_control <- subset(data_2007_colegios,treatment==0)
points(data_2007_colegios_control$longitud,data_2007_colegios_control$latitud,pch=20,col=rgb(0,0,.5,0.2))
points(data_2007_colegios_treatment$longitud,data_2007_colegios_treatment$latitud,pch=20,col=rgb(1,0,0,1))


centro_educativo <- subset(data_2007_colegios,treat_infraestructuraaconstruir == "Centro Educativo")
plot(costa_rica_cantones,border=rgb(0,0,0,0.2))
plot(costa_rica_provincia,add=TRUE,border=rgb(0,0,0,0.4))
points(data_2007_colegios_control$longitud,data_2007_colegios_control$latitud,pch=20,col=rgb(0,0,.5,0.2))
points(centro_educativo$longitud,centro_educativo$latitud,pch=20,col=rgb(1,0,0,1))





matched_data <- read.dta(file="data/sample3.dta")
matched_data <- subset(matched_data,!is.na(pair))

plot(costa_rica_sp)
points(matched_data$longitud,matched_data$latitud,col=matched_data$pair,pch=20 + matched_data$treatment)

indices <- seq(from=1,length(unique(matched_data$pair)),by=5)
indices[length(indices)] <- length(unique(matched_data$pair))

for(x in 2:length(indices)){
  png(filename=paste("match_subset_",x,".png",sep=""),width=800,height=800)
  tmp <- subset(matched_data,pair %in% unique(matched_data$pair)[indices[(x-1)]:indices[x]])
  plot(costa_rica_sp)
  title(x-1)
  points(tmp$longitud,tmp$latitud,col=as.factor(tmp$pair),pch=20 + tmp$treatment)
  dev.off()
}
plot(costa_rica_sp)
points(matched_data$longitud,matched_data$latitud,col=matched_data$pair,pch=20 + matched_data$treatment)


matched_data$treatment
