# generateparameters <- reactive({
#   dta <- indikatorenDta()
#   lapply(names(indikatoren_struktur), function(indikatoren_gruppe){
#     indikatorenList <- indikatoren_struktur[[indikatoren_gruppe]]
#     list(
#       id <- indikatoren_gruppe %>%
#         toId(),
#       indicators =  lapply(names(indikatorenList), function(main_indicator){
#         assign(main_indicator,list(
#           dta = dta %>%
#             select(kreis,unlist(indikatorenList[[main_indicator]])) %>%
#             mutate(value = rowMeans(.[,-1],na.rm = TRUE)) %>%
#             select(kreis,value) %>%
#             rename_at("value",funs(paste0(main_indicator))),
#           dscrptn = indicator_description[[main_indicator]],
#           title = main_indicator
#         ))
#       })
#     )
# 
#   })
# })
# 
# 
# indikatorenDta <- reactive({
#   dta <- readxl::read_xls("data/Indikatoren.xls")
#   dta %<>%
#     select(d_wert,kreis,d_indikator_varname) %>%
#     spread(d_indikator_varname,d_wert) %>%
#     rename(Säuglingssterblichkeit = Saeuglingssterblichkeit,
#            `Sterbefälle durch vermeidbare Leberkrankheiten pro 1.000 Einwohner` =
#              `Sterbefaelle durch vermeidbare Leberkrankheiten pro 1.000 Einwohner`)
# 
# })
# 
lapply(names(indikatoren_struktur),
       function(indicator_group) {
         callModule(indikatoren,
                    id = indicator_group %>% toId(),
                    title = indicator_group,
                    chart_parameters = generateparameters,
                    selectedArea = reactive({input$name_des_kreises}))

       })
