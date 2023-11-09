---
output: 
  html_document: 
    theme: yeti
---
#RMarkdown Tutorial

require(rmarkdown)
require(knitr)

#header  
#Say Hello to markdown

#second header 
##Second Header

#italic 
*without realizing it*

#bold 
**easy to use**

#hyperlink 
[Github](https://www.github.com)

#list 
* item 1
* item 2
* item 3

#code chunk
```{r}
dim(iris)
```
#options
#eval=FALSE #puts input but no output
#echo=FALSE #puts output but no input (ex. a plot)

#YAML header controls rendering
---
title: "Untitled"
author: "Garrett"
date: "July 10, 2014"
output: html_document #type of output (html_document for runtime:shiny) when called by render()
---
#runtime for incorporating shiny widgets within an Rmarkdown file  
#runtime: shiny

#render a shiny plot within Rmd, outputArgs must always be a list
#renderPlot({ 
#  plot(yourData) 
#}, outputArgs = list(width = "200px", 
#                     height = "100px")
#)
# more guides here: https://shiny.posit.co/r/articles/build/interactive-docs/
### Brushing over an image (and storing the data)

```{r setup, echo=FALSE}
library(datasets)

generateImage <- function() {
  outfile <- tempfile(fileext = '.png')
  png(outfile)
  par(mar = c(0,0,0,0))
  image(volcano, axes = FALSE)
  contour(volcano, add = TRUE)
  dev.off()
  list(src = outfile)
}
```

```{r image}
renderImage({
  generateImage()
}, deleteFile = TRUE, 
   outputArgs = list(brush = brushOpts(id = "plot_brush"),
                     width = "250",
                     height = "250px")
)
```

##### Here's some of the brushing info sent to the server:
(brush over the image to change the data)

```{r brush info}
renderText({ 
  print(input$plot_brush)
  brush <- input$plot_brush
  paste0("xmin: ", brush$xmin, "; ",
         "xmax: ", brush$xmax, "; ",
         "ymin: ", brush$ymin, "; ",
         "ymax: ", brush$ymax)
})
```

---

### Resizing a plot

```{r plot}
renderPlot({ 
  plot(cars) 
}, outputArgs = list(width = "75%", 
                     height = "250px")
)
```

### Here are two Shiny widgets

```{r echo = FALSE}
selectInput("n_breaks", label = "Number of bins:",
              choices = c(10, 20, 35, 50), selected = 20)

sliderInput("bw_adjust", label = "Bandwidth adjustment:",
              min = 0.2, max = 2, value = 1, step = 0.2)
```

#create the .pdf and .md file
rmarkdown::render()

