library(shiny)

data <- read.csv("world_data.csv")

getChoices <- function(column) {
  types = sort(unique(data[[ column ]]))
  return(c(c(all="All"), setNames(as.character(types), types)))
}

shinyUI(fluidPage(
  
  titlePanel("Quality of Life by Government Type and Economic System"),
  "By: Zach Kazanski",
  br(),
  "For: Statistical Data Mining @ USF with Wolfgang Jank",
  hr(),
  fluidRow(
    column(
      12,
      tabsetPanel(
        tabPanel(
          "Summary",
          br(),
          h3("Questions"),
          tags$ul(
            tags$li("Do conservative or liberal governments provide higher quality life for their citizens?"),
            tags$li("What government structure provides a higher quality of life for their citizens? (Ie. Communist State vs. Parlimentary Republic?)")
          ),
          h3("Methodology"),
          "For this project a naive metrics of the imposed tax burden and government spending as a % of GDP are used to identify a liberal vs conservative government. Typically liberal governments will have larger tax burdens and more spending.",
          "Data was compared via scatter plots and density graphs to determine correlations between variables.  Linear Regression is applied to determine the statistically significant factors that predict quality of life (Various models were run with different combinations of variables, interaction variables, and data transformations.  The models chosen displayed the highest adjusted-R squared value).",
          h3("Data Sources"),
          tags$ul(
            tags$li(tags$a(href="https://www.cia.gov/library/publications/the-world-factbook/fields/2128.html", "2016 CIA World Factbook (Government types)")),
            tags$li(tags$a(href="https://en.wikipedia.org/wiki/Government_spending#As_a_percentage_of_GDP", "2014 Index of Economic Freedom (Tax burden and Government Spending)")),
            tags$li(tags$a(href="http://www.numbeo.com/quality-of-life/rankings_by_country.jsp?title=2016", "2016 Numbeo Quality of Life Index (Quality of Life Metrics)"))
          ),
          h3("Results"),
          h4("Quality of Life"),
          "Based on the regression models for predicting quality of life index:",
          tags$ul(
            tags$li("Liberal governments have a higher quality of life because government expenditure has a strong linear relationship to the quality of life index."),
            tags$li("All governments have a base quality of life index score of 79.5837"),
            tags$li("For every increase of 1% of GDP expenditure the quality of life index rises by 2.2677."),
            tags$li("The type of government has virtually no effect on the quality of life. Below are the only two government types that had a statistically significance in predicting the quality of life. (Pr(>|t|) <= .05).")
          ),
          "Example: A Semi-Presidential Federation has a base quality of life index of 79.5837 - 72.46 + 2.2677 * every 1% of GDP expenditure.",
          "In other words Semi-Presidential Federations have to expend 31.95% of GDP just to meet the starting quality of life index of all other governments (besides a Federal Constitutional Monarchy) ",
          br(),
          br(),
          tableOutput("resultsQuality"),
          hr(),
          h4("Government Expenditure"),
          "Based on the regression models for government expenditure:",
          tags$ul(
            tags$li("All governments have a default 32.0737 % of GDP expenditure)."),
            tags$li("The strongest predictor for quality of life is the amount of government expenditure % of GDP."),
            tags$li("The type of government in most cases significantly affects the government expenditure. Below are the statistically significant types (Pr(>|t|) <= .05).")
          ),
          "Example: A communist state will expend 32.0737 - 23.7143 = 8.3594 % of GDP + .81% for every 1% of GDP tax burden.",
          br(),
          br(),
          tableOutput("resultsSpend"),
          h3("Improvements"),
          "Using more detailed data from the most recent Index of Economic Freedom would allow for more precise predictors in terms of how government money is spent.",
          "Additionally developing a better metric for liberal vs conservative governments could provide greater insight.",
          h3("Contact"),
          "Kazanski.Zachary (at) gmail",
          br(),
          br()
        ),
        tabPanel(
          "Economic System",
          sidebarLayout(
            sidebarPanel(
              br(),
              selectInput(
                "economicIndicatorInput", "Economic Indicator",
                choices = c(
                  "Government Expend. % of GDP"="gov_expend",
                  "Tax Burden % of GDP"="tax_burden",
                  "Expenditure / Burden Ratio"="expend_to_burden_ratio"
                ),
                width="100%"
              ),
              h6("Countries"),
              tableOutput('economicCountries'),
              tags$head(tags$style("#economicQualityOfLifePlots{height:100vh !important;}"))
            ),
            mainPanel(
              br(),
              plotOutput("economicQualityOfLifePlots")
            )
          )
        ), 
        tabPanel(
          "Government",
          sidebarLayout(
            sidebarPanel(
              br(),
              selectInput(
                "governmentTypeInput", "Government Type",
                choices = getChoices("government"), width="100%"
              ),
              h6("Countries"),
              tableOutput('governmentCountries'),
              tags$head(tags$style("#economicQualityOfLifePlots{height:100vh !important;}"))
            ),
            mainPanel(
              br(),
              tabsetPanel(
                tabPanel(
                  "Gov Expend.",
                  plotOutput("expendPlot")
                ),
                tabPanel(
                  "Quality of Life",
                  plotOutput("qualityOfLifePlots")
                )
              )
            )
          )
        ),
        tabPanel(
          "Regression Models",
          fluidRow(
            column(
              6,
              h4("Quality of Life Regression"),
              verbatimTextOutput("qualityRegression")
            ),
            column(
              6,
              h4("Government Spending Regression"),
              verbatimTextOutput("taxRegression")
            )
          )
        )
      )
    )
  )
))