
lapply(names(indicator_description),
       function(indicator) {
         callModule(indikatoren,
                    id = indicator,
                    title = indicator_description[[indicator]],
                    chart_data = laender_agg_dta,
                    selectedArea = reactive({input$name_des_kreises}))

       })
