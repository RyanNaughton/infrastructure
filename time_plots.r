library(foreign)


data <- read.dta(file="data/school_data_complete.dta")

names(data)
table(data$ano)

treatment <- data$treatment
treatment[treatment != 1] <- 0.05

plot(data$ano,data$infra_aulas_total,pch=20,col=rgb(data$treatment,0,0,0.05))
plot(data$ano,log10(data$infra_aulas_total),pch=20,col=rgb(data$treatment,0,0,0.05))


treatment_df <- subset(data,treatment == 1)


plot(treatment_df$ano,treatment_df$infra_aulas_total,pch=20,col= as.factor(data$id),type='o')

school_uID <- unique(treatment_df$id)
tmp <- subset(treatment_df,id == school_uID[1])

plot(tmp$ano,tmp$infra_aulas_total,pch=20,col=1,type='l')
sapply(,FUN=function(x){
  tmp <- subset(treatment_df,id == x)
  lines(tmp$ano,tmp$infra_aulas_total,pch=20,col=)
})
         
         treatment_df$ano,treatment_df$infra_aulas_total,pch=20,col= as.factor(data$id))


boxplot(data$infra_aulas_total ~ data$treatment + data$ano, ylim=c(0,20)) 
boxplot(data$infra_aulas_total ~ data$ano + data$treatment, ylim=c(0,30),pch=20) 


#,pch=20,col=rgb(data$treatment,0,0,0.05))

PlotOvertime <- function(data,variable){
  means_df <- aggregate(data[,variable],by=list(ano = data$ano,treatment = data$treatment),FUN=mean,na.rm=TRUE)
  plot(means_df$ano,means_df$x,pch=20,col= as.factor(means_df$treatment),type='o',ylab=variable,xlab='ano')
  legend('topleft',legend=levels(as.factor(means_df$treatment)),fill=1:2) #levels(as.factor(means_df$treatment)))
  means_df
}

PlotOvertime(data=data,variable="matri_total")
PlotOvertime(data=data,variable="infra_sanitarios_total")
PlotOvertime(data=data,variable="infra_aulas_total")
PlotOvertime(data=data,variable="infra_aulas_necesidad")

data$infra_aulas_necesidad
means_df <- aggregate(data$infra_aulas_total,by=list(ano = data$ano,treatment = data$treatment),FUN=mean,na.rm=TRUE)

hist(data$infra_sanitarios_total,xlim=c(0,10),breaks=500)

barplot(table(data$infra_sanitarios_total))

plot(means_df$ano,means_df$x,pch=20,)

plot(means_df$ano,means_df$x,pch=20,col= as.factor(means_df$treatment),type='o')
legend('topleft',legend=levels(as.factor(means_df$treatment)),fill=1:2) #levels(as.factor(means_df$treatment)))

table(data$treatment)

summary(data$treatment)



plot(data$longitud,data$latitud,pch=20,col=rgb(data$treatment,0,0,treatment))