#' @title Show the base information of tidymass pacakge
#' @description Show the base information of tidymass pacakge.
#' @author Xiaotao Shen
#' \email{shenxt@@stanford.edu}
#' @return A ASCII log of tidymass
#' @export
#' @examples 
#' tidymass()

tidymass <- function() {
cat(crayon::red("Thank you for using tidymass!\n"))
cat(crayon::red("Version 0.0.1 (20210210)\n"))
cat(
  crayon::red(
    "More information can be found at https://jaspershen.github.io/tidymass/\n"
  )
)
cat(crayon::red(
  c(
    "  _   _     _                               ", " | | (_)   | |                              ",
    " | |_ _  __| |_   _ _ __ ___   __ _ ___ ___ ", " | __| |/ _` | | | | '_ ` _ \\ / _` / __/ __|",
    " | |_| | (_| | |_| | | | | | | (_| \\__ \\__ \\", "  \\__|_|\\__,_|\\__, |_| |_| |_|\\__,_|___/___/",
    "               __/ |                        ", "              |___/                         "
  )
  
), sep = "\n")
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    crayon::red(
      "tidymass,
More information can be found at https://jaspershen.github.io/tidymass/
If you use tidymass in you publication, please cite this publication:
Metabolic reaction network-based recursive metabolite annotation for untargeted metabolomics.
Authors: Xiaotao Shen (shenxt1990@163.com)
Maintainer: Xiaotao Shen.
Version 0.0.1 (20210210)"
    ),
cat(crayon::red(
  c(
    "  _   _     _                               ", " | | (_)   | |                              ",
    " | |_ _  __| |_   _ _ __ ___   __ _ ___ ___ ", " | __| |/ _` | | | | '_ ` _ \\ / _` / __/ __|",
    " | |_| | (_| | |_| | | | | | | (_| \\__ \\__ \\", "  \\__|_|\\__,_|\\__, |_| |_| |_|\\__,_|___/___/",
    "               __/ |                        ", "              |___/                         "
  )
), sep = "\n")
  )
}