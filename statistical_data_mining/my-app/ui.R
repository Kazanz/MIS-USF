#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Drug Usage"),
  hr(),
  
  fluidRow(
    column(3,
      h4("Age of first time usage"),
      selectInput("drugInput", "Drug",
                  choices = c(
                    "Alchohol" = "ALCTRY",
                    "Chew" = "CHEWTRY",
                    "Cigar" = "CIGARTRY",
                    "Cigarette" = "CIGTRY",
                    "Cocaine" = "COCAGE",
                    "Marijuana" = "MJAGE",
                    "Snuff" = "SNUFTRY",
                    "Smokeless Tobacco" = "SLTTRY"
                    )
                  ),
      sliderInput("ageInput", "Age", min = 0, max = 100,
                  value = c(0, 100))
    ),
    column(9,
      plotOutput("agePlot")
    )
  ),
  
  hr(),
  fluidRow(
    column(3,
           h4("Age of first time use vs. # of users"),
           selectInput("explanatoryInput", "First time use",
                       choices = c(
                         "Alchohol" = "ALCTRY",
                         "Chew" = "CHEWTRY",
                         "Cigar" = "CIGARTRY",
                         "Cigarette" = "CIGTRY",
                         "Cocaine" = "COCAGE",
                         "Marijuana" = "MJAGE",
                         "Snuff" = "SNUFTRY",
                         "Smokeless Tobacco" = "SLTTRY"
                       )
           ),
           selectInput("dependentInput", "Number of users",
                       choices = c(
                         "Alchohol" = "ALCTRY",
                         "Chew" = "CHEWTRY",
                         "Cigar" = "CIGARTRY",
                         "Cigarette" = "CIGTRY",
                         "Cocaine" = "COCAGE",
                         "Marijuana" = "MJAGE",
                         "Snuff" = "SNUFTRY",
                         "Smokeless Tobacco" = "SLTTRY"
                       )
           ),
           sliderInput("scatterAgeInput", "Age", min = 0, max = 100,
                       value = c(0, 100))
    ),
    column(9,
        plotOutput("scatterPlot")
    )
  ),
  
  hr(),
  fluidRow(
    column(3,
           selectInput("predictInput", "Target Drug",
                       choices = c(
                         "Alchohol" = "ALCTRY",
                         "Chew" = "CHEWTRY",
                         "Cigar" = "CIGARTRY",
                         "Cigarette" = "CIGTRY",
                         "Cocaine" = "COCAGE",
                         "Marijuana" = "MJAGE",
                         "Snuff" = "SNUFTRY",
                         "Smokeless Tobacco" = "SLTTRY"
                       )
           ),
           h3("Explanatory Drugs"),
           checkboxInput("ALCTRY", "Alchohol"),
           checkboxInput("CHEWTRY", "Chew"),
           checkboxInput("CIGARTRY", "Cigar"),
           checkboxInput("CIGARTRY", "Cigar"),
           checkboxInput("CIGARTRY", "Cigar"),
           checkboxInput("CIGARTRY", "Cigar"),
    )
  )
  
))
