shiny::tabsetPanel(
  shiny::tabPanel(
    "Österreich",
    tab_UI("austria", laender_agg_map_dta$name)
  ),
  shiny::tabPanel(
    "Wien",
    tab_UI("wien", bezirke_agg_map_dta$name)
  )
)
