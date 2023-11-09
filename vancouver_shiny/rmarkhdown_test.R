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
output: html_document #type of output(html_document,pdf_document,word_document) when called by render()
---
#runtime for incorporating shiny widgets within an Rmarkdown file  
#runtime: shiny

#create the .pdf and .md file
rmarkdown::render()

