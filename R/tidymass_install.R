##------------------------------------------------------------------------------
#' @title tidymass_install
#' @description Install all packages in tidymass.
#' @author Xiaotao Shen
#' \email{shenxt@@stanford.edu}
#' @param from From github or gitee, if you are in China, try to set this as "gitee".
#' @param force Force installation, even if the remote state has not changed since the previous install.
#' @param upgrade One of "default", "ask", "always", or "never".
#' "default" respects the value of the R_REMOTES_UPGRADE environment variable if set,
#' and falls back to "ask" if unset. "ask" prompts the user for which out of date
#' packages to upgrade. For non-interactive sessions "ask" is equivalent to "always".
#' TRUE and FALSE are also accepted and correspond to "always" and "never" respectively.
#' @param dependencies Which dependencies do you want to check? Can be a character vector
#' (selecting from "Depends", "Imports", "LinkingTo", "Suggests", or "Enhances"),
#' or a logical vector.TRUE is shorthand for "Depends", "Imports", "LinkingTo"
#' and "Suggests". NA is shorthand for "Depends", "Imports" and "LinkingTo"
#' and is the default. FALSE is shorthand for no dependencies
#' (i.e. just check this package, not its dependencies).
#' The value "soft" means the same as TRUE, "hard" means the same as NA.
#' @param demo_data Install demo_data package or not.
#' @param which_package What packages you want to install? Default is all. 
#' You can set it as a character vector.
#' @param ... Other parameters from devtools::install_github() or devtools::install_git()
#' @importFrom devtools install_github
#' @importFrom devtools install_git
#' @export

tidymass_install <-
  function(from = c("github", "gitee"),
           force = FALSE,
           upgrade = "never",
           dependencies = NA,
           demo_data = TRUE,
           which_package = c(
             "all",
             "massdataset",
             "massprocesser",
             "masscleaner",
             "massqc",
             "metid",
             "massstat",
             "metpath",
             "tinytools"
           ),
           ...) {
    from = match.arg(from)
    which_package = match.arg(which_package)
    which_package = stringr::str_to_lower(which_package)
    
    ##detach packages
    if ("massdataset" %in% search()) {
      detach("package:massdataset")
    }
    
    if ("massprocesser" %in% search()) {
      detach("package:massprocesser")
    }
    
    if ("masscleaner" %in% search()) {
      detach("package:masscleaner")
    }
    
    if ("massqc" %in% search()) {
      detach("package:massqc")
    }
    
    if ("metid" %in% search()) {
      detach("package:metid")
    }
    
    if ("massstat" %in% search()) {
      detach("package:massstat")
    }
    
    if ("metpath" %in% search()) {
      detach("package:metpath")
    }
    
    if ("tinytools" %in% search()) {
      detach("package:tinytools")
    }
    
    if (from == "github") {
      ##massdataset
      if (any(which_package == "all") |
          any(which_package == "massdataset")) {
        devtools::install_github(
          repo = "tidymass/massdataset",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##massprocesser
      if (any(which_package == "all") |
          any(which_package == "massprocesser")) {
        devtools::install_github(
          repo = "tidymass/massprocesser",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##masscleaner
      if (any(which_package == "all") |
          any(which_package == "masscleaner")) {
        devtools::install_github(
          repo = "tidymass/masscleaner",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##massqc
      if (any(which_package == "all") |
          any(which_package == "massqc")) {
        devtools::install_github(
          repo = "tidymass/massqc",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##metid
      if (any(which_package == "all") |
          any(which_package == "metid")) {
        devtools::install_github(
          repo = "tidymass/metid",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##massstat
      if (any(which_package == "all") |
          any(which_package == "massstat")) {
        devtools::install_github(
          repo = "tidymass/massstat",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##metpath
      if (any(which_package == "all") |
          any(which_package == "metpath")) {
        devtools::install_github(
          repo = "tidymass/metpath",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
      ##tinytools
      if (any(which_package == "all") |
          any(which_package == "tinytools")) {
        devtools::install_github(
          repo = "tidymass/tinytools",
          force = force,
          upgrade = upgrade,
          dependencies = dependencies,
          ...
        )
      }
      
    }
    if (from == "gitee") {
      stop("gitee is not supported now.\n")
    }
  }