require(osmdata)
require(tmap)
require(leaflet)
require(sf)

bbox_vancouver <- c(left = -123.2, bottom = 49, right = -122.75, top = 49.4)

#find stations in Vancouver
vancouver_stations <- opq(bbox = bbox_vancouver) %>%
  add_osm_feature(key = 'railway', value = 'station') %>%
  osmdata_sf()
#convert to df
vancouver_stations<-vancouver_stations$osm_points
#convert the sfc_point data.class into numeric values in a matrix
van_stations_coords<-st_coordinates(vancouver_stations$geometry)
#append the matrix columns as new variables in the data.frame
vancouver_stations$lon <- van_stations_coords[,1]
vancouver_stations$lat <- van_stations_coords[,2]

###create a function that iterates across all the layers
get_osm_data <- function(df, i) { 
  # buildings
  osm_data <- opq_around(df$lon[i], df$lat[i], 800, key = "building") %>%
    osmdata_sf()
  
  # data clean-up
  buildings <- osm_data$osm_polygons
  buildings$`building:levels` <- as.numeric(buildings$`building:levels`)
  
  return(buildings)
}

#tmap
# tmap_mode("view")
# tm_shape(vancouver_buildings) +
#   tm_polygons("building:levels",palette="YlGnBu",
#               popup.vars = c('Name: ' = 'name', 
#                              'Building: ' = 'building',
#                              'Levels' = 'building:levels' 
#                              )
#               ) +
#   tm_shape(vancouver_stations) + 
#   tm_dots(col='red',size=1,alpha=0.5) + 
#   tm_view(set.view = c(vancouver_stations$lon[2],vancouver_stations$lat[2],16))

  
#map around a station
###create a function that iterates across all the layers
map_osm_data <- function(df,i) { 
  #buildings
  buildings <- opq_around (df$lon[i], df$lat[i], 800, key = "building") %>%
    osmdata_sf ()
  #data clean-up
  buildings<-buildings$osm_polygons
  buildings$`building:levels`<-as.numeric(buildings$`building:levels`)
  
  #view the map
  tmap_mode("view")
  tm_shape(buildings) +
    tm_polygons("building:levels",palette="YlGnBu",
                popup.vars = c('Name: ' = 'name', 
                               'Building: ' = 'building',
                               'Levels' = 'building:levels')
                ) +
    tm_shape(df) + 
    tm_dots(col='red',size=1,alpha=0.5) + 
    tm_view(set.view = c(df$lon[i],df$lat[i],16))
}

map_osm_data(vancouver_stations,1)
