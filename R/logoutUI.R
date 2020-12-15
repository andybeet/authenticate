#' Logout button aesthetics
#'
#'
#' The logout User Interface design elements are controlled.
#' This \code{logoutUI} Module is for use with \code{\link{logouServer}} module.
#'
#'@param id Character String. Shiny id
#'@param label Character String. Label for the logout button
#'@param class Character String. Bootstrap class for the logout button
#'@param style Character String. css styling for the logout button
#'
#'@return A Shiny UI action button
#'
#'@family modules
#'
#'@section Reference:
#'
#' This code was modified from https://github.com/PaulC91/shinyauthr

logoutUI <- function(id, label = "Log out", class = "btn-danger", style = "color: white;") {
  ns <- shiny::NS(id)

  shinyjs::hidden(
    shiny::actionButton(ns("button"), label, class = class, style = style)
  )
}
