library(shiny)
library(gridExtra)
library(lattice)

data <- read.csv("world_data.csv")

# TODO: make filtered data more dry.

shinyServer(function(input, output) {
  expenditurePlot = reactive({
    if (input$governmentTypeInput == 'All') {
      filteredData <- data
    } else {
      filteredData <- data[data$government == input$governmentTypeInput, ]
    }
    xyplot(filteredData$tax_burden ~ filteredData$gov_expend, type=c("p", "r"),
           xlab="Government Expend. % GDP", ylab="Tax Burden % GDP",
           xlim=c(0, 60),
           ylim=c(0, 60)
           )
  }) 
  
  govCountriedDataTable = reactive({
    if (input$governmentTypeInput == 'All') {
      filteredData <- data
    } else {
      filteredData <- data[data$government == input$governmentTypeInput, ]
    }   
    return(renderDataTable({filteredData}))
  })
  
  filteredTable = reactive({
    if (input$governmentTypeInput == 'All') {
      return(data.frame(sort(data$country)))
    } else {
      return(data.frame(sort(data[data$government == input$governmentTypeInput, ]$country)))
    }   
  })
  
  qualityOfLifePlots = reactive({
    if (input$governmentTypeInput == 'All') {
      filteredData <- data
    } else {
      filteredData <- data[data$government == input$governmentTypeInput, ]
    }   
    # This could be more DRY
    par(mfrow=c(3, 3))
    plot(density(filteredData$quality_of_life_index), main="", xlab="Quality of Life Index",
         xlim=c(floor(min(data$quality_of_life_index)), ceiling(max(data$quality_of_life_index))))
    plot(density(filteredData$purchasing_power_index), main="", xlab="Purchasing Power Index",
         xlim=c(floor(min(data$purchasing_power_index)), ceiling(max(data$purchasing_power_index))))
    plot(density(filteredData$safety_index), main="", xlab="Safety Index",
         xlim=c(floor(min(data$safety_index)), ceiling(max(data$safety_index))))
    plot(density(filteredData$health_care_index), main="", xlab="Health Care Index",
         xlim=c(floor(min(data$health_care_index)), ceiling(max(data$health_care_index))))
    plot(density(filteredData$cost_of_living_index), main="", xlab="Cost of Living Index",
         xlim=c(floor(min(data$cost_of_living_index)), ceiling(max(data$cost_of_living_index))))
    plot(density(filteredData$property_price_to_income_ratio), main="", xlab="Property Price to Income Ratio",
         xlim=c(floor(min(data$property_price_to_income_ratio)), ceiling(max(data$property_price_to_income_ratio))))
    plot(density(filteredData$traffic_commute_time_index), main="", xlab="Traffic Commute Time Index",
         xlim=c(floor(min(data$traffic_commute_time_index)), ceiling(max(data$traffic_commute_time_index))))
    plot(density(filteredData$pollution_index), main="", xlab="Pollution Index",
         xlim=c(floor(min(data$pollution_index)), ceiling(max(data$pollution_index))))
    plot(density(filteredData$climate_index), main="", xlab="Climate Index",
         xlim=c(floor(min(data$climate_index)), ceiling(max(data$climate_index))))
  })
  
  economicTable = reactive({
    df <- data.frame(data$country, data[[ input$economicIndicatorInput ]])
    return(df[rev(order(df[[ colnames(df)[2] ]])),])
  })
  
  economicQualityOfLifePlots = reactive({
    par(mfrow=c(3, 3))
    p1 = xyplot(data$quality_of_life_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Quality of Life Index",
           ylim=c(floor(min(data$quality_of_life_index)), ceiling(max(data$quality_of_life_index))))
    p2 = xyplot(data$purchasing_power_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Purchasing Power Index",
           ylim=c(floor(min(data$purchasing_power_index)), ceiling(max(data$purchasing_power_index))))
    p3 = xyplot(data$safety_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Safety Index",
           ylim=c(floor(min(data$safety_index)), ceiling(max(data$safety_index))))
    p4 = xyplot(data$health_care_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Health Care Index",
           ylim=c(floor(min(data$health_care_index)), ceiling(max(data$health_care_index))))
    p5 = xyplot(data$cost_of_living_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Cost of Living Index",
           ylim=c(floor(min(data$cost_of_living_index)), ceiling(max(data$cost_of_living_index))))
    p6 = xyplot(data$property_price_to_income_ratio~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Property Price to Income Ratio",
           ylim=c(floor(min(data$property_price_to_income_ratio)), ceiling(max(data$property_price_to_income_ratio))))
    p7 = xyplot(data$traffic_commute_time_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Traffic Commute Time Index", 
           ylim=c(floor(min(data$traffic_commute_time_index)), ceiling(max(data$traffic_commute_time_index))))
    p8 = xyplot(data$pollution_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Pollution Index",
           ylim=c(floor(min(data$pollution_index)), ceiling(max(data$pollution_index))))
    p9 = xyplot(data$climate_index~data[[ input$economicIndicatorInput ]], xlab="", ylab="", type=c('p', 'r'), main="Climate Index",
           ylim=c(floor(min(data$climate_index)), ceiling(max(data$climate_index))))
    grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9, ncol=3)
  })
  
  
  qualityTable <- function() {
    regr = lm(data$quality_of_life_index~data$gov_expend+data$government) 
    names = variable.names(regr)
    name.vector = c()
    val.vector = c()
    country.vector = c()
    for (i in 3:length(names)) {
      if(summary(regr)$coefficients[i, "Pr(>|t|)"] <= .05) {
        name.vector = c(name.vector, substring(names[i], 16))
        val.vector = c(val.vector, summary(regr)$coefficients[i, 1])
        countries = paste(as.vector(data[data$government == substring(names[i], 16), ]$country), collapse=", ")
        country.vector = c(country.vector, countries)
      }
    }
    df = data.frame(name.vector, val.vector, country.vector)
    colnames(df) <- c("Government Type", "Effect on Quality of Life Index", "Countries")
    return(df)
 } 
  
 spendTable <- function() {
    regr = lm(data$gov_expend~data$tax_burden+data$government) 
    names = variable.names(regr)
    name.vector = c()
    val.vector = c()
    country.vector = c()
    for (i in 3:length(names)) {
      if(summary(regr)$coefficients[i, "Pr(>|t|)"] <= .05) {
        name.vector = c(name.vector, substring(names[i], 16))
        val.vector = c(val.vector, summary(regr)$coefficients[i, 1])
        countries = paste(as.vector(data[data$government == substring(names[i], 16), ]$country), collapse=", ")
        country.vector = c(country.vector, countries)
      }
    }
    df = data.frame(name.vector, val.vector, country.vector)
    colnames(df) <- c("Government Type", "Effect on Expend. % of GDP", "Countries")
    return(df)
 } 
  
  output$resultsQuality = renderTable(qualityTable())
  output$resultsSpend = renderTable(spendTable())
  output$taxRegression = renderPrint({
    summary(lm(data$gov_expend~data$tax_burden+data$government))
  })
  output$qualityRegression = renderPrint({
    summary(lm(data$quality_of_life_index~data$gov_expend+data$government))
  })
  output$economicCountries = renderTable(economicTable(), include.rownames=FALSE, include.colnames=FALSE)
  output$economicQualityOfLifePlots = renderPlot(economicQualityOfLifePlots())
  output$governmentCountries = renderTable(filteredTable(), include.rownames=FALSE, include.colnames=FALSE)
  output$expendPlot = renderPlot(expenditurePlot())
  output$qualityOfLifePlots = renderPlot(qualityOfLifePlots())
})
