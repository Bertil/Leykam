# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#' Transform and save raw data in form of an r object
#'
#' @param string scalar: path to raw data as csv
#' @param boolean sclar: whether data.rds in data should be rewritten?
#' @return data frame: converted data from source
#'
#' @export
#'
transform_raw_data <- function (path = "data/data_indicators.csv", save=TRUE) {
  shiny_data <- readr::read_csv2(path)

  # Set all variable names to lower case
  names(shiny_data) <- tolower(names(shiny_data))

  # UNCOMMENT when using data_raw
  # Recode variables
  #variables_to_recode <- c("sauglings", "kh_kinder", "esuvisu", "esuspra", "esumot", "kind_ueg",
  #                         "verm_sterbe_leber_anteil", "ant_alk_unf", "strassverl", "geb_ant_u2499g")
  #shiny_data[variables_to_recode] <- shiny_data[variables_to_recode]*(-1)

  # Mutate variables to percentile representation
  #vars_to_mutate <- names(shiny_data[3:ncol(data)])
  #shiny_data <- mutate_at(shiny_data, vars_to_mutate, healthbarometer::transform_to_percentilelike)

  # Create the aggregated indictors
  shiny_data <- shiny_data %>% rowwise %>%
    mutate(
      lebenserwartung_m = mean(c(lebenserw_m, lebenserw65m), na.rm=TRUE),
      lebenserwartung_f = mean(c(lebenserw_f, lebenserw65w), na.rm=TRUE),
      gesundheit_erstes_jahr = mean(c(sauglings, geb_ant_u2499g), na.rm=TRUE),
      kindergesundheit = mean(c(kh_kinder, kind_ueg), na.rm=TRUE),
      impfungen_polio = mean(c(impf_pol, impf_mas), na.rm=TRUE),
      vorsorge_kinder = mean(c(u3u6, u7, u7a, u8), na.rm=TRUE),
      psychomotorische_reife = mean(c(esuvisu, esuspra, esumot), na.rm=TRUE),
      verletzte_strasse = strassverl,
      alkhol_erkrankungen = mean(c(verm_sterbe_leber_anteil, ant_alk_unf), na.rm=TRUE),
      apothekendichte = apo_p1000e,
      hausarztdichte = mean(c(einw_p_arzt, ant_err_arzt_u), na.rm=TRUE),#passt nicht
      personal_in_pflege = pflege_pers
  )

  # Save, if desired
  if (save) save(shiny_data, file="data/shiny_data.rda")
  shiny_data
}
