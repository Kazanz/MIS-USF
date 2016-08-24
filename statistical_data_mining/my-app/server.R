#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

data <- load("/Users/kazanz/usf/statistical_data_mining/my-app/da34933.0001.rda")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  histoData = reactive({
    hist(da34933.0001[[ input$drugInput[1]]], main=paste("Age of first usage"),
         xlab="Drug", xlim=c(input$ageInput[1], input$ageInput[2]))
  })
  
  scatterPlot = reactive({
    age <- da34933.0001[[ input$explanatoryInput[1] ]]
    count <- ifelse(is.na(da34933.0001[[ input$dependentInput[1] ]]) == TRUE, 0, 1)
    df <- data.frame(age, count)
    df <- data.frame(aggregate(df$count, by=list(count=df$age), FUN=sum))
    xyplot(df$x~df$count, xlab="age", ylab="# of users",
           xlim=c(input$scatterAgeInput[1], input$scatterAgeInput[2]))
  })
  
  output$agePlot <- renderPlot(histoData())
  output$scatterPlot <- renderPlot(scatterPlot())
})
