require(osmdata)
require(tmap)
require(leaflet)

#retrieve from osm
vancouver_highways <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'highway', value = 'major') %>%
  osmdata_sf()

vancouver_pharmacies <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'amenity', value = 'pharmacy') %>%
  osmdata_sf()

vancouver_buses <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'route', value = 'bus') %>%
  osmdata_sf()

vancouver_rail <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'railway', value = 'subway') %>%
  osmdata_sf()

vancouver_stations <- opq(bbox = 'Vancouver, Canada') %>%
  add_osm_feature(key = 'railway', value = 'station') %>%
  osmdata_sf()

#map using tmap
tmap_mode("view")
tm_shape(vancouver_pharmacies$osm_points) +
  tm_bubbles(size = 0.3,col = "blue",alpha = 0.3) +
tm_shape(vancouver_stations$osm_points) +
  tm_bubbles(size = 0.2,col = "orange",alpha = 0.3) + 
tm_shape(vancouver_buses$osm_lines) + 
  tm_lines(col='red',lwd=0.5,alpha=0.5) +
tm_shape(vancouver_rail$osm_lines) + 
  tm_lines(col='orange',lwd=1,alpha=1)