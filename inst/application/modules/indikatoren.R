hcBubble1D <- function(parameters,selected_area){
  dta <- parameters$dta %>%
    filter(!kreis %in% c(selected_area,"Deutschland","Europa") ) %>%
    rename_if("is.numeric",
              funs(paste0("x"))) %>%
    mutate(y = 0)

  highchart() %>%
    hc_add_series(data = dta,
                  type = "bubble",
                  marker = list(
                    fillColor = starChartColors$color[starChartColors$key == parameters$title],
                    fillOpacity = 0.2,
                    lineWidth = 0
                  ),
                  minSize = 25,
                  spacingTop = 100,
                  spacingBottom = -100) %>%
    hc_add_series(
      data = tibble(
        x = parameters$dta %>%
          filter(kreis %in% c(selected_area) ) %>%
          rename_if("is.numeric",
                    funs(paste0("value"))) %>%
          pull(value),
        kreis = parameters$dta %>%
          filter(kreis %in% c(selected_area) ) %>%
          pull(kreis),
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
      floor = -0.5,
      ceiling = 10.5,
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
      pointFormat = '<tr><th colspan="2"><h5>{point.kreis}</h5></th></tr>
        <tr><th></th><td>{point.x:.1f}</td></tr>',
      footerFormat = '</table>',
      followPointer = TRUE
    ) %>%
    hc_legend(
      enabled = FALSE
    )

}



indikatorenUI <- function(id,title){
  ns <- NS(id)
  div(
    style = "background-color:#FFF;",
    h3(title),
    uiOutput(ns("charts"))
  )
}

indikatoren <- function(input,output,session,chart_parameters,title,selectedArea){
  ns <- session$ns
  output$charts <- renderUI({
    tagList(
      lapply(1:length(indikatoren_struktur[[title]]), function(idx){
        span(
          style = "position:relative;",
          highchartOutput(
            outputId = ns(paste0("chart",idx)),
            height = "140px"
          ),
          span(
            class = "description",
            textOutput(ns(paste0("beschreibung",idx)))
          )

        )
      })
    )
  })
  lapply(1:length(indikatoren_struktur[[title]]), function(idx){
    output[[paste0("chart",idx)]] <- renderHighchart({
      hcBubble1D(chart_parameters()[[which(names(indikatoren_struktur) == title)]]$indicators[[idx]],
                 selected_area = selectedArea() )
    })
    output[[paste0("beschreibung",idx)]] <- renderText({
      chart_parameters()[[which(names(indikatoren_struktur) == title)]]$indicators[[idx]]$dscrptn
    })
  })


}

