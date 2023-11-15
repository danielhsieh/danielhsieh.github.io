library(shiny)
library(tmap)
library(osmdata)
library(sf)
library(RColorBrewer)
library(dplyr)

#read from csv
vancouver_stations<-st_read("vancouver_stations.csv")
#convert to sf object
vancouver_stations <- st_as_sf(vancouver_stations, coords = c("lon", "lat"), crs = 4326)
#convert the sfc_point data.class into numeric lon and lat
vancouver_stations$lon<-st_coordinates(vancouver_stations$geometry)[,1]
vancouver_stations$lat<-st_coordinates(vancouver_stations$geometry)[,2]

shinyServer(function(input, output) {
  
  # source("vancouver_metros.R")
  
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
    buildings$area <- st_area(buildings)
    buildings$lon <- st_coordinates(st_centroid(buildings$geometry))[,1]
    buildings$lat <- st_coordinates(st_centroid(buildings$geometry))[,2]
    #calc distance to center
    buildings$distance_to_center <- st_distance(
      st_as_sf(data.frame(st_coordinates(st_centroid(buildings$geometry))),coords = c("X","Y"),crs=4326),
      st_sfc(st_point(cbind(vancouver_stations$lon[43],vancouver_stations$lat[43])),
             crs=4326)
    )
    #calc floor area
    buildings$floor_area <- ifelse(is.na(buildings$`building:levels`), 
                                   NA, 
                                   buildings$area * buildings$`building:levels`)
    buildings<-st_as_sf(buildings)
    
  })
  
  #prescribed distances - buffer zones
  buffer200 <- reactive({
    buffer200 <- st_buffer(vancouver_stations$geometry[data()], 
                           dist = units::set_units(200, meters))
  })
  buffer400 <- reactive({
    buffer400 <- st_buffer(vancouver_stations$geometry[data()], 
                           dist = units::set_units(400, meters))
  })
  buffer800 <- reactive({
    buffer800 <- st_buffer(vancouver_stations$geometry[data()], 
                           dist = units::set_units(800, meters))
  })

  
  # Create a bar plot of building areas
  output$buildingAreaPlot <- renderPlot({
    # Assuming 'area' is the column in your 'buildings' data frame representing the building area
    hist(dataTmap()$area,
         breaks = 10,
         xlab = "Building Area",
         main = "Distribution of Building Area",
         col="#2C7FB8")
  })
  
  output$buildingLevelsPlot <- renderPlot({
    # Assuming 'area' is the column in your 'buildings' data frame representing the building area
    h<-hist(as.numeric(dataTmap()$`building:levels`),breaks=20,plot=FALSE)
    h_cuts<-cut(h$breaks,c(-Inf, 4, 6, 8, 12, 20, Inf))
    plot(h,col=brewer.pal(n=6,name = "YlGnBu")[h_cuts],
         main = "Distribution of Building Levels",
         xlab = "Building Levels",)
  })
  output$levelsdistancePlot <- renderPlot({
  plot(dataTmap()$distance_to_center, dataTmap()$`building:levels`, 
       xlab = "Distance to Center", ylab = "Building Levels",
       main = "Building Levels vs Distance to Center",
       col = rgb(1, 0, 0, 0.2),pch=16,
       frame.plot=FALSE)
  # Add rug plots
  rug(dataTmap()$distance_to_center, col = "blue", ticksize = 0.02)
  rug(dataTmap()$`building:levels`, side = 2, col = "red", ticksize = 0.02)
  })
  
  output$tmapMap <- renderTmap({
    tm_view(set.view = c(vancouver_stations$lon[data()], 
                         vancouver_stations$lat[data()], 16)) + 
    tm_shape(buffer200()) +
      tm_borders(alpha = 0.8,col='red',lty = 4) + 
    tm_shape(buffer400()) +
      tm_borders(alpha = 0.8,col='red',lty = 4) + 
    tm_shape(buffer800()) +
      tm_borders(alpha = 0.8,col='red',lty = 4) +
    tm_shape(dataTmap()) +
      tm_polygons("building:levels",palette = "YlGnBu",
                popup.vars = c('Name: ' = 'name', 
                               'Building: ' = 'building',
                               'Area' = 'area',
                               'Floor Area' = 'floor_area',
                               'Distance to Station' = 'distance_to_center'),
                breaks=c(0,4,6,8,12,20,Inf)) + 
    tm_shape(vancouver_stations) +
      tm_dots(col = 'red', size = 0.5, alpha = 0.5)
  })
})
