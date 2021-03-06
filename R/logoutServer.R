#' Logout server module
#'
#' Shiny authentication module for use with \code{\link{logoutUI}}

#'@param input Character String. Shiny input
#'@param output shiny output
#'@param session shiny session
#'@param active Reactive element. Supply the returned user_auth boolean reactive from \code{\link{loginServer}} here to hide/show the logout button
#'
#'@section Notes:
#' The reactive output of this module should be supplied as the log_out argument to the
#'  \code{\link{loginServer}} module to trigger the logout process
#'
#'@family modules
#'
#'@examples
#'\dontrun{
#'  logout_init <- shiny::callModule(logoutServer, "logout",  active = reactive(user_credentials()$user_auth))
#'}

logoutServer <- function(input, output, session, active) {

  shiny::observeEvent(active(), ignoreInit = TRUE, {
    shinyjs::toggle(id = "button", anim = TRUE, time = 1, animType = "fade")
  })

  # return reactive logout button tracker
  shiny::reactive({input$button})
}
