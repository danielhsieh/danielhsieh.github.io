library(shiny)
library(leaflet)
# library(ggplot2)

function(input, output) {

  # Update the selected variable based on user input
  colorpal <- reactive({
    if (input$color_by == 'avg_price') {
      pal <- colorNumeric("viridis", vancouver_postal$avg_price)
    } else if (input$color_by == 'listing') {
      pal <- colorNumeric("viridis", vancouver_postal$listing)
    }
  })

  output$result <- renderText({
    paste("You chose", input$color_by)
  })

output$map <- renderLeaflet({
    #pal <- colorNumeric("viridis", vancouver_postal$avg_price)

    pal <- colorpal()

    leaflet(vancouver_postal) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(input$color_by),
        #fillColor = ~pal(avg_price),
        fillOpacity = 0.7,
        color = "black",
        weight = 1,
        label = ~as.character(postal_code),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        ),
        highlightOptions = highlightOptions(
          color = "white",
          weight = 2,
          bringToFront = TRUE
        )
      ) %>%
      addLegend(
        title = "Average Price",
        position = "bottomright",
        pal = pal,
        values = input$color_by,
        #values = vancouver_postal$avg_price,
        opacity = 0.7,
        labFormat = labelFormat(suffix = scales::dollar(1, scale = 0.01)),
        na.label = "N/A"
      )
  })
}