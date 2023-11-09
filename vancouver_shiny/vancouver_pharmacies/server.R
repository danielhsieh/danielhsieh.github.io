library(shiny)
library(leaflet)
library(osmdata)
library(sf)

shinyServer(function(input,output){
  
  source("vancouver_mapping.R")
  
  output$myMap <- renderLeaflet({
    temp <- which(vancouver_pharmacies$brand %in% input$brand)
    #print(nrow(myData))
    vancouver_pharmacies <- vancouver_pharmacies[temp,]
    #print(nrow(myData))
    
    pal <- colorFactor("viridis", vancouver_pharmacies$brand)
    
    popup <- paste0("<strong>Brand: </strong>", vancouver_pharmacies$brand, "<br>","<br>",
                            "<strong>", vancouver_pharmacies$name,"</strong>","<br>",
                            vancouver_pharmacies$`addr:housenumber`, " ",vancouver_pharmacies$`addr:street`,"<br>",
                            vancouver_pharmacies$`addr:city`
                            )
    
    leaflet(data = vancouver_pharmacies) %>% 
      #setView(-46.227638, 2.213749, zoom = 2) %>% 
      addProviderTiles(providers$Stadia.StamenToner) %>%
      addTiles() %>% 
      addCircleMarkers( lng = ~lon, lat = ~lat, 
                        fillColor = ~pal(vancouver_pharmacies$brand),
                        radius = 6, # pixels 
                        fillOpacity = 0.8, 
                        color = "black", 
                        weight = 1, 
                        popup = popup)
  })
})

# function(input,output){
#   
#   output$myMap <- renderLeaflet({
#     temp <- which(myData$type %in% input$type &
#                     myData$year == trunc(input$year))
#     #print(nrow(myData))
#     myData <- myData[temp,]
#     #print(nrow(myData))
#     
#     pal <- colorQuantile("YlGn", myData$production, n = 9)
#     country_popup <- paste0("<strong>Estado: </strong>", myData$Country)
#     
#     leaflet(data = myData) %>% 
#       setView(-46.227638, 2.213749, zoom = 2) %>% 
#       addTiles() %>% 
#       addCircleMarkers( lng = ~Long, lat = ~Lat, 
#                         fillColor = ~pal(myData$production), 
#                         radius = 6, # pixels 
#                         fillOpacity = 0.8, 
#                         color = "black", 
#                         weight = 1, 
#                         popup = country_popup)
#   })
# }