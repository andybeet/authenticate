packagesToInstall <- c("DT","shiny","shinydashboard","RODBC","shinyjs")

# append to vector to packages you wish to install then run the function passing the vector as an argument
#
#
#
#
missing_packages <- function(packagesToInstall) {
  installedOnMachine <- installed.packages()
  required <- packagesToInstall[!(packagesToInstall %in% installedOnMachine)]
  if (length(required) > 0) {
    message(paste("You are missing the following packages: ",required ))
    userInput <- readline(prompt ="Install packages listed above [y/n]:" )
    if (tolower(userInput) == "y") {
      #install packages
      for (rpkg in required) {
        install.packages(rpkg)
      }
    } else if (tolower(userInput) == "n") {
      print("OK. If you change your mind, rerun the function - missing_packages")
    } else {
      print("Invalid choice")
      missing_packages()
    }
    
  } else {
    print("All up to date. Run the app")
  }
}
  