##------------------------------------------------------------------------------
#' @title check_tidymass_version
#' @description Check if there are packages in tidymass can be updated.
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param packages core or all packages in tidymass. "core" means all the core
#' packages in tidymass and "all" means all the packages in tidymass.
#' @importFrom rvcheck check_github
#' @export

check_tidymass_version <-
  function(packages = c("core", "all")) {
    packages <- match.arg(packages)
    check_result <-
      c(
        "tidymass",
        "massconverter",
        "massdataset",
        "massprocesser",
        "masscleaner",
        "massqc",
        "metid",
        "massstat",
        "metpath",
        "masstools"
      ) %>%
      lapply(function(x) {
        y <-
          rvcheck::check_github(pkg = paste0("tidymass/", x))
        y$installed_version <-
          as.character(y$installed_version)
        unlist(y)
      })
      check_result <- 
      do.call(rbind, check_result) %>%
      as.data.frame()
    
    check_result$package <-
      check_result$package %>%
      stringr::str_replace("tidymass\\/", "")
    
    check_result$up_to_date <-
      as.logical(check_result$up_to_date)
    
    
    if (packages == "core") {
      check_result <-
        check_result %>%
        dplyr::filter(!stringr::str_detect(package, "massconverter"))
    }
    
    if (all(check_result$up_to_date)) {
      message("No package to update.\n")
    } else{
      message("Use update_tidymass() to update the following pacakges.\n")
      check_result
    }
  }


##------------------------------------------------------------------------------
#' @title update_tidymass
#' @description Update packages in tidymass.
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param packages core or all packages in tidymass. "core" means all the core
#' packages in tidymass and "all" means all the packages in tidymass.
#' @param from github, gitlab or gitee.
#' @importFrom rvcheck check_github
#' @importFrom remotes install_github install_gitlab install_git
#' @export
update_tidymass <-
  function(packages = c("core", "all"),
           from = c("github", "gitlab", "gitee")) {
    packages <- match.arg(packages)
    from <- match.arg(from)
    
    check_result <-
      check_tidymass_version(packages = packages)
    
    if (!is.null(check_result)) {
      if (from == "github") {
        for (i in check_result$package) {
          tryCatch(
            detach(name = paste0("package:", i)),
            error = function(e) {
              message(i, ".\n")
            }
          )
          remotes::install_github(repo = paste0("tidymass/", i),
                                  upgrade = "never")
        }
      }
      
      if (from == "gitlab") {
        for (i in check_result$package) {
          tryCatch(
            detach(name = paste0("package:", i)),
            error = function(e) {
              message(i, ".\n")
            }
          )
          remotes::install_gitlab(repo = paste0("tidymass/", i),
                                  upgrade = "never")
        }
      }
      
      if (from == "gitee") {
        tryCatch(
          detach(name = paste0("package:", i)),
          error = function(e) {
            message(i, ".\n")
          }
        )
        for (i in check_result$package) {
          remotes::install_git(url = paste0("https://gitee.com/jaspershen/", i),
                               upgrade = "never")
        }
      }
    }
  }