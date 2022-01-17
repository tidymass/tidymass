parameters =
  object@process_info %>%
  lapply(function(x) {
    data.frame(
      pacakge_name = x@pacakge_name,
      function_name = x@function_name,
      parameter = purrr::map2(names(x@parameter), 
                              x@parameter, function(name, value) {
                                if (length(value) > 5) {
                                  value = head(value, 5)
                                  value = paste(c(value, "..."), collapse = ',')
                                } else{
                                  value = paste(value, collapse = ',')
                                }
                                paste(name, value, sep = ":")
                              }) %>% unlist(),
      time = x@time
    )
  }) %>%
  dplyr::bind_rows()