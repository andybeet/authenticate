missing_packages <- function() {
  installedOnMachine <- installed.packages()
  packagesToInstall <- c("DT","shiny","shinydashboard","RODBC","shinyjs","dingleweed")
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
  