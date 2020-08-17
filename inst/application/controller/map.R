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
    # setView(lng=9.989436, lat=53.54848, zoom=11) %>%
    # addTiles(urlTemplate="https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}", group = "Helle Karte") %>%
    # addTiles(urlTemplate="https://{s}.tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png?apikey=86897a259984436081f859aab1032e7d", group = "Dunkle Karte") %>%
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
    # Systel Tiles
    #addTiles(urlTemplate="http://osm.sv.db.de/dbstyle/{z}/{x}/{y}.png?key=4815162342") %>%
    # Transport Tiles
    #addTiles(urlTemplate="https://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=<insert-your-apikey-here>") %>%
    # Cart dark
    #addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
    #         attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
    # addMarkers(data=station, lng=~LONGITUDE , lat=~LATITUDE, label=~NAME, group="StadtRAD",
    #            popup = ~paste(sep = "<br/>", paste0("&#216; Abstellzeit: ",AVG," Minuten"),
    #                           paste0("Distanz Bahnhof: ",DIST_BAHNHOF," m"),
    #                           paste0("Distanz S-Bahn: ",DIST_SBAHN," m"),
    #                           paste0("Distanz U-Bahn: ",DIST_UBAHN," m")
    #            )
    # ) %>%
    # addAwesomeMarkers(data=station[station$SWITCHH == TRUE,], lng=~LONGITUDE, icon = map_marker.beige, lat=~LATITUDE, label=~NAME, group="switchh") %>%
    # addAwesomeMarkers(data=bahnhof, lng=~x , lat=~y, label=~Name, icon = map_marker.red, group="Bahnhöfe") %>%
    # addAwesomeMarkers(data=hvv_sbahn, lng=~x , lat=~y, label=~Name, icon = map_marker.green, group="S-Bahn") %>%
    # addAwesomeMarkers(data=hvv_ubahn, lng=~x , lat=~y, label=~Name, icon = map_marker.blue, group="U-Bahn") %>%
    # # Add the control widget
    # addLayersControl(baseGroups = c("Helle Karte","Dunkle Karte"),
    #                  overlayGroups = c("StadtRAD", "switchh", "Bahnhöfe", "S-Bahn", "U-Bahn"),
    #                  options = layersControlOptions(collapsed = FALSE)) %>%
    # hideGroup(c("StadtRAD", "switchh", "Bahnhöfe", "S-Bahn", "U-Bahn"))
})
