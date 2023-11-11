library(shiny)
library(tmap)
library(osmdata)
library(sf)

shinyServer(function(input, output) {
  
  source("vancouver_metros.R")
  
  data <- reactive({
    which(vancouver_stations$name == input$station)
  })
  
  dataTmap <- reactive({
    # Call your get_osm_data function with the selected station data
    buildings <- opq_around(vancouver_stations$lon[data()], 
                            vancouver_stations$lat[data()], 
                            800, key = "building") %>%
                osmdata_sf()
    # data clean-up
    buildings <- buildings$osm_polygons
    buildings$`building:levels` <- as.numeric(buildings$`building:levels`)
    sf::st_as_sf(buildings)
  })
  
  output$tmapMap <- renderTmap({
    tm_shape(dataTmap()) +
    tm_polygons("building:levels", palette = "YlGnBu",
                  popup.vars = c('Name: ' = 'name', 
                                 'Building: ' = 'building',
                                 'Levels' = 'building:levels')) +
    tm_shape(vancouver_stations) +
    tm_dots(col = 'red', size = 1, alpha = 0.5) +
    tm_view(set.view = c(vancouver_stations$lon[data()], 
                         vancouver_stations$lat[data()], 16))
  })
})
