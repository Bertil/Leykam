tab_UI <- function(id, district_choices) {
  ns <- NS(id)
  tagList(
    column(12,
           fluidRow(
             column(
               width = 8,
               div(
                 class = "subheader",
                 "Indexvergleich der Stadt- und Landkreise"
               )
             ),
             column(4,
                    textOutput(ns("value")),
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
                   leafletOutput(ns("theMap"), height = 520)
               )
             ),
             column(
               width = 4,
               tags$div(
                 id = ns("starChart"),
                 style = "background-color:#FFF;",
                 tags$div(
                   class = "hidden",
                   id = ns("tooltip"),
                   tags$p(
                     tags$strong(
                       tags$span(
                         id =ns("indicator_name"),
                         "Name des Indikators"
                       )
                     )
                   ),
                   tags$p(
                     tags$span(
                       id = ns("indicator_value")
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
                 inputId = ns("name_des_kreises"),
                 label = "Bundesland",
                 choices = district_choices,
                 selected = "Wien"
               )
             ),
             column(
               width = 3,
               selectInput(
                 inputId = ns("main_indicator"),
                 label = "Indikator",
                 choices = setNames(paste0("of_",1:12,"_me_sc_cat"),
                                    indicator_description[paste0("of_",1:12,"_me_sc")]),
                 selected = "of_1",
                 width = "100%"
               )
             ),
             column(
               width = 3,
               selectInput(
                 inputId = ns("ratio_indicator"),
                 label = "Überräprensentiert",
                 choices = setNames(c("ratio_default",paste0("below_25_of_",1:12, "_ratio")),
                                    c("kein", indicator_description[paste0("of_",1:12,"_me_sc")])),
                 width = "100%"
               )
             )
           ),
           fluidRow(
             style = "background-color: #11111111;",
             column(
               width = 4,
               tags$hr(style = "border-top: 1px solid #FFF"),
               indikatorenUI(
                 id = ns(names(indicator_description)[1])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[2]) 
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[3])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[4])
               ),
               tags$hr()
             ),
             column(
               width = 4,
               tags$hr(),
               indikatorenUI(
                 id = ns(names(indicator_description)[5])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[6]) 
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[7])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[8])
               ),
               tags$hr()
             ),
             column(
               width = 4,
               tags$hr(),
               indikatorenUI(
                 id = ns(names(indicator_description)[9])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[10]) 
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[11])
               ),
               indikatorenUI(
                 id = ns(names(indicator_description)[12])
               ),
               tags$hr()
             )
             
           )
    )
  )
}
tab_module <- function(input, output, session, agg_dta, map_dta, zoom){
  ns <- session$ns
  observeEvent(input$theMap_shape_click,{
    updateSelectInput(
      session = session,
      inputId = "name_des_kreises",
      selected = input$theMap_shape_click$id
    )
  })
  observe({
    var_json <- agg_dta %>%
      filter(name == input$name_des_kreises) %>%
      dplyr::select(starts_with("of_")) %>%
      gather() %>%
      mutate(value = ifelse(is.nan(value),0,value)) %>% #star chart can't handle Nan therefore are all Nan set to 0
      inner_join(starChartColors) %>%
      mutate(label = unlist(indicator_description[key]),key = as.numeric(factor(key)),value = round(value,1)) %>%
      transpose() %>%
      lapply(function(col){list(key = col[[1]],value = col[[2]],color = col[[3]],label = col[[4]])}) %>%
      unname() %>%
      toJSON()
    
    session$sendCustomMessage(type=ns("jsondata"),var_json)
  },
  priority = -1)
  
  output$theMap <- renderLeaflet({
    # browser()
    leaflet(
      width = 800,
      options = leafletOptions(
        minZoom = zoom,
        maxZoom = zoom
      )) %>%
      addPolygons(data = map_dta %>% 
                    mutate(index = !!sym(input$main_indicator),
                           index_ratio = !!sym(input$ratio_indicator)),
                  color =~colorBin(palette = c("#000000","#FF0000"),bins = 2,domain = c(FALSE,TRUE))(as.numeric(map_dta$name == input$name_des_kreises)),
                  fill = TRUE,
                  weight = ~(1 + as.numeric(map_dta$name == input$name_des_kreises)),
                  layerId = ~name,
                  label = ~name,
                  opacity = ~dynamicOpasity(map_dta$name == input$name_des_kreises),
                  fillOpacity = ~dynamicOpasity(index_ratio > .25),
                  fillColor = ~colorBin(palette = rev(c('#87BE55CC', '#CDE687CC', '#F1ECBDCC', '#FBDB4CCC', '#C85502CC')),bins = 5, domain = 1:5)(index),
                  highlightOptions = highlightOptions(bringToFront = TRUE,
                                                      fillOpacity = 0.8)) %>%
      setMaxBounds(lng1 = 9.3,lng2 =  17.7,lat1 =  45.8, lat2 = 49.5)
  })
  
  lapply(names(indicator_description),
         function(indicator) {
           callModule(indikatoren,
                      id = indicator,
                      title = indicator_description[[indicator]],
                      chart_data = agg_dta,
                      selectedArea = reactive({input$name_des_kreises}))
           
         })
  
  
}