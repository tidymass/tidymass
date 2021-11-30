#' @title Show the logo tidymass.
#' @description The tidymass logo, using ASCII or Unicode characters
#' @author Xiaotao Shen
#' \email{shenxt@@stanford.edu}
#' @param unicode Whether to use Unicode symbols. Default is `TRUE`
#' on UTF-8 platforms.
#' @return A ASCII log of tidymass
#' @export
#' @examples 
#' tidymass_logo()


##https://onlineasciitools.com/convert-text-to-ascii-art

tidymass_logo <- function(unicode = l10n_info()$`UTF-8`) {
  logo =
    c(
      "0 __  _    __   1    2           3  4 ",
      "  _   _     _                               ", " | | (_)   | |                              ",
      " | |_ _  __| |_   _ _ __ ___   __ _ ___ ___ ", " | __| |/ _` | | | | '_ ` _ \\ / _` / __/ __|",
      " | |_| | (_| | |_| | | | | | | (_| \\__ \\__ \\", "  \\__|_|\\__,_|\\__, |_| |_| |_|\\__,_|___/___/",
      "               __/ |                        ", "              |___/                         ",
      "     5  6 /___/      7      8       9 "
    )
  
  
  hexa <- c("*", ".", "o", "*", ".", "*", ".", "o", ".", "*")
  if (unicode)
    hexa <- c("*" = "\u2b22", "o" = "\u2b21", "." = ".")[hexa]
  
  cols <- c(
    "red",
    "yellow",
    "green",
    "magenta",
    "cyan",
    "yellow",
    "green",
    "white",
    "magenta",
    "cyan"
  )
  
  col_hexa <- purrr::map2(hexa, cols, ~ crayon::make_style(.y)(.x))
  
  
  for (i in 0:9) {
    pat <- paste0("\\b", i, "\\b")
    logo <- sub(pat, col_hexa[[i + 1]], logo)
  }
  
  structure(crayon::blue(logo), class = "tidymass_logo")
}

#' @export

print.tidymass_logo <- function(x, ...) {
  cat(x, ..., sep = "\n")
  invisible(x)
}



packageStartupMessage(
  crayon::red(
    "tidymass,
More information can be found at https://tidymass.github.io/tidymass/
If you use tidymass in you publication, please cite this publication:
Metabolic reaction network-based recursive metabolite annotation for untargeted metabolomics.
Authors: Xiaotao Shen (shenxt1990@outlook.com)
Maintainer: Xiaotao Shen.
Version 0.0.1 (2021-11-27)"
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

