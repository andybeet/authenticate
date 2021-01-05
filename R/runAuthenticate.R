#' Starts Authenticate shiny app
#'
#' This is the UI (User Interface) portion of the app.
#' It contains the layout and look of the app and the parameters that get passed to the \code{\link{server}} portion of the app
#'
#'@importFrom shiny "tags" "div" "textOutput"
#'
#'@examples
#'\dontrun{
#'runAuthenticate()
#'}
#'
#'
#'@export

runAuthenticate <- function() {

  shiny::shinyApp(ui, server)

}
