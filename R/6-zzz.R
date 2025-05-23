.onAttach <- function(...) {
  options(warn = -1)
  needed <- core[!is_attached(core)]
  if (length(needed) == 0)
    return()
  
  crayon::num_colors(TRUE)
  tidymass_attach()
  
  # if (!"package:conflicted" %in% search()) {
  #   x <- tidymass_conflicts()
  #   msg(tidymass_conflict_message(x), startup = TRUE)
  # }
  
}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}
