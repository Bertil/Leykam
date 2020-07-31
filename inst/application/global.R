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

indicator_description = list(
  "Lebenserwartung Frauen" =  "Lebenserwartung Frauen (Geburt / ab 65 Jahre)",
  "Lebenserwartung Männer" = "Lebenserwartung Männer (Geburt / ab 65 Jahre)",
  "Gesundheit im ersten Lebensjahr" = "Mittelwert der Einzelidikatoren aus Geburtsgewicht < 2500 g und Säuglingssterblichkeit",
  "Kindergesundheit" = "Mittelwert der Einzelindikatoren aus Krankenhausaufenthalten von Kindern und Anteil der übergewichtigen Kinder bei der Einschulungsuntersuchung",
  "Impfquoten Masern Polio" = "Einzelindikator: durschnittliche Impfquoten für polio und Masern",
  "Vorsorgeuntersuchungen bei Kindern" = "Einzelindikator: Mittelwert der Teilnahme an der U3-6, U7, U7a und U8 Vorsorge-Untersuchung bei Kindern",
  "Psychomotorische Reife bei der Einschulung" = "Einzelindikator: Anteil der auffälligen Kinder bei der Schuleingangs-Untersuchung beim Sehen, Hören, Verhalten, Koordination oder der Sprachentwicklung",
  "Verletzte im Straßenverkehr" = "Verletzte Personen im Strassenverkehr pro 1.000 Einwohner",
  "Alkoholbedingte Erkrankungen" = "Mittelwert der Einzelindikatoren: Sterbefälle aufgrund vermeidbarer Lebererkrankungen, alkoholbedingte Unfälle",
  "Hausarztdichte" = "Mittelwert der Einzelindikatoren: Hausarztdichte (Einwohner pro Hausarzt) und Anteil der Postleitzahlen im Kreis mit einer sehr niedrigen Hausarztdichte",
  "Apothekendichte" = "Einzelindikator: Apotheken pro 1.000 Einwohner",
  "Personal in Pflege" = "Anzahl Personal in ambulanter und stationärer Pflege bei Pflegebedürftigen über 65 Jahren"
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
# länder <- readOGR("./GeoJSON/2017/simplified-95/laender_95_geo.json",
#                    use_iconv = TRUE,
#                    encoding = "UTF-8") %>%
#   st_as_sf() 
# bezirke <- readOGR("./GeoJSON/BEZIRKSGRENZEOGD.json",
#                   use_iconv = TRUE,
#                   encoding = "UTF-8") %>% 
#   st_as_sf() %>% 
#   select(NAMEK, BEZNR, geometry)

bezirke_map_agg_dta <- readRDS("./data/bezirke_map_agg_dta.rds")
länder_agg_map_dta <- readRDS("./data/länder_agg_map_dta.rds")


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
  key = factor(unlist(lapply(indikatoren_struktur, names)))
)
