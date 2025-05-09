#' Launch tidymass Shiny Application
#'
#' This function launches the tidymass Shiny application included in the 'tidymass' package.
#' It locates the Shiny app directory within the installed package and runs the app.
#'
#' @return None.
#' @export
#'
#' @note This function does not take any arguments.
#'       Ensure that the 'tidymass' package is correctly installed with the Shiny app included.

launch_tidymass_shiny <-
  function() {
    if (!requireNamespace("shiny", quietly = TRUE)) {
      stop("The 'shiny' package is required but not installed. Please install 'shiny' to use this function.",
           call. = FALSE)
    }
    
    appDir <- system.file("shinyapp/tidymass", package = "tidymass")
    if (appDir == "") {
      stop("Shiny app not found in the package", call. = FALSE)
    }
    
    shiny::runApp(appDir)
  }


#' Launch metid Shiny Application
#'
#' This function launches the metid Shiny application included in the 'metid' package.
#' It locates the Shiny app directory within the installed package and runs the app.
#'
#' @return None.
#' @export
#'
#' @note This function does not take any arguments.
#'       Ensure that the 'metid' package is correctly installed with the Shiny app included.

launch_metid_shiny <-
  function() {
    if (!requireNamespace("shiny", quietly = TRUE)) {
      stop("The 'shiny' package is required but not installed. Please install 'shiny' to use this function.",
           call. = FALSE)
    }
    
    appDir <- system.file("shinyapp/metid", package = "tidymass")
    if (appDir == "") {
      stop("Shiny app not found in the package", call. = FALSE)
    }
    
    shiny::runApp(appDir)
  }
