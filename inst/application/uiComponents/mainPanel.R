###################################################
#### UI File for Tab Anzahl Fahrten            ####
###################################################

tabPanel(
  title = "Hauptansicht",
  fluidRow(
    column(width = 4,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("theMap", height = 600)
           )
    ),
    column(
      width = 6,
      offset = 2,
      tags$div(
        id = "starChart",
        style = "background-color:#FFF04;"
      )
    )
  ),
  fluidRow(
    lapply(names(indikatoren_struktur), 
           function(indikator_name) {
             column(
               width = 6,
               indikatorenUI(
                 id = indikator_name %>% toId(),
                 title = indikator_name
               )
             )
           }
           
           )
  ),
  fluidRow(
    style = "height:100px"
  )
)