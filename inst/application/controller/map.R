#######################################################
#### controller for the Map                        ####
#######################################################

dynamicOpasity <- function(x){ifelse(x == 0,0.1 , .9)}
# generate the map output
output$theMap <- renderLeaflet({
  # browser()
  leaflet(
    width = 800,
    options = leafletOptions(
      minZoom = 7,
      maxZoom = 9
  )) %>%
    addPolygons(data = laender_agg_map_dta %>% 
                  mutate(index = !!sym(input$main_indicator),
                         index_ratio = !!sym(input$ratio_indicator)),
                color =~colorBin(palette = c("#000000","#FF0000"),bins = 2,domain = c(FALSE,TRUE))(as.numeric(laender_agg_map_dta$name == input$name_des_kreises)),
                fill = TRUE,
                weight = ~(1 + as.numeric(laender_agg_map_dta$name == input$name_des_kreises)),
                layerId = ~name,
                label = ~name,
                opacity = ~dynamicOpasity(laender_agg_map_dta$name == input$name_des_kreises),
                fillOpacity = ~dynamicOpasity(index_ratio > .25),
                fillColor = ~colorBin(palette = rev(c('#87BE55CC', '#CDE687CC', '#F1ECBDCC', '#FBDB4CCC', '#C85502CC')),bins = 5, domain = 1:5)(index),
                highlightOptions = highlightOptions(bringToFront = TRUE,
                                                    fillOpacity = 0.8)) %>%
    setMaxBounds(lng1 = 9.3,lng2 =  17.7,lat1 =  45.8, lat2 = 49.5)
})
