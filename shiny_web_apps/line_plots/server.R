library(shiny)
library(foreign)

data <- read.dta(file="../../data/school_data_complete.dta")


PlotOvertime <- function(data,variable){
  means_df <- aggregate(data[,variable],by=list(ano = data$ano,treatment = data$treatment),FUN=mean,na.rm=TRUE)
  plot(means_df$ano,means_df$x,pch=20,col= as.factor(means_df$treatment),type='o',ylab=variable,xlab='ano')
  legend('topleft',legend=levels(as.factor(means_df$treatment)),fill=1:2) #levels(as.factor(means_df$treatment)))
  means_df
}


# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  output$timePlot <- renderPlot({
    
    PlotOvertime(data,input$variable)
  })
})

