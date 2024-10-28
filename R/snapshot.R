#' R6 Class Representing a Snapshot
#'
#' @description
#' A snapshot is a JSON file that contains all the information about a model.
#' This class is used to import, access and manipulate the data from a snapshot.
Snapshot <- R6::R6Class(
  classname = "Snapshot",
  class = TRUE,
  public = list(
    #' @field source The source of the snapshot (local file, url, ...)
    source = NULL,
    #' @field source_data The input data of the snapshot
    source_data = NULL,
    #' @field version version The version of the snapshot
    version = NULL,
    #' @field simulations_results The simulation results of the snapshot
    simulations_results = NULL,
    #' @field pk_analysis_results The pk-analyses results of the simulations
    pk_analysis_results = NULL,
    #' @description
    #' Create a Snapshot object.
    #' @param input character string that is wether
    #' - a compound name from the list of available compounds `list_compounds()`.
    #' - a URL to a compound building block.
    #' - a Path to a local file.
    #' @return A new `Snapshot` object.
    initialize = function(input) {
      self$source <- get_source(input)
      self$source_data <- private$read_json(self$source)
      self$version <- self$source_data$Version
      self$compounds <- self$source_data$Compounds
      self$individuals <- self$source_data$Individuals
      self$populations <- self$source_data$Populations
      self$formulations <- self$source_data$Formulations
      self$protocols <-
        purrr::map(self$source_data$Protocols, protocol_from_data)
      self$expression_profiles <- self$source_data$ExpressionProfiles
      self$observer_sets <- self$source_data$ObserverSets
      self$events <- self$source_data$Events
      self$simulations <- self$source_data$Simulations
      self$observed_data <- self$source_data$ObservedData
      invisible(self)
    },
    #' @description
    #' Pretty print the snapshot data.
    print = function() {
      compounds <- cli_ul()
      private$print_names("compounds")
      individuals <- cli_ul()
      private$print_names("individuals")
      populations <- cli_ul()
      private$print_names("populations")
      formulations <- cli_ul()
      private$print_names("formulations")
      protocols <- cli_ul()
      private$print_names("protocols")
      observerSets <- cli_ul()
      private$print_names("observer_sets")
      events <- cli_ul()
      private$print_names("events")
      simulations <- cli_ul()
      private$print_names("simulations")
      observedData <- cli_ul()
      private$print_names("observed_data")
      invisible(self)
    },
    #' @description
    #' Export a DDI simulation to a JSON file.
    #' @param path character string that is the path to the output file.
    export = function(path) {
      private$write_json(self$data, path)
    },
    #' @description
    #' get_names the names of a field in the snapshot.
    #' @param field the field to get the names from.
    get_names = function(field) {
      list_c(map(self[[field]], ~ .x$Name)) %||% list_c(map(self[[field]], "name"))
    },
    #' @description
    #' add a protocol to the snapshot.
    #' @param protocol the protocol object to add
    add_protocol = function(protocol) {
      private$add_item("protocols", protocol)
    },
    #' @description
    #' remove a protocol from the snapshot.
    #' @param protocol_name name(s) of the protocol(s) to remove
    remove_protocol = function(protocol_name) {
      private$remove_item("protocols", protocol_name)
    },
    #' @description
    #' run simulations defined in the snapshot
    #' @param path character string that is the path to the output directory.
    #' @param exportPKML logical that indicates if the PKML files should be exported.
    run_simulations = function(path = NULL, exportPKML = FALSE) {
      # create a temporary directory
      temp_dir <- tempfile()
      dir.create(temp_dir)
      # write $data to a temporary file
      temp_file <- tempfile(fileext = ".json", tmpdir = temp_dir)
      temp_file_name <- basename(fs::path_ext_remove(temp_file))
      private$write_json(self$data, temp_file)
      # run simulations
      ospsuite::runSimulationsFromSnapshot(temp_file,
        output = temp_dir,
        exportCSV = TRUE,
        exportPKML = TRUE
      )

      # recreate simulation results objects
      sim_results_files <- list.files(temp_dir, pattern = glue("{temp_file_name}-.*\\.csv$"))
      sim_names <- gsub(glue("{temp_file_name}-"), "", sim_results_files) %>%
        gsub(glue("-Results"), "", .) %>%
        fs::path_ext_remove()

      results_obj <- results_tibble <- vector("list", length(sim_results_files))
      names(results_obj) <- names(results_tibble) <- sim_names

      for (i in seq_along(sim_results_files)) {
        sim_name <- sim_names[i]
        simulation <- ospsuite::loadSimulation(file.path(temp_dir, glue(temp_file_name, "-", sim_name, ".pkml")))
        results_obj[[sim_name]] <- ospsuite::importResultsFromCSV(simulation, file.path(temp_dir, sim_results_files[i]))
        results_tibble[[sim_name]] <- ospsuite::simulationResultsToTibble(results_obj[[sim_name]])
      }

      private$.simulations_results <- results_obj
      self$simulations_results <- results_tibble

      if (!is.null(path)) {
        # copy simulation results and pkml to the output directory
        fs::file_copy(fs::path(temp_dir, sim_results_files), path)
        if (exportPKML) {
          fs::file_copy(list.files(temp_dir, pattern = ".pkml$", full.names = T), path)
        }
      }
    },
    #' @description
    #' run simulations defined in the snapshot
    #' @param path character string to where to export pk analysis as csv file
    run_pk_analysis = function(path = NULL) {
      if (is.null(private$.simulations_results)) {
        cli::cli_alert_info("DDI simulations results were not found. Running them.")
        self$run_simulations()
      }

      # validate object, should be a list of SimulationResults
      lapply(private$.simulations_results, ospsuite.utils::validateIsOfType, type = "SimulationResults")

      # run PK analysis
      pk_analysis <- lapply(private$.simulations_results, ospsuite::calculatePKAnalyses)
      self$pk_analysis_results <- lapply(pk_analysis, ospsuite::pkAnalysesToTibble)

      if (!is.null(path)) {
        for (i in seq_len(length(pk_analysis))) {
          ospsuite::exportPKAnalysesToCSV(
            pkAnalyses = pk_analysis[[i]],
            filePath = file.path(path, glue("{names(pk_analysis)[i]}", "-PKAnalysis.csv"))
          )
        }
      }
    },
    #' Plot Time profile of DDI simulations defined in the ddi project
    #' @return a list of plots
    plot_ind_time_profile = function() {
      simulationNames <- self$get_names("simulations")

      # initializes plots
      plotLists <- vector("list", length(simulationNames))
      names(plotLists) <- simulationNames

      if (is.null(private$.simulations_results)) {
        cli::cli_abort(c("x" = "Simulations results not found. Make sure simulations have been run."))
      }

      for (simulationName in simulationNames) {
        # get all paths
        paths <- purrr::map_chr(
          private$.simulations_results[[simulationName]]$simulation$outputSelections$allOutputs,
          ~ .x$path
        )

        # get dimension for each path
        dimensions <- sapply(
          ospsuite::getAllQuantitiesMatching(
            paths = paths,
            container = private$.simulations_results[[simulationName]]$simulation
          ),
          \(x){res <- x$dimension; names(res) <- x$path; return(res)}
        )

        # initialize one plot per dimension
        plotLists[[simulationName]] <- vector("list", length(unique(dimensions)))
        names(plotLists[[simulationName]]) <- unique(dimensions)

        for (dimension in unique(dimensions)) {
          dataCombined <- ospsuite::DataCombined$new()
          dataCombined$addSimulationResults(
            simulationResults = private$.simulations_results[[simulationName]],
            quantitiesOrPaths = names(dimensions)[dimensions == dimension]
          )

          plotLists[[simulationName]][[dimension]] <- ospsuite::plotIndividualTimeProfile(dataCombined)
        }
      }
      private$.plots_ind_time_profile <- plotLists
    }
  ),
  private = list(
    print_names = function(field) {
      names <- self$get_names(field)
      cli_text(snakecase::to_title_case(field), ":", if (length(names) == 0) {
        " None"
      })
      if (length(names) > 0) {
        cli_ul(names)
      }
    },
    read_json = function(source) {
      jsonlite::fromJSON(source,
        simplifyDataFrame = FALSE,
        simplifyVector = FALSE
      )
    },
    write_json = function(data, path) {
      jsonlite::write_json(data,
        path = path,
        pretty = TRUE,
        auto_unbox = TRUE,
        digits = NA
      )
    },
    add_item = function(target, item) {
      self[[target]] <- c(self[[target]], list(item))
    },
    remove_item = function(target, name) {
      if (target == "protocols") {
        self[[target]] <- purrr::discard(self[[target]], ~ .x$name %in% name)
      } else {
        self[[target]] <- purrr::discard(self[[target]], ~ .x$Name %in% name)
      }
    },
    .compounds = NULL,
    .individuals = NULL,
    .populations = NULL,
    .formulations = NULL,
    .protocols = NULL,
    .expression_profiles = NULL,
    .observer_sets = NULL,
    .events = NULL,
    .simulations = NULL,
    .observed_data = NULL,
    .simulations_results = NULL,
    .plots_ind_time_profile = NULL
  ),
  active = list(
    #' @field data dynamic json representation of the snapshot object
    data = function() {
      data <- self$source_data

      data[["Version"]] <- self$version
      data[["Compounds"]] <- self$compounds
      data[["Individuals"]] <- self$individuals
      data[["Populations"]] <- self$populations
      data[["Formulations"]] <- self$formulations
      data[["Protocols"]] <- purrr::map(self$protocols, ~ .x$data)
      data[["ExpressionProfiles"]] <- self$expression_profiles
      data[["ObserverSets"]] <- self$observer_sets
      data[["Events"]] <- self$events
      data[["Simulations"]] <- self$simulations
      data[["ObservedData"]] <- self$observed_data

      return(data)
    },
    #' @field compounds Access the compounds data from the snapshot.
    compounds = function(value) {
      if (!missing(value)) {
        private$.compounds <- value
      }
      return(private$.compounds)
    },
    #' @field individuals Access the individuals data from the snapshot.
    individuals = function(value) {
      if (!missing(value)) {
        private$.individuals <- value
      }
      return(private$.individuals)
    },
    #' @field populations Access the populations data from the snapshot.
    populations = function(value) {
      if (!missing(value)) {
        private$.populations <- value
      }
      return(private$.populations)
    },
    #' @field formulations Access the formulations data from the snapshot.
    formulations = function(value) {
      if (!missing(value)) {
        private$.formulations <- value
      }
      return(private$.formulations)
    },
    #' @field protocols Access the protocols data from the snapshot.
    protocols = function(value) {
      if (!missing(value)) {
        private$.protocols <- value
      }
      return(private$.protocols)
    },
    #' @field expression_profiles Access the expression profiles data from the snapshot.
    expression_profiles = function(value) {
      if (!missing(value)) {
        private$.expression_profiles <- value
      }
      return(private$.expression_profiles)
    },
    #' @field observer_sets Access the observer sets data from the snapshot.
    observer_sets = function(value) {
      if (!missing(value)) {
        private$.observer_sets <- value
      }
      return(private$.observer_sets)
    },
    #' @field events Access the events data from the snapshot.
    events = function(value) {
      if (!missing(value)) {
        private$.events <- value
      }
      return(private$.events)
    },
    #' @field simulations Access the simulations data from the snapshot.
    simulations = function(value) {
      if (!missing(value)) {
        self$simulations_results <- NULL
        private$.simulations_results <- NULL
        self$pk_analysis_results <- NULL
        private$.simulations <- value
      }
      return(private$.simulations)
    },
    #' @field observed_data Access the observed data from the snapshot.
    observed_data = function(value) {
      if (!missing(value)) {
        private$.observed_data <- value
      }
      return(private$.observed_data)
    },
    #' @field plots Access plots for snapshot simulations.
    plots = function() {
      return(private$.plots_ind_time_profile)
    }
  )
)

