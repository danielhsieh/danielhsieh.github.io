library(shiny)
library(osmdata)
library(tmap)
library(sf)

fluidPage(
  titlePanel("Density around Vancouver Area SkyTrain Stations"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filters"),
             selectInput("station", "Select Skytrain Station:", 
                         choices = vancouver_stations$name)
           )
    ),
    column(9,
           tmapOutput(outputId = "tmapMap")
           )
  )
)