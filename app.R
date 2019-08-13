#library(DT)
#library(shiny)
#library(shinydashboard)
#library(shinyjs)
#library(RODBC)
source("R/login.R")
source("R/logout.R")

ui <- shinydashboard::dashboardPage(
  
  shinydashboard::dashboardHeader(title = "NEFSC Survey Data Portal",
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
              includeScript("returnClick.js")
    ),
    
    loginUI("login",error_message = paste0("Login failed. Three failures and you'll need to contact IT to reset")),
    shiny::uiOutput("SAGAUI"),
    shiny::HTML('<div data-iframe-height></div>')
  )
)


server <- function(input, output, session) {
  
  ##############################################################################################
  #### log in and logout Modules called and monitored
  ##############################################################################################
  # call login module and returns credentials object
  credentials <- shiny::callModule(loginServer, "login", 
                                  log_out = reactive(logout_init()))
  
  # calls logout module. monitored by login module above since its a reactive object
  logout_init <- shiny::callModule(logoutServer, "logout", shiny::reactive(credentials()$user_auth))

  ##############################################################################################
  
  # checks credentials
  user_info <- shiny::reactive({credentials()$info})


  # dummy data used to fil panel
  user_data <- shiny::reactive({
    shiny::req(credentials()$user_auth)
    RODBC::sqlQuery(credentials()$channel,"select * from cfdbs.area")
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

shiny::shinyApp(ui, server)
