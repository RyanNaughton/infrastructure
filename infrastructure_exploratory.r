library(foreign)
library(sp)
library(rgdal)
library('sm')
library(shapefiles)
library(rgeos)

setwd("~/Dropbox/R Data with July/Infrastructure/")

data <- read.dta(file="data_final.dta")

NY <- readOGR("/Users/ryan/Downloads/ZillowNeighborhoods-NY (1)/",layer="ZillowNeighborhoods-NY")
readOGR("~/Downloads/")

hist(table(data$codigo),ylim=c(0,200))
table(table(data$id))
table(table(data$codigo))

sum(table(data$codigo) > 8)

length(unique(data$codigo))

table(data$tipo)/7

barplot(table(data$ano))

#TODO Give unique ID to schools with escuela vs colegio

table(data$matri_region)/7
table(data$infra_region,useNA="always")/7

data[data$matri_region != data$infra_region,c("matri_region","infra_region")]
table(data$provincia,useNA="always")

hist(table(data$distrito,useNA="always"))

table(data$infra_zona,useNA="always")

summary(data$matri_total)
hist(data$matri_total,breaks=100)
hist(data$matri_total,xlim=c(0,500),breaks=200)

par(mfcol=c(2,1))
hist(data$matri_hombres,xlim=c(0,500),breaks=100,ylim=c(0,13000))
hist(data$matri_mujeres,xlim=c(0,500),breaks=100,ylim=c(0,13000))

par(mfcol=c(1,1))
x <- data$matri_hombres/data$matri_total
hist(x,xlim=c(0,1),breaks=50)

par(mfcol=c(2,1))
tapply(data$matri_total,data$infra_zona,FUN=hist,xlim=c(0,2500),breaks=100)

hist(data$matri_growth,breaks=100)

table(data$infra_biblioteca_total)

summary(data$infra_aulas_total == data$infra_aulas_buenas +  data$infra_aulas_regular +  data$infra_aulas_malas)

data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')]
cor(data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')],use="pairwise.complete.obs")


data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')]/data$infra_aulas_total
cor(data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')],use="pairwise.complete.obs")
cor(data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')]/data$infra_aulas_total,use="pairwise.complete.obs")

par(mfcol=c(3,1))
sapply(data[,c('infra_aulas_total','infra_aulas_buenas','infra_aulas_regular','infra_aulas_malas','infra_aulas_necesidad')],FUN=hist,xlim=c(0,30),breaks=100)

par(mfcol=c(1,1))
hist(data$infra_sanitarios_total)

plot(data$matri_total,data$infra_sanitarios_total,pch=20)

plot(data$matri_total,data$infra_sanitarios_total,pch=20)

plot(data)


plot(data[,sapply(data,FUN=function(x){!any(is.na(x))})])

names(data)[grep("total",names(data))]
plot(data[,c("matri_total","infra_aulas_total","infra_biblioteca_total","infra_comedor_total","infra_gimnasio_total","infra_sanitarios_total","infra_labinfo_total","infra_canchafutbol_total")],pch=20)

treatment <- subset(data,treatment == 1)
plot(treatment[,c("matri_total","infra_aulas_total","infra_biblioteca_total","infra_comedor_total","infra_gimnasio_total","infra_sanitarios_total","infra_labinfo_total","infra_canchafutbol_total")],pch=20,col=rgb(0,0,0,.3))

plot(treatment[,c("matri_total","infra_aulas_total")],pch=20,col=rgb(0,0,0,.3))
