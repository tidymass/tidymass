install_tidymass <-
  function(packages = c("core", "all"),
           which_package,
           from = c("gitlab", "github", "gitee", "shen", "tidymass.org"),
           method = c("auto", "internal", "libcurl",
                      "wget", "curl")) {
    # if (!require(remotes)) {
    #   install.packages("remotes")
    # }
    
    packages <- match.arg(packages)
    from <- match.arg(from)
    method <- match.arg(method)
    
    temp_path <- tempdir()
    dir.create(temp_path, showWarnings = FALSE, recursive = TRUE)
    unlink(x = file.path(temp_path, dir(temp_path)),
           recursive = TRUE,
           force = TRUE)
    
    if (from == "gitee") {
      file <-
        read.table(
          "https://gitee.com/tidymass/packages_repo/raw/main/packages/file.csv",
          sep = ",",
          header = TRUE
        )
    }
    
    if (from == "gitlab") {
      file <-
        read.table(
          "https://gitlab.com/tidymass/packages_repo/-/raw/main/packages/file.csv",
          sep = ",",
          header = TRUE
        )
    }
    
    if (from == "github") {
      file <-
        read.table(
          "https://raw.githubusercontent.com/tidymass/packages_repo/main/packages/file.csv",
          sep = ",",
          header = TRUE
        )
    }
    
    if (from == "shen") {
      utils::download.file(
        url = "https://scpa.netlify.app/tidymass/file.csv",
        destfile = file.path(temp_path, "file.csv"),
        method = method
      )
      file <-
        read.table(file.path(temp_path, "file.csv"),
                   sep = ",",
                   header = TRUE)
    }
    
    if (from == "tidymass.org") {
      utils::download.file(
        url = "https://www.tidymass.org/tidymass-packages/file.csv",
        destfile = file.path(temp_path, "file.csv"),
        method = method
      )
      file <-
        read.table(file.path(temp_path, "file.csv"),
                   sep = ",",
                   header = TRUE)
    }
    
    ####package list
    core_package_list <-
      c(
        "masstools",
        "massdataset",
        "metid",
        "massstat",
        "massqc",
        "massprocesser",
        "masscleaner",
        "metpath",
        "tidymass"
      )
    
    if (!missing(which_package)) {
      package_list <-
        which_package
    } else{
      if (packages == "core") {
        package_list <-
          core_package_list
      } else{
        package_list <-
          c(core_package_list,
            "massconverter",
            "massdatabase")
      }
    }
    
    ####download the packages
    for (x in package_list) {
      message("Download ", x, "...")
      ##install masstools first
      if (from == "github") {
        url <-
          paste0(
            "https://github.com/tidymass/packages_repo/raw/main/packages/",
            file$file_name.y[file$package == x]
          )
      }
      
      if (from == "gitlab") {
        url <-
          paste0(
            "https://gitlab.com/tidymass/packages_repo/-/raw/main/packages/",
            file$file_name.y[file$package == x],
            "?inline=false"
          )
      }
      
      if (from == "gitee") {
        url <-
          paste0(
            "https://gitee.com/tidymass/packages_repo/raw/main/packages/",
            file$file_name.y[file$package == x]
          )
      }
      
      if (from == "shen") {
        url <-
          paste0("https://scpa.netlify.app/tidymass/",
                 file$file_name.y[file$package == x])
      }
      
      if (from == "tidymass.org") {
        url <-
          paste0("https://www.tidymass.org/tidymass-packages/",
                 file$file_name.y[file$package == x])
      }
      
      utils::download.file(
        url = url,
        destfile = file.path(temp_path, file$file_name.y[file$package == x]),
        method = method
      )
    }
    
    
    ####install package
    for (x in package_list) {
      message("Install ", x, "...")
      ##install masstools first
      
      tryCatch(
        detach(name = paste0("package:", x)),
        error = function(e) {
          message(x, " is not loaded")
        }
      )
      
      if (x == "tidymass") {
        # detach("package:purrr")
        # detach("package:stringr")
        # install.packages("purrr")
        # install.packages("stringr")
        
        install.packages(
          file.path(temp_path, file$file_name.y[file$package == x]),
          repos = NULL,
          dependencies = TRUE
        )
      } else{
        install.packages(
          file.path(temp_path, file$file_name.y[file$package == x]),
          repos = NULL,
          dependencies = TRUE
        )
        
        remotes::install_deps(
          pkgdir = file.path(temp_path, file$file_name.y[file$package == x]),
          dependencies = TRUE,
          upgrade = "never"
        )
      }
      unlink(file.path(temp_path, file$file_name.y[file$package == x]))
    }
    
    message("All done.")
  }
