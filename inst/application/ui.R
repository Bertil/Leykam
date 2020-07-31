# Define UI for application ------------------------------------
full_page <- fixedPage(
    title = "Gesundheitsbarometer",
    theme = shinythemes::shinytheme("yeti"),

    tags$head(
      tags$link(
        rel = "stylesheet", href = "css/ui.css"
      ),
      tags$script(src="https://d3js.org/d3.v3.min.js"),
      tags$script(src="js/shiny_to_d3.js")
    ),

    # uiOutput("background_ui"),

    #titlePanel(title=div("Gesundheitsbarometer"), windowTitle = "Gesundheitsbarometer"),

    fluidRow(
      fluidRow(
        column(8, textOutput("title"))
      ),
      tags$hr(),
      source("uiComponents/main.R", local=T)$value
      # source("uiComponents/sidebar.R", local=T)$value
    )
  )

full_page



