#R-shinyapps.io
library(shiny)
library(rsconnect)

#get working directory
getwd()
#set wd to the github vancouver_shiny directory
setwd("~/danielhsieh.github.io/vancouver_shiny")

#testing app
runApp()

#deploying app
deployApp()