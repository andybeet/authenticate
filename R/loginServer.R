#' Login server module.
#'
#' Shiny authentication module for use with \code{\link{loginUI}}
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#' @param log_out Reactive element. Supply the returned reactive from \code{\link{logoutServer}} here to trigger a user logout
#'
#' @return A reactive 3 element list to your main application.
#' \item{user_auth}{A boolean indicating whether there has been a successful login or not}
#' \item{info}{will be the succesfully logged in username, otherwise = NULL}
#' \item{channel}{\code{\link[DBI]{DBIConnection-class}} object after successful connection}
#'
#' @family modules
#'
#' @examples
#'  \dontrun{
#'  user_credentials <- shiny::callModule(loginServer, "login", log_out = reactive(logout_init()))
#' }


loginServer <- function(input, output, session, log_out = NULL) {

  credentials <- shiny::reactiveValues(user_auth = FALSE, info = NULL)

  # observes the click of the logout button
  shiny::observeEvent(log_out(), {
    credentials$user_auth <- FALSE
    credentials$info <- NULL
    # clears the password field after attempted login
    shiny::updateTextInput(session, "password", value = "")

    # closes all odbc objects
    DBI::dbDisconnect(credentials$channel)
  })

  # toggled login and app
  shiny::observeEvent(credentials$user_auth, ignoreInit = TRUE, {
    shinyjs::toggle(id = "panel")
  })


  shiny::observeEvent(input$button, {
      # check to see if connection can be made. If so authentication made. channel passed back
      channel <- tryCatch(
        {
          channel <- DBI::dbConnect(odbc::odbc(), dsn="sole",uid=input$user_name,pwd=input$password, timeout = 10)

        }, warning=function(w) {
          if (grepl("login denied",w)) {message("login to server failed - Check username and password")}
          if (grepl("locked",w)) {message("logon to server failed - Account may be locked")}
          message(paste0("Can not Connect to Database: ",server))
          return(NA)
        }, error=function(e) {
          message(paste0("Terminal error: ",e))
          return(NA)
        }, finally = {

        }
      )

      if (isS4(channel)) {
        password_match <- TRUE
        credentials$user_auth <- TRUE
        credentials$info <- data.frame(user = input$user_name,pass=input$password)
        credentials$channel <- channel
      } else {
        password_match <- FALSE
        shinyjs::toggle(id = "error", anim = TRUE, time = 1, animType = "fade")
        shinyjs::delay(5000, shinyjs::toggle(id = "error", anim = TRUE, time = 1, animType = "fade"))
      }

  })

  # return reactive list containing auth boolean and user information
  shiny::reactive({
    shiny::reactiveValuesToList(credentials)
  })

}
