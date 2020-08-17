library(shiny)
library(data.table)
library(dplyr)
library(tidyr)
library(rgdal)
library(shinydashboard)
library(leaflet)
library(htmltools)
# library(plotly)
library(highcharter)
# library(DT)
library(shinyjs)
library(sf)
library(rjson)
library(purrr)

indicator_description = list(
  "of_1_me_sc" = "Wertschätzung, Führung, Betriebsklima",
  "of_2_me_sc" = "Gesundheit und Arbeitsfähigkeit",
  "of_3_me_sc" = "Autonomie, Rollenklarheit, Identifikaton",
  "of_4_me_sc" = "Zukünftige Arbeitsfähigkeit",
  "of_5_me_sc" = "Anpassungsfähigkeit Organisation",
  "of_6_me_sc" = "Private Überlastung",
  "of_7_me_sc" = "Arbeitsbelastung",
  "of_8_me_sc" = "Äußere Arbeitsbedingungen",
  "of_9_me_sc" = "Passung Qualifikation",
  "of_10_me_sc" = "Überstunden",
  "of_11_me_sc" = "Arbeitsmittel",
  "of_12_me_sc" = "Arbeitsplatzsicherheit"
)
indikatoren_struktur <- list(
  "Gesundheitliche Lage der Bevölkerung" = list(
    "Lebenserwartung Frauen" = list(
      "Lebenserwartung der weiblichen Bevölkerung (m/w) im Alter von 65 Jahren",
      "Lebenserwartung Frauen"
    ),
    "Lebenserwartung Männer" = list(
      "Lebenserwartung der maennlichen Bevölkerung (m/w) im Alter von 65 Jahren",
      "Lebenserwartung Maenner"
    ),
    "Gesundheit im ersten Lebensjahr" = list(
      "Anteil Geburten unter 2500g",
      "Säuglingssterblichkeit"
    ),
    "Kindergesundheit" = list(
      "KH-Aufenthalt eines Kindes pro 1.000 Einwohner",
      "Uebergewicht bei Kindern (4-5 Jahre)"
    )
  ),
  "Gesundheitsförderung und Prävention" = list(
    "Impfquoten Masern Polio" = list(
      "Impfquoten: Masern",
      "Impfquoten: Polio"
    ),
    "Vorsorgeuntersuchungen bei Kindern" = list(
      "U3 - U6 bei der Einschulungsuntersuchung",
      "U7 bei der Einschulungsuntersuchung",
      "U7a bei der Einschulungsuntersuchung",
      "U8 bei der Einschulungsuntersuchung"
    ),
    "Psychomotorische Reife bei der Einschulung" = list(
      "Einschulungsuntersuchungen: Auffällige Grobmotorik",
      "Einschulungsuntersuchungen: Auffällige Visuom. Stoer.",
      "Einschulungsuntersuchungen: Sprachförderbedarf"
    )
  ),
  "Gesundheitsbezogenes Verhalten" = list(
    "Verletzte im Straßenverkehr" = list(
      "Verletzte Personen (Strassenverkehr) pro 1.000 Einwohner"
    ),
    "Alkoholbedingte Erkrankungen" = list(
      "Anteil der alkoholbedingten Unfaelle",
      "Sterbefälle durch vermeidbare Leberkrankheiten pro 1.000 Einwohner"
    )
  ),
  "Ambulante Versorgung und Pflege" = list(
    "Hausarztdichte" = list(
      "1.000 Einwohner pro Hausarzt",
      "Anteil der PLZ innherlab eines Kreises mit geringer Aerztedichte"
    ),
    "Apothekendichte" = list(
      "Apotheken pro 1.000 Einwohner"
    ),
    "Personal in Pflege" = list(
      "Personal in ambulanter und station. Pflege pro 65+ Jaehriger"
    )
  )
)


bezirke_map_agg_dta <- readRDS("./data/bezirke_map_agg_dta.rds")
laender_agg_map_dta <- readRDS("./data/laender_agg_map_dta.rds")
bezirk_agg_dta <- readRDS("./data/bezirk_agg_dta.rds")
laender_agg_dta <- readRDS("./data/laender_agg_dta.rds")



toId <- function(txt){
  txt %>%
    tolower() %>%
    gsub(" ","",.) %>%
    gsub("ä","ae",.) %>%
    gsub("ö","oe",.) %>%
    gsub("ü","ue",.)

}


lapply(
  list.files(path = "modules/",full.names = TRUE),
  function(file){
    source(file = file, encoding = "UTF-8")
  }
)

starChartColors = tibble(
  color = c(
    "rgba(85, 152, 195,0.87524)",
    "rgba(40, 150, 131,0.38889)",
    "rgba(98, 183, 225,0.55981)",
    "rgba(48, 164, 86, 0.72562)",
    "rgba(219, 76, 96, 0.79116)",
    "rgba(229, 99, 47, 0.85185)",
    "rgba(130, 172, 70, 0.86281)",
    "rgba(124, 59, 115, 0.87771)",
    "rgba(96, 96, 96, 0.87931)",
    "rgba(153, 143, 228, 0.91304)",
    "rgba(213, 155, 46, 0.92253)",
    "rgba(155, 213, 46, 0.92253)"
  ),
  key = names(indicator_description)
)
