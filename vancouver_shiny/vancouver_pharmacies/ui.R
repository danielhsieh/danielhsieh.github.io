library(shiny)
library(leaflet)

bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("myMap", width = "100%", height = "100%"),
  fixedPanel(top = 80, left=15,
             #sliderInput("range", "Magnitudes", min(quakes$mag), max(quakes$mag),
             #            value = range(quakes$mag), step = 0.1
             #),
             #selectInput("colors", "Color Scheme",
             #            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
             #),
             checkboxGroupInput("brand", "Banner",
                                c("London Drugs", "Shoppers Drug Mart", "Pharmasave", "Rexall", "PharmaChoice", "Independent"),
                                selected = c("London Drugs", "Shoppers Drug Mart", "Pharmasave", "Rexall", "PharmaChoice", "Independent")
             )
  )
)
# fake-up some data
# n <- 10000
# countrylist <- c("Guyana","Venezuela","Columbia")
# typelist <- c("Aluminium", "Gold","Iron", "Silver", "Zinc")
# types <- sample(typelist,n,replace=T)
# cntrs <- sample(countrylist,n,replace=T)
# lat <- 2.2 + 50*runif(n)
# long <- -46 + 50*runif(n)
# year <- sample(1910:2010,n,replace=T)
# prd <- 100*runif(n)
# 
# 
# myData <- data.frame(Country=cntrs,type=types,year=year,production=prd,Long=long,Lat=lat)

# u <- shinyUI(fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       checkboxGroupInput("brand", "Pharmacy Brand:",
#                          c("London Drugs", "Shoppers Drug Mart", "Pharmasave", "Rexall", "PharmaChoice", "Independent"),
#                          selected = c("London Drugs", "Shoppers Drug Mart", "Pharmasave", "Rexall", "PharmaChoice", "Independent")
#       )
#     ),
#     mainPanel(
#       leafletOutput("myMap", width = "100%", height = "500px")  # Adjust height as needed
#     )
#   )
# ))


  #selected=c("London Drugs", "Shoppers Drug Mart","Pharmasave", "Rexall", "PharmaChoice","Independent")
  #),
  # sliderInput("year","Choose a Year", 
  #             min = 1910,
  #             max = 2010,
  #             value= 2010),
  # checkboxGroupInput("Economy", "Please Select Economy Factor:", 
  #                    c("Income Inequallity", "labourers Real Wage", "GDP", "Inflation")),
  #plotOutput("thisPlot"), 
