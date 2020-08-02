library(leykam)
dir <- system.file("application", package = "leykam")
setwd(dir)
shiny::shinyAppDir(".")
