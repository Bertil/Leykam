hcBubble1D <- function(parameters, selected_area){
  dta <- parameters$dta %>%
    dplyr::select(all_of(parameters$indicator_id), name) %>%
    mutate(y = 0) %>% 
    rename_at(parameters$indicator_id, ~paste("x"))

  highchart() %>%
    hc_add_series(data = dta,
                  type = "bubble",
                  marker = list(
                    fillColor = starChartColors$color[starChartColors$key == parameters$indicator_id],
                    fillOpacity = 0.2,
                    lineWidth = 0
                  ),
                  minSize = 25,
                  spacingTop = 100,
                  spacingBottom = -100) %>%
    hc_add_series(
      data = tibble(
        x = parameters$dta %>%
          filter(name %in% selected_area ) %>%
          rename_at(parameters$indicator_id,
                    funs(paste0("value"))) %>%
          pull(value),
        name = parameters$dta %>%
          filter(name %in% c(selected_area) ) %>%
          pull(name),
        y = 0
      ),
      type = "bubble",
      marker = list(
        fillColor = '#FF0000',
        lineColor = '#FF0000AA'
      ),
      minSize = 25

    ) %>%
    hc_yAxis(min = 0,
             max = 0,
             gridLineWidth = 0,
             minorGridLineWidth = 0,
             tickInterval = 1,
             maxPadding = .01,
             title = list(
               text = ""
             ),
             labels = list(
               enabled = FALSE
             )) %>%
    hc_xAxis(
      title = list(text = NULL),
      allowDecimals = FALSE,
      min = -0.5,
      max = 10.5,
      lineWidth = 0,
      tickWidth = 0,
      labels = list(
        x = 0,
        y = -55
      )
    ) %>%
    hc_title(
      text = parameters$title,
      floating = TRUE,
      align = "left",
      y = 20
    ) %>%
    hc_tooltip(
      useHTML = TRUE,
      headerFormat = '<table>',
      pointFormat = '<tr><th colspan="2"><h5>{point.name}</h5></th></tr>
        <tr><th></th><td>{point.x:.1f}</td></tr>',
      footerFormat = '</table>',
      followPointer = TRUE
    ) %>%
    hc_legend(
      enabled = FALSE
    )

}



indikatorenUI <- function(id){
  ns <- NS(id)
  div(
    class = "chart-container",
    style = "background-color:#FFF;",
    # h3(title),
    highchartOutput(ns("chart"),
                    height = "140px")
  )
}

indikatoren <- function(input,output,session,chart_data,title,selectedArea){
  ns <- session$ns
  variable <- gsub(".*-([^-]*)", "\\1", ns(NULL))
  output$chart <- renderHighchart({
    hcBubble1D(list(dta = chart_data, indicator_id = variable, title = indicator_description[[variable]]),
               selected_area = selectedArea() )
  })
  


}

