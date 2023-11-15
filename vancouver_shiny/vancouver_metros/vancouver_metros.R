require(osmdata)
require(tmap)
require(leaflet)
require(sf)
require(plotly)
require(dplyr)

bbox_vancouver <- c(left = -123.2, bottom = 49, right = -122.75, top = 49.4)

#find stations in Vancouver
vancouver_stations <- opq(bbox = bbox_vancouver) %>%
  add_osm_feature(key = 'railway', value = 'station') %>%
  osmdata_sf()
#convert to df
vancouver_stations<-vancouver_stations$osm_points
#convert the sfc_point data.class into numeric values in a matrix
vancouver_stations$lon<-st_coordinates(vancouver_stations$geometry)[,1]
vancouver_stations$lat<-st_coordinates(vancouver_stations$geometry)[,2]

st_write(vancouver_stations, "~/danielhsieh.github.io/vancouver_shiny/vancouver_metros/vancouver_stations.csv")
vancouver_stations<-st_read("vancouver_stations.csv")
vancouver_stations <- st_as_sf(vancouver_stations, coords = c("lon", "lat"), crs = 4326)
class(vancouver_stations)

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
  buildings <- buildings$osm_polygons
  buildings$`building:levels` <- as.numeric(buildings$`building:levels`)
  buildings$area <- st_area(buildings)
  buildings$lon <- st_coordinates(st_centroid(buildings$geometry))[,1]
  buildings$lat <- st_coordinates(st_centroid(buildings$geometry))[,2]
  # buildings<-sf::st_as_sf(buildings)
  buildings$distance_to_center <- st_distance(
    st_as_sf(data.frame(st_coordinates(st_centroid(buildings$geometry))),coords = c("X","Y"),crs=4326),
    st_sfc(st_point(cbind(vancouver_stations$lon[43],vancouver_stations$lat[43])),
           crs=4326)
  )
}

  #view the map
  tmap_mode("view")
  tm_view(set.view = c(vancouver_stations$lon[43], 
                       vancouver_stations$lat[43], 16)) + 
    # tm_shape(buffer200()) +
    # tm_polygons(alpha = 0.05,col='red') + 
    # tm_shape(buffer400()) +
    # tm_polygons(alpha = 0.05,col='red') + 
    # tm_shape(buffer800()) +
    # tm_polygons(alpha = 0.05,col='red') + 
    tm_shape(buildings) +
    tm_polygons("building:levels",palette = "YlGnBu",
                popup.vars = c('Name: ' = 'name', 
                               'Building: ' = 'building',
                               'Levels' = 'building:levels'),
                breaks=c(0,4,6,8,12,20,70)) + 
    tm_shape(vancouver_stations) +
    tm_dots(col = 'red', size = 0.5, alpha = 0.5)
  


buildings$area<-as.numeric(buildings$area)
# buildings <- buildings %>%
#   mutate(building_level_category = case_when(
#     `building:levels` >= 0 & `building:levels` <= 2 ~ "0-2",
#     `building:levels` >= 3 & `building:levels` <= 8 ~ "3-8",
#     `building:levels` >= 9 & `building:levels` <= 12 ~ "9-12",
#     `building:levels` >= 13 & `building:levels` <= 20 ~ "13-20",
#     `building:levels` >= 21 ~ "21 and up"
#   ))

# Assuming lon and lat are the coordinates of the center point
center_lon <-  Vancouver_center[1]
center_lat <- Vancouver_center[2]

# Calculate distance to the center point
buildings_dots<- data.frame(st_coordinates(st_centroid(buildings$geometry)))
buildings_dots<-st_as_sf(buildings_dots,coords = c("X","Y"),crs=4326)

buildings$distance_to_center <- st_distance(
  st_as_sf(data.frame(st_coordinates(st_centroid(buildings$geometry))),coords = c("X","Y"),crs=4326),
  st_sfc(st_point(cbind(vancouver_stations$lon[43],vancouver_stations$lat[43])),
             crs=4326)
)

plot(buildings$distance_to_center, buildings$`building:levels`, 
     xlab = "Distance to Center", ylab = "Building Levels",
     main = "Building Levels vs Distance to Center",
     col = rgb(1, 0, 0, 0.2),pch=16,
     frame.plot=FALSE)
# Add rug plots
rug(buildings$distance_to_center, col = "blue", ticksize = 0.02)
rug(buildings$`building:levels`, side = 2, col = "red", ticksize = 0.02)
# Create 2D density estimate
dens <- MASS::kde2d(buildings$distance_to_center, buildings$`building:levels`, n = 50)
# Contour levels to highlight
levels <- quantile(dens$z, c(0.25, 0.5, 0.75))
# Draw contour lines
contour(dens$x, dens$y, dens$z, levels = levels, add = TRUE, col = "red", lwd = 2)

# Assuming 'dataTmap()' is your data frame
levels_data <- as.numeric(buildings$`building:levels`)
breaks <- c(0, 4, 6, 8, 12, 20, 70)
colors <- brewer.pal(n = length(breaks) - 1, name = "YlGnBu")

# Create histogram manually using barplot
hist_counts <- hist(levels_data, breaks = breaks, plot = FALSE)$counts
barplot(hist_counts, col = colors, names.arg = breaks[-length(breaks)], 
        xlab = "Levels", main = "Distribution of Building Levels")

h<-hist(as.numeric(buildings$`building:levels`),breaks=20,plot=FALSE)
h_cuts<-cut(h$breaks,c(-Inf, 4, 6, 8, 12, 20, Inf))
par(bg = "transparent")
plot(h,col=c("#FFFFCC","#C7E9B4","#7FCDBB","#41B6C4","#2C7FB8","#253494")[h_cuts],
     main = "Distribution of Building Levels",
     xlab = "Building Levels",)


