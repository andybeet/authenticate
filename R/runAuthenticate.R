#' Starts Authenticate shiny app
#'
#' This is the UI (User Interface) portion of the app.
#' It contains the layout and look of the app and the parameters that get passed to the \code{\link{server}} portion of the app
#'
#'
#'@export

runAuthenticate <- function() {

  Sys.setenv(ORACLE_HOME="/ora1/app/oracle/product/11.2.0/dbhome_1")

  ui <- shinydashboard::dashboardPage(

    shinydashboard::dashboardHeader(title = "NEFSC Data Portal",
                    tags$li(class = "dropdown", style = "padding: 8px;",
                            logoutUI("logout"))
    ),

    shinydashboard::dashboardSidebar(collapsed = TRUE,
                     div(textOutput("welcome"), style = "padding: 20px")
    ),

    shinydashboard::dashboardBody(
      shinyjs::useShinyjs(),
      tags$head(tags$style(".table{margin: 0 auto;}"),
                tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.contentWindow.min.js",
                            type="text/javascript"),
                includeScript(system.file("extdata","returnClick.js",package = "authenticate"))
      ),

      loginUI("login",error_message = paste0("Login failed. Three failures and you'll need to contact IT to reset")),
      shiny::uiOutput("SAGAUI"),
      shiny::HTML('<div data-iframe-height></div>')
    )
  )


  shiny::shinyApp(ui, server)

}
