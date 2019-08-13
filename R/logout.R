# # This code was modified from https://github.com/PaulC91/shinyauthr
#
# logout UI module. Shiny UI Module for use with logoutServer
# 
# Call via logoutUI("your_id")
#
# arguments:
# id Shiny id
# label label for the logout button
# class bootstrap class for the logout button
# style css styling for the logout button
#
# returns a Shiny UI action button

logoutUI <- function(id, label = "Log out", class = "btn-danger", style = "color: white;") {
  ns <- shiny::NS(id)
  
  shinyjs::hidden(
    shiny::actionButton(ns("button"), label, class = class, style = style)
  )
}

# logout server module
#
# Shiny authentication module for use with logoutUI
#
# Call via shiny::callModule(logout, "your_id", ...)
#
# Arguments:
# input: shiny input
# output: shiny output
# session: shiny session
# active: [reactive] supply the returned user_auth boolean reactive from loginServer
#   here to hide/show the logout button
#
# The reactive output of this module should be supplied as the log_out argument to the 
#   loginServer module to trigger the logout process
#
# 
#   logout_init <- shiny::callModule(logout, "logout",  active = reactive(user_credentials()$user_auth))

logoutServer <- function(input, output, session, active) {

  shiny::observeEvent(active(), ignoreInit = TRUE, {
    shinyjs::toggle(id = "button", anim = TRUE, time = 1, animType = "fade")
  })

  # return reactive logout button tracker
  shiny::reactive({input$button})
}
