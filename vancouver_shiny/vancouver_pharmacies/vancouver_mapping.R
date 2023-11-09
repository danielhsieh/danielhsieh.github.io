require(osmdata)
require(tmap)
require(leaflet)
require(sf)

#retrieve from osm
# vancouver_highways <- opq(bbox = 'Vancouver, Canada') %>%
#   add_osm_feature(key = 'highway', value = 'major') %>%
#   osmdata_sf()
vancouver_pharmacies <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'amenity', value = 'pharmacy') %>%
  osmdata_sf()
vancouver_pharmacies<-vancouver_pharmacies$osm_points
vancouver_pharmacies<-subset(vancouver_pharmacies, amenity=='pharmacy')
vancouver_pharmacies$brand <- ifelse(
  is.na(vancouver_pharmacies$brand), 
  'Independent', 
  vancouver_pharmacies$brand)
unique(vancouver_pharmacies$brand)
#convert the sfc_point data.class into numeric values in a matrix
vancouver_pharmacies_coords<-st_coordinates(vancouver_pharmacies$geometry)
#append the matrix columns as new variables in the data.frame
vancouver_pharmacies$lon <- vancouver_pharmacies_coords[,1]
vancouver_pharmacies$lat <- vancouver_pharmacies_coords[,2]

#my_data_frame <- read.csv("data.csv")


# vancouver_buses <- opq(bbox = 'Vancouver, Canada') %>%
#   add_osm_feature(key = 'route', value = 'bus') %>%
#   osmdata_sf()
# 
# vancouver_rail <- opq(bbox = 'Vancouver, Canada') %>%
#   add_osm_feature(key = 'railway', value = 'subway') %>%
#   osmdata_sf()
# 
# vancouver_stations <- opq(bbox = 'Vancouver, Canada') %>%
#   add_osm_feature(key = 'railway', value = 'station') %>%
#   osmdata_sf()
# 
# vancouver_postal <- opq(bbox = 'Vancouver, Canada') %>%
#   add_osm_feature(key = 'boundary', value = 'postal_code') %>%
#   osmdata_sf()
# 
# #merge pricing data into the sf object
# vancouver_postal$osm_polygons <-merge(vancouver_postal$osm_polygons,
#                                       canada_homeprices_postal,
#                                       by="postal_code",
#                                       all.x=TRUE)
# 
# vancouver_postal<-vancouver_postal$osm_polygons
# vancouver_postal$avg_price <- gsub(",", "", vancouver_postal$avg_price)
# 
# vancouver_postal$avg_price<-as.numeric(vancouver_postal$avg_price)
# vancouver_postal$listings<-as.numeric(vancouver_postal$listings)
# vancouver_postal <- subset(vancouver_postal, avg_price != 'N/A')
# 
# View(vancouver_postal)
# 
# pal <- tm_borders(vancouver_postal, 
#                   col = "avg_price")
# 
# #map using tmap
  # tmap_mode("view")
  # tm_shape(vancouver_postal) + 
  #   tm_borders(col="black") + 
  #   tm_fill(col="avg_price") + 
  # tm_shape(vancouver_pharmacies$osm_points) +
  #   tm_bubbles(size = 0.2,col = "blue",alpha = 0.3) +
  # tm_shape(vancouver_stations$osm_points) +
  #   tm_bubbles(size = 0.1,col = "orange",alpha = 0.8) + 
  # tm_shape(vancouver_buses$osm_lines) + 
  #   tm_lines(col='red',lwd=0.5,alpha=0.5) +
  # tm_shape(vancouver_rail$osm_lines) + 
  #   tm_lines(col='orange',lwd=1,alpha=1)