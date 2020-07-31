library(healthbarometer)
dir <- system.file("application", package = "healthbarometer")
setwd(dir)
shiny::shinyAppDir(".")
