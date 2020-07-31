# Main  ------------------------------------
main_column <-
  column(12,
       fluidRow(
         column(
           width = 8,
           div(
             id = "rank",
             "Ranking in Baden-Württemberg"
           ),
           div(
             class = "subheader",
             "Indexvergleich der Stadt- und Landkreise"
           )
         ),
         column(4,
                textOutput("value"),
                div(
                  class = "subheader",
                  "Kreisdiagramm der Indikatoren"
                )
            )
         ),
       fluidRow(
         column(
           width = 8,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("theMap", height = 520)
           )
         ),
         column(
           width = 4,
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
         column(
           width = 2,
           selectInput(
             inputId = "name_des_kreises",
             label = "Bundesland",
             choices = länder_agg_map_dta$name,
             selected = "Wien"
           )
         )
       ),
       fluidRow(
         style = "background-color: #11111111;",
         column(
           width = 4,
           tags$hr(style = "border-top: 1px solid #FFF"),
           indikatorenUI(
             id = names(indicator_description)[1]
           ),
           indikatorenUI(
             id = names(indicator_description)[2] 
           ),
           indikatorenUI(
             id = names(indicator_description)[3]
           ),
           indikatorenUI(
             id = names(indicator_description)[4]
           ),
           tags$hr()
         ),
         column(
           width = 4,
           tags$hr(),
           indikatorenUI(
             id = names(indicator_description)[5]
           ),
           indikatorenUI(
             id = names(indicator_description)[6] 
           ),
           indikatorenUI(
             id = names(indicator_description)[7]
           ),
           indikatorenUI(
             id = names(indicator_description)[8]
           ),
           tags$hr()
         ),
         column(
           width = 4,
           tags$hr(),
           indikatorenUI(
             id = names(indicator_description)[9]
           ),
           indikatorenUI(
             id = names(indicator_description)[10] 
           ),
           indikatorenUI(
             id = names(indicator_description)[11]
           ),
           indikatorenUI(
             id = names(indicator_description)[12]
           ),
           tags$hr()
         )

       )
  )

main_column

