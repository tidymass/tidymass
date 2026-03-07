##------------------------------------------------------------------------------
#' Check for available tidymass updates
#'
#' Query remote repositories and compare installed package versions with the
#' latest available versions.
#'
#' @author Xiaotao Shen
#' \email{xiaotao.shen@outlook.com}
#' @param packages Which package set to check: `"core"` or `"all"`.
#' @param from Repository source to prioritize: `"gitlab"`, `"github"`,
#'   `"gitee"`, or `"shen"`.
#' @returns A data frame of outdated packages. If all packages are up to date,
#'   the function prints a message and returns `NULL`.
#' @export

check_tidymass_version <-
  function(packages = c("core", "all"),
           from = c("gitlab", "github", "gitee", "shen")) {
    from <- match.arg(from)
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
        "masstools",
        "massdatabase"
      ) %>%
      lapply(function(x) {
        y <-
          tryCatch(
            check_github(pkg = paste0("tidymass/", x)),
            error = function(e) {
              NULL
            }
          )
        if (is.null(y)) {
          y <-
            tryCatch(
              check_gitlab(pkg = paste0("tidymass/", x)),
              error = function(e) {
                NULL
              }
            )
        }
        
        if (is.null(y)) {
          y <-
            tryCatch(
              check_gitee(pkg = paste0("tidymass/", x)),
              error = function(e) {
                NULL
              }
            )
        }
        
        if (is.null(y)) {
          y <-
            tryCatch(
              check_tidymass.org(pkg = x),
              error = function(e) {
                NULL
              }
            )
        }
        
        if (is.null(y)) {
          y <-
            c(
              package = paste0("tidymass/", x),
              installed_version = "1.0.0",
              latest_version = "1.0.0",
              up_to_date = TRUE
            )
        }
        y$installed_version <-
          as.character(y$installed_version)
        unlist(y)
      }
      )
    
    check_result <-
      as.data.frame(do.call(rbind, check_result))
    
    check_result$package <-
      stringr::str_replace(check_result$package, "tidymass\\/", "")
    
    check_result$up_to_date <-
      check_result$installed_version ==
      check_result$latest_version
    
    check_result$up_to_date <-
      as.logical(check_result$up_to_date)
    
    if (packages == "core") {
      check_result <-
        dplyr::filter(
          check_result,
          !stringr::str_detect(package, "massconverter")
        )
    }
    
    if (all(check_result$up_to_date)) {
      message("No package to update.")
    } else{
      check_result <-
        dplyr::filter(check_result, !up_to_date)
      message("Use update_tidymass() to update the following pacakges.")
      check_result
    }
  }


##------------------------------------------------------------------------------
#' Update tidymass packages
#'
#' Install newer versions of tidymass packages from a selected remote source.
#'
#' @author Xiaotao Shen
#' \email{xiaotao.shen@outlook.com}
#' @param packages Which package set to update: `"core"` or `"all"`.
#' @param from Repository source: `"gitlab"`, `"github"`, `"gitee"`, or
#'   `"tidymass.org"`.
#' @param fastgit Logical; if `TRUE`, install packages through the FastGit
#'   helper when available; otherwise the standard remotes installer is used.
#' @returns Invisibly returns `NULL`. Packages are updated for their side
#'   effects.
#' @export
update_tidymass <-
  function(packages = c("core", "all"),
           from = c("gitlab", "github", "gitee", "tidymass.org"),
           fastgit = FALSE) {
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
          if (fastgit) {
            install_fastgit_or_fallback(
              pkg = paste0("tidymass/", i),
              from = from
            )
          } else{
            remotes::install_github(repo = paste0("tidymass/", i),
                                    upgrade = "never")
          }
          
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
          
          if (fastgit) {
            install_fastgit_or_fallback(
              pkg = paste0("tidymass/", i),
              from = from
            )
          } else{
            remotes::install_gitlab(repo = paste0("tidymass/", i),
                                    upgrade = "never")
          }
        }
      }
      
      if (from == "gitee") {
        for (i in check_result$package) {
          tryCatch(
            detach(name = paste0("package:", i)),
            error = function(e) {
              message(i, ".\n")
            }
          )
          if (fastgit) {
            install_fastgit_or_fallback(
              pkg = paste0("tidymass/", i),
              from = from
            )
          } else{
            remotes::install_git(url = paste0("https://gitee.com/tidymass/", i),
                                 upgrade = "never")
          }
        }
      }
      
      if (from == "tidymass.org") {
        for (i in check_result$package) {
          tryCatch(
            detach(name = paste0("package:", i)),
            error = function(e) {
              message(i, ".\n")
            }
          )
          install_tidymass(which_package = i, from = "tidymass.org")
        }
      }
    }
  }

install_fastgit_or_fallback <- function(pkg, from) {
  ns <- asNamespace("masstools")
  if (exists("install_fastgit", envir = ns, inherits = FALSE)) {
    get("install_fastgit", envir = ns, inherits = FALSE)(
      pkg = pkg,
      from = from,
      upgrade = "never"
    )
    return(invisible(NULL))
  }

  warning(
    "masstools::install_fastgit() is not available; using remotes installation instead.",
    call. = FALSE
  )

  switch(
    from,
    github = remotes::install_github(repo = pkg, upgrade = "never"),
    gitlab = remotes::install_gitlab(repo = pkg, upgrade = "never"),
    gitee = remotes::install_git(
      url = paste0("https://gitee.com/", pkg),
      upgrade = "never"
    ),
    stop("FastGit fallback is not supported for source: ", from, call. = FALSE)
  )
}
