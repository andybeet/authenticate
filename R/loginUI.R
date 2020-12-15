#' Appearance of loginUI
#'
#' The login User Interface design elements are controlled.
#' This \code{loginUI} Module is for use with \code{\link{loginServer}} module.
#'
#'@param id Character String. Shiny id
#'@param title Character String. Header title for the login panel
#'@param user_title Character String. Label for the user name text input
#'@param pass_title Character String. Label for the password text input
#'@param login_title Character String. Label for the login button
#'@param error_message Character String. Message to display after failed login
#'
#'@returns returns Shiny UI
#'
#'@family loginout
#'
#'@section Reference:
#' This code was modified from https://github.com/PaulC91/shinyauthr
#'
#'@examples
#' \dontrun{
#' loginUI("login")
#'}
#'


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
