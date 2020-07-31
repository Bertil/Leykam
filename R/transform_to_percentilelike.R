# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#' Transform variable to percentile depiction
#'
#' @param var numeric scalar: variable to be transformed
#' @return numeric scalar: transformed variable
#'
#' @export
#'
transform_to_percentilelike <- function (var) {

  #var <- data$lebenserw_m

  percentiles <- c(0, 0.05, 0.1, 0.2, 0.3, 0.4, 0.6, 0.7, 0.8, 0.9, 0.95, 1)
  perc_var <- gtools::quantcut(var, percentiles)
  perc_var <- as.numeric(perc_var)-1 #to get 0:10 instead of 1:11

  #TODO this is not yet done. "In-between" percentiles have to be calculated:
  #Score$lebenserw_m[Score$lebenserw_m==1] <- round(1+(GBaro_Daten$lebenserw_m - quantile(GBaro_Daten$lebenserw_m, probs=0.05))/(quantile(GBaro_Daten$lebenserw_m, probs=0.1) - quantile(GBaro_Daten$lebenserw_m, probs=0.05)), digits = 2)


}
