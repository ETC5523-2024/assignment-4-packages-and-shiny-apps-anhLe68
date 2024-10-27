#' Interactive shiny app for cafeMel
#'
#' @return Interactive shiny app
#' @export

launch_app <- function() {
  app_dir <- system.file("shiny_app", package = "cafeMel")
  shiny::runApp(app_dir, display.mode = "normal")
}
