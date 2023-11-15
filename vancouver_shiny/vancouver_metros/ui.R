library(shiny)
library(osmdata)
library(tmap)
library(sf)
library(dplyr)


#read from csv
vancouver_stations<-st_read("vancouver_stations.csv")
#convert to sf object
vancouver_stations <- st_as_sf(vancouver_stations, coords = c("lon", "lat"), crs = 4326)
#convert the sfc_point data.class into numeric lon and lat
vancouver_stations$lon<-st_coordinates(vancouver_stations$geometry)[,1]
vancouver_stations$lat<-st_coordinates(vancouver_stations$geometry)[,2]

fluidPage(
  titlePanel("Density around Vancouver Area SkyTrain Stations"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filters"),
             selectInput("station", "Select Skytrain Station:", 
                         choices = sort(vancouver_stations$name)),
             plotOutput(outputId = "buildingLevelsPlot",height = "300px"),
             plotOutput(outputId = "buildingAreaPlot",height = "300px")
           )
    ),
    column(9,
           tmapOutput(outputId = "tmapMap"),
           plotOutput(outputId = "levelsdistancePlot")
           )
  )
)