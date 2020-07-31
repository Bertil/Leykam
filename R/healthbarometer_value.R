# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#' Caclulate mean of indices for overall healthbaromter value
#'
#' @param values dataframe: containing the all relevant variables
#' @param weigths numeric vector: containnig the weight for each variabel in df
#'
#' @return numeric vector: value for healthbarometer
#'
#' @export
#'
healthbarometer_value <- function (values, user_weights) {
  not_nas <- !is.na(values)
  values <- values[not_nas]
  user_weights <- user_weights[not_nas]
  relative_weights <- user_weights/sum(user_weights)
  value <- sum(values*relative_weights)
  value
}
