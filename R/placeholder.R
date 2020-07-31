# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#' Add a placeholder to a shiny page
#'
#' @param size no of line breaks to be inserted
#'
#' @export
#'
placeholder <- function(size) {
  fluidRow(
    p(HTML(paste0(rep("<br/>", size))))
  )
}
