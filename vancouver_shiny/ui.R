library(shiny)
library(leaflet)
library(RColorBrewer)
# require(ggplot2)

# r_colors <- rgb(t(col2rgb(colors()) / 255))
# names(r_colors) <- colors()
# 
# ui <- fluidPage(
#   leafletOutput("mymap"),
#   p(),
#   actionButton("recalc", "New points")
# )

fluidPage(
  titlePanel("Vancouver Postal Data Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("color_by", "Color By:",
                  choices = c("Average Price" = "avg_price",
                              "Number of Listings" = "listing"),
                  selected = "avg_price"
                  )
    ),
    mainPanel(
      leafletOutput("map"),
      textOutput("result")

    )
  )
)

# dataset <- diamonds

# fluidPage(
#
#   titlePanel("Diamonds Explorer"),
#
#   sidebarPanel(
#
#     sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(dataset),
#                 value=min(1000, nrow(dataset)), step=500, round=0),
#
#     selectInput('x', 'X', names(dataset)),
#     selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
#     selectInput('color', 'Color', c('None', names(dataset))),
#
#     checkboxInput('jitter', 'Jitter'),
#     checkboxInput('smooth', 'Smooth'),
#
#     selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
#     selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))
#   ),
#
#   mainPanel(
#     plotOutput('plot')
#   )
# )