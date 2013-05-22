library(foreign)
library(sp)
library(rgdal)
library(rgeos)
library(shapefiles)


costa_rica_provincia
data <- read.dta(file="data/matched_final.dta")
costa_rica_provincia <- readOGR("CRI_adm",layer="CRI_adm1")
costa_rica_cantones <- readOGR("CRI_adm",layer="CRI_adm2")

costa_rica_provincia <- read.shapefile("CRI_adm/CRI_adm1")

SpatialPolygons(as.list(costa_rica_provincia))

table(subset(data,treatment==1)[,c('tipo','ano')])

data_colegios <- subset(data,matched == 3) #tipo == "COLEGIOS")
data_colegios$uID <- data_colegios[,'_id']
data_colegios$pscore_f <- cut(data_colegios$pscore,breaks=c(0,0.2,0.4,0.6,0.8,1))


treatment <- subset(data_colegios,treatment == 1 )
control <- subset(data_colegios,treatment == 0)

for(i in 1:nrow(treatment)){
  png(filename=paste0('plots/match_distances_',i,'.png'),width=500,height=500)
  control_ids <- simplify2array(treatment[i,c('_n1','_n2','_n3','_n4','_n5')])
  matched_controls <- subset(control,uID %in% control_ids)
  matched_controls <- merge(matched_controls,data.frame(uID = control_ids,rank = 1:5))
  
  
  #plot(costa_rica_cantones,border=rgb(0,0,0,0.2))
  plot(costa_rica_cantones[-61,],,border=rgb(0,0,0,0.2))
  plot(costa_rica_cantones[61,],add=TRUE,border=rgb(0,0,0,0.2))
  plot(costa_rica_provincia,add=TRUE,border=rgb(0,0,0,0.4))
  
  points(treatment[i,c('longitud','latitud')],pch=17,col=2)
  points(matched_controls[,c('longitud','latitud')],pch=20,col=matched_controls$rank + 2)
  
  legend('bottomleft',legend=c("treatment",paste('nearest neighbor:',1:5)),pch=c(17,20,20,20,20,20),col=2:8)
  dev.off()
}

treatment_long <- reshape(treatment,direction='long',varying=c('_n1','_n2','_n3','_n4','_n5'),idvar="_id",v.names="matched_id")
names(treatment_long)[names(treatment_long)== "time"] <- "match_rank"

#removed unmatched treatments
treatment_long <- subset(treatment_long, !is.na(matched_id))

merged <- merge(x=treatment_long,y=control,by.x='matched_id',by.y='uID',suffixes=c("_treatment","_control"))

distances <- sapply(1:nrow(merged),FUN=function(row_id){
  tmp <- merged[row_id,]
  spDistsN1(as.matrix(tmp[,c('longitud_treatment','latitud_treatment')]),as.matrix(tmp[,c('longitud_control','latitud_control')]),longlat=TRUE)
})

merged$distances <- distances

tmp <- by(merged,INDICES=merged$uID,FUN=function(x){
  x$matched_id[which.min(x$distance)]
})

closest_matches <- data.frame(treatment_id = names(as.list(tmp)), closest_match_id = simplify2array(as.list(tmp)))

#how many duplicated control ids?
sum(duplicated(closest_matches$closest_match_id))

#duplicated control ids count
table(closest_matches$closest_match_id)
hist(table(closest_matches$closest_match_id))

tmp2 <- by(merged,INDICES=merged$uID,FUN=function(x){
  x[order(x$distances),][1:3,'matched_id']
})

three_closest_matches <- data.frame(t(simplify2array(as.list(tmp2))))
three_closest_matches$treatment_id <- as.numeric(row.names(three_closest_matches))
three_closest_matches

three_closest_matches
