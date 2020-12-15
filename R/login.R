# This code was modified from https://github.com/PaulC91/shinyauthr
#
# login UI module. Shiny UI Module for use with loginServer
# 
# Call this function using: loginUI("your_id")
#
# arguments
#
# id Shiny id
# title header title for the login panel
# user_title label for the user name text input
# pass_title label for the password text input
# login_title label for the login button
# error_message message to display after failed login
#
# returns Shiny UI


loginUI <- function(id, title = "Please log in", user_title = "User Name", pass_title = "Password",
                    login_title = "Log in", error_message = "Invalid username or password!") {
  ns <- shiny::NS(id)
  
  shiny::div(id = ns("panel"), style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
      shiny::wellPanel(
        shiny::tags$h2(title, class = "text-center", style = "padding-top: 0;"),

        shiny::textInput(ns("user_name"), shiny::tagList(shiny::icon("user"), user_title)),

        shiny::passwordInput(ns("password"), shiny::tagList(shiny::icon("unlock-alt"), pass_title)),

        shiny::div(
          style = "text-align: center;",
          shiny::actionButton(ns("button"), login_title, class = "btn-primary", style = "color: white;")
        ),

        shinyjs::hidden(
          shiny::div(id = ns("error"),
                     shiny::tags$p(error_message,
                     style = "color: red; font-weight: bold; padding-top: 5px;", class = "text-center"))
        )
      )
  )
}

# login server module. Shiny authentication module for use with loginUI
#
# Call shiny::callModule(login, "your_id", ...)
#
# arguments:
# input shiny input
# output shiny output
# session shiny session
# log_out [reactive] supply the returned reactive from \link{logout} here to trigger a user logout
#
# The module will return a reactive 3 element list to your main application. 
#   user_auth: is a boolean indicating whether there has been a successful login or not.
#   info: will be the succesfully logged in username. 
#   channel: RODBC object after successful connection
#   
#   When user_auth is FALSE info is NULL.
# 
#  user_credentials <- shiny::callModule(loginServer, "login", log_out = reactive(logout_init()))


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
