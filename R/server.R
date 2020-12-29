#' Server function of app
#'
#' Function that listens for user input and responds to user input.
#' This is called by the ui (user interface) portion of the app which is found in \code{\link{runAuthenticate}}
#'
#'@param input Input Object. Values defined by the user when interacting with the app
#'@param output Output object. Values defined by the reactive functions in the \code{server} function
#'@param session session
#'
#'@return


server <- function(input, output, session) {

  ##############################################################################################
  #### log in and logout Modules called and monitored
  ##############################################################################################
  # call login module and returns credentials object
  credentials <- shiny::callModule(loginServer, "login",
                                   log_out = reactive(logout_init()))

  # calls logout module. monitored by login module above since its a reactive object
  logout_init <- shiny::callModule(logoutServer, "logout", active=shiny::reactive(credentials()$user_auth))

  ##############################################################################################

  # checks credentials
  user_info <- shiny::reactive({credentials()$info})

  # # create a pool in which to grab new db connections when needed
  # pool <- pool::dbPool(drv=odbc::odbc(),dbname="sole",username=user_info()$user,password=user_info()$pass)

  # dummy data used to fill panel
  user_data <- shiny::reactive({
    shiny::req(credentials()$user_auth)
    DBI::dbGetQuery(credentials()$channel,"select * from cfdbs.area")
  })

  # side bar panel
  output$welcome <- shiny::renderText({
    shiny::req(credentials()$user_auth)
    paste0("Logged in as ", user_info()$user)
  })



  # linked to shiny::uiOutput("testUI") call
  # this is where SAGA stuff goes. Wont need DT
  output$SAGAUI <- shiny::renderUI({
    shiny::req(credentials()$user_auth)

    shiny::fluidRow(
      shiny::column(
        width = 12,
        tags$h2(paste0("Some title")),
        shinydashboard::box(width = NULL, status = "primary",
                            DT::renderDT(user_data(), options = list(scrollX = TRUE))
        )
      )

    )
  })

}
