# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Global variable definitions
relevant_indicators <- c("lebenserwartung_m", "lebenserwartung_f", "gesundheit_erstes_jahr", "kindergesundheit",
                         "impfungen_polio", "vorsorge_kinder", "psychomotorische_reife", "verletzte_strasse",
                         "alkhol_erkrankungen", "apothekendichte", "hausarztdichte", "personal_in_pflege")
# image_translation <- readxl::read_excel("./data/image_translation.xlsx", col_names = c("file", "name"))

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Define server logic required to draw a plots  ------------------------------------
shinyServer(function(input, output,session) {
  # lapply(
  #   list.files(path = "controller",full.names = TRUE),
  #   function(file){
  #     source(file = file,local = TRUE, encoding = "UTF-8")
  #   }
  # )
 for(file in list.files(path = "controller",full.names = TRUE)){
   source(file = file,local = TRUE, encoding = "UTF-8")
 }
 # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 # ---- Reactive Functions  ----


  # ---- Get the baromter values according to user input  ----
  # return a list with
  # [1] value of the selected district
  # [2] all calculated barometer values
  # [3] which of these district is the selected one
  # calculate_barometer_values <- reactive({
  #   indicator_list <- generateparameters()
  #   dtaList <- lapply(indicator_list,function(objekt){
  #     lapply(objekt$indicators,function(obj2){
  #       obj2$dta
  #     })
  #   }) %>%
  #     unlist(recursive = FALSE) %>%
  #     Reduce(function(x,y){right_join(x,y,by="kreis")},.,tibble(kreis = character(0)))
  # 
  # 
  #   # Get the user input weights
  #   user_weights <- sapply(
  #     lapply(indikatoren_struktur,names) %>%
  #       unlist() %>%
  #       toId(),
  #     function(var){input[[var]]},
  #     USE.NAMES = FALSE
  #   )
  # 
  #   dtaList$index <- dtaList %>%
  #     select_if("is.numeric") %>%
  #     apply(MARGIN = 1,FUN = weighted.mean,user_weights,na.rm = TRUE)
  # 
  #   dtaList
  # 
  # })
  # 
  # calculate_barometer_index <- reactive({
  #   user_weights <- sapply(
  #     lapply(indikatoren_struktur,names) %>%
  #       unlist() %>%
  #       toId(),
  #     function(var){input[[var]]},
  #     USE.NAMES = FALSE
  #   )
  # 
  #   # Get only relevant vars
  #   filtered_data <- shiny_data %>% select(one_of(relevant_indicators))
  # 
  #   # Calculate the barometer value for each district
  #   barometer_values <- apply(filtered_data, 1, healthbarometer_value, user_weights)
  #   selected_disctrict <- shiny_data$name_des_kreises == input$name_des_kreises
  #   value_of_selected_district <- barometer_values[selected_disctrict]
  # 
  #   # print_it <- barometer_values %>% round(2) %>% cbind(shiny_data$name_des_kreises, .) %>% as_tibble
  #   # names(print_it) <- c("name", "value")
  #   # print_it <- print_it %>% arrange(name)
  #   # print_it %>% readr::write_excel_csv("validation.csv")
  # 
  #   result <- list(value_of_selected_district, barometer_values, which(selected_disctrict))
  #   result
  # 
  # })
  # 
  # # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  # # ---- UI ----
  # 
  # # Render title
  # output$title <- renderText({
  #   barometer_values <- calculate_barometer_index()
  #   name <- shiny_data$name_des_kreises[barometer_values[[3]]]
  #   paste("Gesundheitsbarometer für", name)
  # })
  # 
  #  # Render index value
  # output$value <- renderText({
  #   barometer_values <- calculate_barometer_index()
  #   value <- as.numeric(barometer_values[[1]])
  #   paste(" Gesundheitsbarometer Index:", round(value,1))
  # })
  # 
  # # Render rank
  # output$rank <- renderText({
  #   barometer_values <- calculate_barometer_index()
  #   rank <- rank(-barometer_values[[2]])[barometer_values[[3]]]
  #   paste("Rang", rank, "von 44 Land- und Stadtkreisen")
  # })
  # 
  # # Render barplot
  # output$bar_plot <- renderPlot({
  #   barometer_values <- calculate_barometer_index()
  #   bar_plot(barometer_values[[2]], to_highlight = barometer_values[[3]], colors = colorsPalette())
  # })
  # 
  # # Render backgroud
  # output$background_ui <- renderUI({
  #   barometer_values <- calculate_barometer_index()
  #   name <- shiny_data$name_des_kreises[barometer_values[[3]]]
  #   filename <- image_translation$file[image_translation$name==name] # get the correct filename
  # 
  #   #set css element
  #   css_background <- paste0(".background_reactive{
  #                     background-image: url(\'", filename, "\');
  #                     background-size: 100% 100%;
  #                     background-repeat: no-repeat;}")
  #   # add element to tag list
  #   background <- tags$head(
  #     tags$style(HTML(css_background)))
  # 
  #   background
  # })
  observeEvent(input$theMap_shape_click,{
    browser()
    updateSelectInput(
      session = session,
      inputId = "name_des_kreises",
      selected = input$theMap_shape_click$id
    )
  })
})



