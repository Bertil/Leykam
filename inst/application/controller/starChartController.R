dta <- rjson::fromJSON('[
{ "key": 0, "value": 5 },
{ "key": 1, "value": 10 },
{ "key": 2, "value": 6 },
{ "key": 3, "value": 9 },
{ "key": 4, "value": 7 },
{ "key": 5, "value": 5 },
{ "key": 6, "value": 7 },
{ "key": 7, "value": 8 },
{ "key": 8, "value": 5 },
{ "key": 9, "value": 8 },
{ "key": 10, "value": 6 }]')


observe({
  var_json <- laender_agg_dta %>%
    filter(name == input$name_des_kreises) %>%
    dplyr::select(starts_with("of_")) %>%
    gather() %>%
    mutate(value = ifelse(is.nan(value),0,value)) %>% #star chart can't handle Nan therefore are all Nan set to 0
    inner_join(starChartColors) %>%
    mutate(label = indicator_description[key],key = as.numeric(factor(key)),value = round(value,1)) %>%
    transpose() %>%
    lapply(function(col){list(key = col[[1]],value = col[[2]],color = col[[3]],label = col[[4]])}) %>%
    unname() %>%
    toJSON()

  session$sendCustomMessage(type="jsondata",var_json)
},
priority = -1)
