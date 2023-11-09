#R-shinyapps.io
require(shiny)
require(rsconnect)
require(rmarkdown)
require(DT)
require(googlesheets4)

#get working directory
getwd()
#set wd to the github vancouver_shiny directory
setwd("~/danielhsieh.github.io/vancouver_shiny")

#testing app
runApp()

#deploying app
deployApp()

#check logs
rsconnect::showLogs()  #streaming=TRUE; to see live logs

#reconfig app
rsconnect::configureApp("APPNAME", size="small")

#undeploy; will remain archived in your shinyapps.io account
terminateApp("<your app's name>")