library(shiny)
library(foreign)

data <- read.dta(file="../../data/school_data_complete.dta")
desired_var_names <- names(data)[grep(pattern="^infra|^matri",x=names(data))]
#numeric_vars <- names(data)[sapply(data,class) %in% c("numeric","integer")]


# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Treatment vs Control Line Plots"),
  
  sidebarPanel(
    selectInput("variable", "Variable:",
                as.list(desired_var_names)),
    
    checkboxInput("outliers", "Show outliers", FALSE)
  ),
  
  mainPanel(
    plotOutput("timePlot")
  )
))