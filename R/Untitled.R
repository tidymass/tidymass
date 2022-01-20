#' @title Mutate MS2 spectra for each variable
#' @description Mutate MS2 spectra for each variable
#' @docType methods
#' @author Xiaotao Shen
#' \email{shenxt1990@@outlook.com}
#' @param object (required) mass_dataset class object.
#' @param column rp or hilic.
#' @param polarity positive or negative
#' @param ms1.ms2.match.mz.tol default is 15 ppm.
#' @param ms1.ms2.match.rt.tol default is 30 seconds.
#' @param path work directory. In this path, please provide MS2 msp data.
#' @return A mass_dataset object with new added ms2 data.
#' @export
#' @examples
#' \dontrun{
#' data("expression_data")
#' data("sample_info")
#' data("variable_info")
#' object =
#'   create_mass_dataset(
#'     expression_data = expression_data,
#'     sample_info = sample_info,
#'     variable_info = variable_info,
#'   )
#'
#' object
#'
#' dir.create("demo_data")
#' system.file("ms2_data", package = "metid")
#' file.copy(file.path(system.file("ms2_data", package = "massdataset"), "QC_MS2_NCE25_1.mgf"),
#'           to = "demo_data", overwrite = TRUE)
#'
#' object =
#'   mutate_ms2(object = object, column = "rp", polarity = "positive")
#'
#' object@ms2_data
#' }

