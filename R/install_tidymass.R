##------------------------------------------------------------------------------
#' @title install_tidymass
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
#' @param ... Other parameters from devtools::install_github() or devtools::install_git()
#' @importFrom devtools install_github
#' @importFrom devtools install_git
#' @export

install_tidymass <-
  function(from = c("github", "gitee"),
           force = FALSE,
           upgrade = "never",
           dependencies = NA,
           demo_data = TRUE,
           ...) {
    from = match.arg(from)
    if(from == "github"){
      devtools::install_github(repo = "jaspershen/metID",
                               force = force,
                               upgrade = upgrade,
                               dependencies = dependencies,
                               ...)
      
      devtools::install_github(repo = "jaspershen/metflow2",
                               force = force,
                               upgrade = upgrade,
                               dependencies = dependencies,
                               ...) 
      
      devtools::install_github(repo = "jaspershen/sxtTools",
                               force = force,
                               upgrade = upgrade,
                               dependencies = dependencies,
                               ...) 
      if(demo_data){
        devtools::install_github(repo = "jaspershen/demoData",
                                 force = force,
                                 upgrade = upgrade,
                                 dependencies = dependencies,
                                 ...)  
      }
    }
    
    if(from == "gitee"){
      devtools::install_git(url = "https://gitee.com/jaspershen/metID", 
                            dependencies = dependencies, 
                            force = force, 
                            upgrade = upgrade,
                            ...)
      
      devtools::install_git(url = "https://gitee.com/jaspershen/metflow2", 
                            dependencies = dependencies, 
                            force = force, 
                            upgrade = upgrade,
                            ...)
      
      devtools::install_git(url = "https://gitee.com/jaspershen/sxtTools", 
                            dependencies = dependencies, 
                            force = force, 
                            upgrade = upgrade,
                            ...)
      
      if(demo_data){
        devtools::install_git(url = "https://gitee.com/jaspershen/demoData", 
                              dependencies = dependencies, 
                              force = force, 
                              upgrade = upgrade,
                              ...) 
      }
    }
  }