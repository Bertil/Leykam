observe({
  var_json <- laender_agg_dta %>%
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

  session$sendCustomMessage(type="jsondata",var_json)
},
priority = -1)