mutate_ms2 =
  function(object,
           column = c("rp", "hilic"),
           polarity = c("positive", "negative"),
           ms1.ms2.match.mz.tol = 15,
           ms1.ms2.match.rt.tol = 30,
           path = ".") {
    check_object_class(object = object, class = "mass_dataset")
    
    column = match.arg(column)
    polarity = match.arg(polarity)
    
    object =
      update_mass_dataset(object)
    
    variable_info = object@variable_info
    
    ##read MS2 data
    ms2_list = list.files(
      path = path,
      pattern = "mgf|mzXML|mzxml|mzML|mzml",
      all.files = TRUE,
      full.names = TRUE,
      recursive = TRUE
    )
    
    if (length(ms2_list) == 0) {
      stop("No MS2 in ", path)
    }
    
    ms2_data_name = basename(ms2_list)
    
    ms2_data <-
      purrr::map(.x = ms2_list, function(temp_ms2_data) {
        temp_ms2_type <-
          stringr::str_split(string = temp_ms2_data,
                             pattern = "\\.")[[1]]
        temp_ms2_type <- temp_ms2_type[length(temp_ms2_type)]
        ##mzXML
        if (temp_ms2_type == "mzXML" | temp_ms2_type == "mzxml") {
          masstools::read_mzxml(file = temp_ms2_data)
        }
        ##mzML
        if (temp_ms2_type == "mzML" | temp_ms2_type == "mzxml") {
          masstools::read_mzxml(file = temp_ms2_data)
        }
        ##mgf
        if (temp_ms2_type == "mgf") {
          masstools::read_mgf(file = temp_ms2_data)
        }
      })
    
    names(ms2_data) <- ms2_data_name
    
    ms2_data =
      purrr::map2(
        .x = ms2_data,
        .y = ms2_data_name,
        .f = function(temp_ms2_data, temp_ms2_data_name) {
          temp_ms2_data <-
            purrr::map(
              .x = temp_ms2_data,
              .f = function(x) {
                info <- x$info
                info <-
                  data.frame(
                    name = paste("mz", info[1], "rt", info[2], sep = ""),
                    "mz" = info[1],
                    "rt" = info[2],
                    "file" = temp_ms2_data_name,
                    stringsAsFactors = FALSE
                  )
                rownames(info) <- NULL
                x$info <- info
                x
              }
            )
          temp_ms2_data
        }
      )
    
    ms2_data <- do.call(what = c, args = ms2_data)
    
    
    ms1.info <- lapply(ms2_data, function(x) {
      x[[1]]
    }) %>%
      dplyr::bind_rows()
    
    rownames(ms1.info) <- NULL
    
    duplicated.name <-
      unique(ms1.info$name[duplicated(ms1.info$name)])
    
    if (length(duplicated.name) > 0) {
      lapply(duplicated.name, function(x) {
        ms1.info$name[which(ms1.info$name == x)] <-
          paste(x, c(seq_len(sum(
            ms1.info$name == x
          ))), sep = "_")
      })
    }
    
    ms2.info <- lapply(ms2_data, function(x) {
      x[[2]]
    })
    
    names(ms2.info) <- ms1.info$name
    
    ###match variable_info and ms2 data
    match.result <-
      masstools::mz_rt_match(
        data1 = variable_info[, c(2, 3)],
        data2 = ms1.info[, c(2, 3)],
        mz.tol = ms1.ms2.match.mz.tol,
        rt.tol = ms1.ms2.match.rt.tol,
        rt.error.type = "abs"
      )
    
    if (is.null(match.result)) {
      message(crayon::red("No variable are matched with MS2 spectra.\n"))
      return(object)
    }
    
    if (nrow(match.result) == 0) {
      message(crayon::red("No variable are matched with MS2 spectra.\n"))
      return(object)
    }
    
    message(crayon::green(
      length(unique(match.result[, 1])),
      "out of",
      nrow(variable_info),
      "variable have MS2 spectra.\n"
    ))
    
    ###if one peak matches multiple peaks, select the more reliable MS2 spectrum
    message(crayon::green("Selecting the most intense MS2 spectrum for each peak..."))
    temp.idx <- unique(match.result[, 1])
    
    match.result <-
      lapply(temp.idx, function(idx) {
        idx2 <- match.result[which(match.result[, 1] == idx), 2]
        if (length(idx2) == 1) {
          return(c(idx, idx2))
        } else{
          temp.ms2.info <- ms2.info[idx2]
          return(c(idx, idx2[which.max(unlist(lapply(temp.ms2.info, function(y) {
            y <- y[order(y[, 2], decreasing = TRUE), , drop = FALSE]
            if (nrow(y) > 5)
              y <- y[seq_len(5), ]
            sum(y[, 2])
          })))]))
        }
      })
    
    match.result <- do.call(rbind, match.result) %>%
      as.data.frame()
    
    colnames(match.result) <- c("Index1", "Index2")
    match.result <- data.frame(match.result,
                               variable_info$variable_id[match.result$Index1],
                               ms1.info$name[match.result$Index2],
                               stringsAsFactors = FALSE)
    
    colnames(match.result) <-
      c("Index1.ms1.data",
        "Index.ms2.spectra",
        "MS1.peak.name",
        "MS2.spectra.name")
    
    ms1.info <-
      ms1.info[unique(match.result[, 2]), , drop = FALSE]
    
    ms2.info <- ms2.info[unique(match.result[, 2])]
    
    match.result$Index.ms2.spectra <-
      match(match.result$MS2.spectra.name, ms1.info$name)
    
    ###add MS2 to object
    ms2_data =
      new(
        Class = "ms2_data",
        column = column,
        polarity = polarity,
        variable_id = match.result$MS1.peak.name,
        ms2_spectrum_id = match.result$MS2.spectra.name,
        ms2_mz = ms1.info$mz[match.result$Index.ms2.spectra],
        ms2_rt = ms1.info$rt[match.result$Index.ms2.spectra],
        ms2_file = ms1.info$file[match.result$Index.ms2.spectra],
        ms2_spectra = ms2.info[match.result$Index.ms2.spectra],
        mz_tol = ms1.ms2.match.mz.tol,
        rt_tol = ms1.ms2.match.rt.tol
      )
    
    if (length(object@ms2_data) == 0) {
      name = paste(sort(ms2_data_name), collapse = ";")
      ms2_data = list(name = ms2_data)
      names(ms2_data) = name
      object@ms2_data = ms2_data
    } else{
      name = paste(sort(ms2_data_name), collapse = ";")
      if (any(names(object@ms2_data) == name)) {
        object@ms2_data[[match(name, names(object@ms2_data))]] = ms2_data
      } else{
        object@ms2_data = c(object@ms2_data, ms2_data)
        names(object@ms2_data)[length(names(object@ms2_data))] = name
      }
    }
    
    process_info = object@process_info
    
    parameter <- new(
      Class = "tidymass_parameter",
      pacakge_name = "massdataset",
      function_name = "mutate_ms2()",
      parameter = list(
        column = column,
        polarity = polarity,
        ms1.ms2.match.mz.tol = ms1.ms2.match.mz.tol,
        ms1.ms2.match.rt.tol = ms1.ms2.match.rt.tol,
        path = path
      ),
      time = Sys.time()
    )
    
    if (all(names(process_info) != "mutate_ms2")) {
      process_info$mutate_ms2 = parameter
    } else{
      process_info$mutate_ms2 = c(process_info$mutate_ms2,
                                  parameter)
    }
    
    object@process_info = process_info
    
    return(object)
    
  }
