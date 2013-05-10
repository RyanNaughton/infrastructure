#packages
library(foreign)
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

head(costa_rica_sp_1@data)
head(costa_rica_sp_2@data)

#load infrastructure data
data <- read.dta(file="data/data_final.dta")

canton_names_idb <- sort(unique(data$canton))[-1]
canton_names_gis <- toupper(sort(as.character(unique(costa_rica_sp_2@data$NAME_2))))

canton_names_gis_df <- data.frame(canton_accented = canton_names_gis)
canton_names_gis_df$canton_cleaned <- gsub("'|~","",iconv(canton_names_gis_df$canton_accented, to="ASCII//TRANSLIT"))

costa_rica_sp_2@data$formatted_names <- toupper(as.character(costa_rica_sp_2@data$NAME_2))

setdiff(canton_names_gis_df$canton_cleaned,canton_names_idb)
setdiff(canton_names_idb,canton_names_gis_df$canton_cleaned)

canton_names_gis_df$canton_cleaned[canton_names_gis_df$canton_cleaned == "CANAS"] <- "CA\xd1AS"
canton_names_gis_df$canton_cleaned[canton_names_gis_df$canton_cleaned == "LEON CORTES"] <- "LEON CORTES CASTRO"
canton_names_gis_df$canton_cleaned[canton_names_gis_df$canton_cleaned == "VASQUEZ DE CORONADO"] <- "VAZQUEZ DE CORONADO"
canton_names_gis_df$canton_cleaned[canton_names_gis_df$canton_cleaned == "ALFARO RUIZ"] <- "ZARCERO"

#canton_names_gis_df
#costa_rica_sp_2
#tmp <- merge(canton_names_gis_df,costa_rica_sp_2,by.x="canton_accented",by.y="formatted_names")
#tapply(data$matri_total,INDEX=list(canton=data$canton,ano=data$ano),FUN=sum,na.rm=TRUE)

data_by_canton_and_year <- aggregate(x=data[,c('infra_sanitarios_total','infra_aulas_total','matri_total')],by=list(canton=data$canton,ano=data$ano),FUN=sum,na.rm=TRUE)

data_2008 <- subset(data_by_canton_and_year,ano == 2008)
data_2008 <- merge(canton_names_gis_df,data_2008,by.x="canton_cleaned",by.y="canton")
data_2008 <- data_2008[order(data_2008$canton_accented),]

costa_rica_sp_2 <- costa_rica_sp_2[order(costa_rica_sp_2$formatted_names),]
blue_color_f <- colorRamp(c("light blue","dark blue"))
blue_color_rev_f <- colorRamp(c("dark blue","light blue"))

Scale01 <- function(x){
  scale(x,center=min(x,na.rm=TRUE),scale=diff(range(x,na.rm=TRUE)))
}

plot(costa_rica_sp_2,col=rgb(blue_color_f(Scale01(data_2008$infra_sanitarios_total)),maxColorValue=255))
plot(costa_rica_sp_2,col=rgb(blue_color_f(Scale01(data_2008$infra_sanitarios_total/data_2008$matri_total)),maxColorValue=255),border=rgb(.96,.96,.96),main="Sanitarios por matri")
plot(costa_rica_sp_2,col=rgb(blue_color_f(Scale01(data_2008$infra_aulas_total/data_2008$matri_total)),maxColorValue=255),border=rgb(.96,.96,.96))

data_2008$students_per_aula <- data_2008$matri_total/data_2008$infra_aulas_total

hist(Scale01(data_2008$infra_sanitarios_total/data_2008$matri_total))
hist(data_2008$infra_sanitarios_total/data_2008$matri_total)

hist(data_2008$infra_sanitarios_total)

##Provinces##

provincia_names_idb <- sort(unique(data$provincia))[-1]
provincia_names_gis <- toupper(sort(as.character(unique(costa_rica_sp_2@data$NAME_1))))

provincia_names_gis_df <- data.frame(provincia_accented = provincia_names_gis)
provincia_names_gis_df$provincia_cleaned <- gsub("'|~","",iconv(provincia_names_gis_df$provincia_accented, to="ASCII//TRANSLIT"))

costa_rica_sp_1@data$formatted_names <- toupper(as.character(costa_rica_sp_1@data$NAME_1))

setdiff(provincia_names_gis_df$provincia_cleaned,provincia_names_idb)
setdiff(provincia_names_idb,provincia_names_gis_df$provincia_cleaned)


#provincia_names_gis_df
#costa_rica_sp_2
#tmp <- merge(provincia_names_gis_df,costa_rica_sp_2,by.x="provincia_accented",by.y="formatted_names")
#tapply(data$matri_total,INDEX=list(provincia=data$provincia,ano=data$ano),FUN=sum,na.rm=TRUE)

data_by_provincia_and_year <- aggregate(x=data[,c('infra_sanitarios_total','infra_aulas_total','matri_total')],by=list(provincia=data$provincia,ano=data$ano),FUN=sum,na.rm=TRUE)

provincia_data_2007 <- subset(data_by_provincia_and_year,ano == 2007)
provincia_data_2007 <- merge(provincia_names_gis_df,provincia_data_2007,by.x="provincia_cleaned",by.y="provincia")
provincia_data_2007 <- provincia_data_2007[order(provincia_data_2007$provincia_accented),]

costa_rica_sp_1 <- costa_rica_sp_1[order(costa_rica_sp_1$formatted_names),]

plot(costa_rica_sp_1,col=rgb(blue_color_f(Scale01(provincia_data_2007$infra_sanitarios_total)),maxColorValue=255))

provincia_data_2007$students_per_aula <- provincia_data_2007$matri_total/provincia_data_2007$infra_aulas_total

provincia_data_2007

hist(data_2008$infra_sanitarios_total)

hist(provincia_data_2007$students_per_aula)
provincia_data_2007


all_2007 <- subset(data,ano==2007)
hist(all_2007$matri_total/all_2007$infra_aulas_total,xlim=c(0,50),breaks=500)