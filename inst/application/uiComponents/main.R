# Main  ------------------------------------
main_column <-
  column(12,
       fluidRow(
         column(
           width = 6,
           div(
             id = "rank",
             "Ranking in Baden-Württemberg"
           ),
           div(
             class = "subheader",
             "Indexvergleich der Stadt- und Landkreise"
           )
         ),
         column(6,
                textOutput("value"),
                div(
                  class = "subheader",
                  "Kreisdiagramm der Indikatoren"
                )
            )
         ),
       fluidRow(
         column(
           width = 7,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("theMap", height = 400)
           )
         ),
         column(
           width = 5,
           tags$div(
             id = "starChart",
             style = "background-color:#FFF;",
             tags$div(
               class = "hidden",
               id = "tooltip",
               tags$p(
                 tags$strong(
                   tags$span(
                     id ="indicator_name",
                     "Name des Indikators"
                   )
                 )
               ),
               tags$p(
                 tags$span(
                   id = "indicator_value"
                 )
               )
             )
           ),
           tags$link(
             rel = "stylesheet",href = "css/starChart.css"
           )
         )
       ),
       fluidRow(
         style = "margin-left: -30px;",
         column(
           width = 6,
           indikatorenUI(
             id = names(indikatoren_struktur)[1] %>% toId(),
             title = names(indikatoren_struktur)[1]
           ),
           tags$hr(),
           indikatorenUI(
             id = names(indikatoren_struktur)[3] %>% toId(),
             title = names(indikatoren_struktur)[3]
           )
         ),
         column(
           width = 6,
           indikatorenUI(
             id = names(indikatoren_struktur)[2] %>% toId(),
             title = names(indikatoren_struktur)[2]
           ),
           tags$hr(),
           indikatorenUI(
             id = names(indikatoren_struktur)[4] %>% toId(),
             title = names(indikatoren_struktur)[4]
           )
         )

       )
  )

main_column