#' @title Get the source file path or url from the input.
#' @description
#' Get the source file path or url from the input.
#' @param input character string that is wether
#' - a compound name from the list of available compounds `list_compounds()`.
#' - a URL to a compound building block.
#' - a Path to a local file.
#' @return The source file path or url.
get_source <- function(input) {
  if (is_file_local(input)) {
    source <- normalizePath(input)
  } else if (is_file_url(input)) {
    check_internet()

    source <- input
  } else if (input %in% list_compounds(display = FALSE)) {
    check_internet()

    source <- get_osp_model_library()[[input]]

    cli_process_start(msg = "Downloading {input} Building Block Data")
  } else {
    cli_abort(message = c(x = "Invalid input type.", i = "Please provide a valid compound name, URL or path to a local file."))
  }
  return(source)
}


update_snapshots <- function(snapshots) {
  paths <- list_c(map(to_list(snapshots), ~ .x$source))

  temp_dir <- tempfile()
  dir.create(temp_dir)

  suppressMessages({
    # Convert snapshot to project to upgrade them to latest version
    ospsuite::convertSnapshot(paths,
      format = "project",
      output = temp_dir,
      runSimulations = FALSE
    )

    # Convert back to snapshot to get json format
    ospsuite::convertSnapshot(
      temp_dir,
      format = "snapshot",
      output = temp_dir
    )
  })

  # Create Snapshots/Compounds objects from new jsons.
  snapshots <- map(
    list.files(temp_dir,
      pattern = ".json",
      full.names = TRUE
    ),
    ~ Compound$new(input = .x)
  )
  if (length(snapshots) == 1) {
    return(snapshots[[1]])
  } else {
    return(snapshots)
  }
}
