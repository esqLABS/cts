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
    #' @description
    #' Create a Snapshot object.
    #' @param input character string that is wether
    #' - a compound name from the list of available compounds `list_compounds()`.
    #' - a URL to a compound building block.
    #' - a Path to a local file.
    #' OR an R list containing snapshot data
    #' @return A new `Snapshot` object.
    initialize = function(input) {
      if (is.character(input)) {
        self$source <- get_source(input)
        self$source_data <- private$read_json(self$source)
      } else if (is.list(input)) {
        self$source <- "R list"
        self$source_data <- input
      } else {
        cli_abort(
          message = c(
            x = "Invalid input type.",
            i = "Please provide a valid compound name, URL, path to a local file, or an R list."
          )
        )
      }
      self$version <- self$source_data$Version
      self$compounds <- self$source_data$Compounds
      self$individuals <- self$source_data$Individuals
      self$populations <- self$source_data$Populations
      self$formulations <- purrr::map(
        self$source_data$Formulations,
        formulation_from_data
      )
      self$protocols <- purrr::map(
        self$source_data$Protocols,
        protocol_from_data
      )
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
      cat(
        cli::cli_format_method({
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
        }),
        sep = "\n"
      )
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
      list_c(map(self[[field]], "Name")) %||% list_c(map(self[[field]], "name"))
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
    #' add a formulation to the snapshot.
    #' @param formulation the formulation object to add
    add_formulation = function(formulation) {
      private$add_item("formulations", formulation)
    },
    #' @description
    #' remove a formulation from the snapshot.
    #' @param formulation_name name(s) of the formulation(s) to remove
    remove_formulation = function(formulation_name) {
      private$remove_item("formulations", formulation_name)
    },
    #' @description
    #' add an observed dataset to the snapshot.
    #' @param observed_data the observed data set to add
    add_observed_data = function(observed_data) {
      private$add_item("observed_data", observed_data)
    },
    #' @description
    #' remove an observed dataset from the snapshot.
    #' @param observed_data_name name(s) of the observed dataset(s) to remove
    remove_observed_data = function(observed_data_name) {
      private$remove_item("observed_data", observed_data_name)
    },
    #' @description
    #' add a simulation to the snapshot.
    #' @param simulation the simulation to add
    add_simulation = function(simulation) {
      private$add_item("simulations", simulation)
    },
    #' @description
    #' remove a simulation from the snapshot.
    #' @param simulation_name name(s) of the simulation(s) to remove
    remove_simulation = function(simulation_name) {
      private$remove_item("simulations", simulation_name)
    },
    #' @description
    #' check that a simulation is valid
    #' @param simulation simulation object to check for validity
    check_simulation = function(simulation) {
      # check that no simulation has the same name
      if (simulation$name %in% self$get_names("simulations")) {
        cli_abort(
          "Simulation with name {.code {simulation$name}} already exists."
        )
      }
      # check that compounds are defined
      sim_compounds <- purrr::list_c(purrr::map(
        simulation$compounds,
        ~ .x$Name
      ))
      missing_compounds <- !(sim_compounds %in% self$get_names("compounds"))
      if (any(missing_compounds)) {
        cli_abort(
          "Compounds {.code {sim_compounds[missing_compounds]}} not found in snapshot."
        )
      }
      # check that individual or population is defined
      if (length(simulation$individual) > 0) {
        if (!(simulation$individual %in% self$get_names("individuals"))) {
          cli_abort(
            "Individual {.code {simulation$individual}} not found in snapshot."
          )
        }
      } else if (length(simulation$population) > 0) {
        if (!(simulation$population %in% self$get_names("populations"))) {
          cli_abort(
            "Population {.code {simulation$population}} not found in snapshot."
          )
        }
      } else {
        cli_abort("No individual or population defined in simulation.")
      }
      # check that protocols are defined
      sim_protocols <- purrr::list_c(purrr::map(
        simulation$compounds,
        ~ .x$Protocol$Name
      ))

      if (!all(sim_protocols %in% self$get_names("protocols"))) {
        missing_protocols <- sim_protocols[
          !(sim_protocols %in% self$get_names("protocols"))
        ]
        cli_abort(
          "Protocols {.code {missing_protocols}} not found in snapshot."
        )
      }
      # check that formulations are defined
      sim_formulations <- purrr:::list_c(purrr::map(
        simulation$compounds,
        ~ purrr::list_c(purrr::map(.x$Protocol$Formulations, ~ .x$Name))
      ))
      if (!all(sim_formulations %in% self$get_names("formulations"))) {
        missing_formulations <- sim_formulations[
          !(sim_formulations %in% self$get_names("formulations"))
        ]
        cli_abort(
          "Formulations {.code {missing_formulations}} not found in snapshot."
        )
      }

      # check that correct number of formulations key-name mapping are defined
      for (protocolIdx in seq_along(purrr::compact(purrr::map(
        simulation$compounds,
        ~ .x$Protocol
      )))) {
        protocol_name <- purrr::map(simulation$compounds, ~ .x$Protocol$Name)[[
          protocolIdx
        ]]
        given_formulation_keys <- purrr::list_c(purrr::map(
          purrr::map(simulation$compounds, ~ .x$Protocol)[[
            protocolIdx
          ]]$Formulations,
          ~ (.x$Key)
        ))

        snap_protocol <- self$protocols[[which(
          self$get_names("protocols") == protocol_name
        )]]
        needed_formulation_keys <- c()

        if ("Protocol" %in% class(snap_protocol)) {
          # For simple protocol with oral or user defined administration, simulation
          # need a `Formulation` key but key is not explicitly defined in the protocol
          if (snap_protocol$type %in% c("oral", "user")) {
            needed_formulation_keys <- c("Formulation")
          }
        } else if ("AdvancedProtocol" %in% class(snap_protocol)) {
          # For advanced protocol look at all defined formulation keys
          needed_formulation_keys <- unique(
            unlist(
              purrr::map(snap_protocol$schemas, \(x) {
                purrr::map(x$SchemaItems, \(y) {
                  y$formulation_key
                })
              }),
              recursive = TRUE
            )
          )
        }

        # Check that all needed key are given
        if (!all(needed_formulation_keys %in% given_formulation_keys)) {
          missing_formulation_keys <- needed_formulation_keys[
            !needed_formulation_keys %in% given_formulation_keys
          ]
          cli_abort(
            "Missing formulation key(s) {.code {missing_formulation_keys}} for protocol {.code {protocol_name}}."
          )
        }
      }
    },
    #' @description
    #' run simulations defined in the snapshot
    #' @param path character string that is the path to the output directory.
    #' @param exportPKML logical that indicates if the PKML files should be exported.
    run_simulations = function(path = NULL, exportPKML = FALSE) {
      # create a temporary directory
      temp_dir <- tempfile()
      dir.create(temp_dir)

      # remove PI that could make import fail if some simulation or data have been removed
      snap_wo_pi <- self$data
      snap_wo_pi[["ParameterIdentifications"]] <- NULL

      # write $data to a temporary file
      temp_file <- tempfile(fileext = ".json", tmpdir = temp_dir)
      temp_file_name <- basename(fs::path_ext_remove(temp_file))
      private$write_json(snap_wo_pi, temp_file)
      # run simulations
      ospsuite::runSimulationsFromSnapshot(
        temp_file,
        output = temp_dir,
        exportCSV = TRUE,
        exportPKML = TRUE
      )

      # recreate simulation results objects
      sim_results_files <- list.files(
        temp_dir,
        pattern = glue("{temp_file_name}-.*-Results\\.csv$")
      )
      sim_names <- gsub(glue("{temp_file_name}-"), "", sim_results_files) %>%
        gsub(glue("-Results"), "", .) %>%
        fs::path_ext_remove()

      results_obj <- results_tibble <- vector("list", length(sim_results_files))
      names(results_obj) <- names(results_tibble) <- sim_names

      for (i in seq_along(sim_results_files)) {
        sim_name <- sim_names[i]
        simulation <- ospsuite::loadSimulation(file.path(
          temp_dir,
          glue(temp_file_name, "-", sim_name, ".pkml")
        ))
        results_obj[[sim_name]] <- ospsuite::importResultsFromCSV(
          simulation,
          file.path(temp_dir, sim_results_files[i])
        )
        results_tibble[[
          sim_name
        ]] <- ospsuite::simulationResultsToTibble(results_obj[[sim_name]])
      }

      private$.sim_results_obj <- results_obj
      private$.sim_results <- results_tibble

      if (!is.null(path)) {
        # copy simulation results and pkml to the output directory
        fs::file_copy(fs::path(temp_dir, sim_results_files), path)
        if (exportPKML) {
          fs::file_copy(
            list.files(temp_dir, pattern = ".pkml$", full.names = T),
            path
          )
        }
      }
    },
    #' @description
    #' run simulations defined in the snapshot
    #' @param path character string to the folder where to export pk analysis as csv file
    run_pk_analysis = function(path = NULL) {
      if (is.null(private$.sim_results)) {
        cli::cli_alert_info(
          "DDI simulations results were not found. Running them."
        )
        self$run_simulations()
      }

      # validate object, should be a list of SimulationResults
      lapply(
        private$.sim_results_obj,
        ospsuite.utils::validateIsOfType,
        type = "SimulationResults"
      )

      # run PK analysis
      pk_analysis <- lapply(
        private$.sim_results_obj,
        ospsuite::calculatePKAnalyses
      )
      private$.pk_analysis_results_raw <- lapply(
        pk_analysis,
        ospsuite::pkAnalysesToTibble
      )

      compound_names <- self$get_names("compounds")

      # PK analysis results to wider
      private$.pk_analysis_results <- lapply(
        private$.pk_analysis_results_raw,
        pivot_pk_analysis,
        compound_names
      )

      if (!is.null(path)) {
        # create a directory if it does not exist
        if (!fs::dir_exists(path)) {
          fs::dir_create(path)
        }
        for (i in seq_len(length(pk_analysis))) {
          ospsuite::exportPKAnalysesToCSV(
            pkAnalyses = pk_analysis[[i]],
            filePath = file.path(
              path,
              glue("{names(pk_analysis)[i]}", "-PKAnalysis.csv")
            )
          )
        }
      }
    },
    #' Plot Time profile of DDI simulations defined in the ddi project
    #' @param ... additional arguments to pass to the plotPopulationTimeProfile (for example aggregation method)
    #' @return a list of plots
    create_plots = function(...) {
      simulationNames <- self$get_names("simulations")

      # initializes plots
      plotLists <- vector("list", length(simulationNames))
      names(plotLists) <- simulationNames

      if (is.null(self$simulation_results)) {
        self$run_simulations()
      }

      individualTimeProfileConfiguration <- ospsuite::DefaultPlotConfiguration$new()
      individualTimeProfileConfiguration$yAxisScale <- "log"
      individualTimeProfileConfiguration$legendPosition <- "outsideTopRight"

      for (simulationIdx in seq_along(simulationNames)) {
        simulationName <- simulationNames[simulationIdx]

        # get all paths
        paths <- purrr::map_chr(
          private$.sim_results_obj[[
            simulationName
          ]]$simulation$outputSelections$allOutputs,
          ~ .x$path
        )

        # Plot cannot contain two different dimension on one axis. The code below
        # separates the paths by dimension and creates a plot for each dimension.

        # get dimensions of each path
        quantities <- ospsuite::getAllQuantitiesMatching(
          paths = paths,
          container = private$.sim_results_obj[[simulationName]]$simulation
        )
        dimensions <- purrr::map(quantities, "dimension") %>% list_c()
        names(dimensions) <- purrr::map(quantities, "path") %>% list_c()

        # initialize one plot per dimension
        plotLists[[simulationName]] <- vector(
          "list",
          length(unique(dimensions))
        )
        names(plotLists[[simulationName]]) <- unique(dimensions)

        for (dimension in unique(dimensions)) {
          dataCombined <- ospsuite::DataCombined$new()
          dataCombined$addSimulationResults(
            simulationResults = private$.sim_results_obj[[simulationName]],
            quantitiesOrPaths = names(dimensions)[dimensions == dimension]
          )

          # add observed data if linked to the simulation
          if (!is.null(self$simulations[[simulationIdx]]$ObservedData)) {
            for (obs_data_name in unlist(self$simulations[[simulationIdx]]$ObservedData)){
              obs_data <- self$observed_data[[which(self$get_names("observed_data") == obs_data_name)]]

              # need to convert json as loaded slightly differently in osp.snapshots
              obs_data_snap <- jsonlite::fromJSON(
                jsonlite::toJSON(obs_data, digits = NA, auto_unbox = TRUE),
                simplifyVector = TRUE,
                simplifyDataFrame = FALSE
              )

              # check for compatible y dimension first
              if (obs_data_snap$Columns[[1]]$Dimension != dimension) {
                comp_dim <- tryCatch(
                  expr = ospsuite::toUnit(
                    quantityOrDimension = dimension,
                    values = obs_data_snap$Columns[[1]]$Values,
                    targetUnit = ospsuite::getBaseUnit(quantityOrDimension = dimension),
                    sourceUnit = obs_data_snap$Columns[[1]]$Unit,
                    molWeight = obs_data_snap$Columns[[1]]$DataInfo$MolWeight
                  ),
                  error=function(e) {return(NULL)}
                )

                if (is.null(comp_dim)) {
                  next()
                }
              }

              dts <- osp.snapshots::loadDataSetFromSnapshot(obs_data_snap)
              dataCombined$addDataSets(dts)
            }
          }

          if (
            length(
              private$.sim_results_obj[[simulationName]]$allIndividualIds
            ) >
              1
          ) {
            plotLists[[simulationName]][[
              dimension
            ]] <- ospsuite::plotPopulationTimeProfile(
              dataCombined = dataCombined,
              defaultPlotConfiguration = individualTimeProfileConfiguration,
              ...
            )
          } else {
            plotLists[[simulationName]][[
              dimension
            ]] <- ospsuite::plotIndividualTimeProfile(
              dataCombined,
              individualTimeProfileConfiguration
            )
          }
        }
      }

      private$.plots <- plotLists
    }
  ),
  private = list(
    print_names = function(field) {
      names <- self$get_names(field)
      cli_text(
        snakecase::to_title_case(field),
        ":",
        if (length(names) == 0) {
          " None"
        }
      )
      if (length(names) > 0) {
        cli_ul(names)
      }
    },
    read_json = function(source) {
      jsonlite::fromJSON(
        source,
        simplifyDataFrame = FALSE,
        simplifyVector = FALSE
      )
    },
    write_json = function(data, path) {
      jsonlite::write_json(
        data,
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
      if (target %in% c("protocols", "formulations")) {
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
    .sim_results = NULL,
    .sim_results_obj = NULL,
    .pk_analysis_results = NULL,
    .pk_analysis_results_raw = NULL,
    .plots = NULL
  ),
  active = list(
    #' @field data dynamic json representation of the snapshot object
    data = function() {
      data <- self$source_data

      data[["Version"]] <- self$version
      data[["Compounds"]] <- self$compounds
      data[["Individuals"]] <- self$individuals
      data[["Populations"]] <- self$populations
      data[["Formulations"]] <- purrr::map(self$formulations, ~ .x$data)
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
        private$.sim_results <- NULL
        private$.sim_results_obj <- NULL
        private$.pk_analysis_results <- NULL
        private$.plots <- NULL
        private$.simulations <- value
      }
      return(private$.simulations)
    },
    #' @field observed_data Access the observed data.
    observed_data = function(value) {
      if (!missing(value)) {
        private$.observed_data <- value
      }
      return(private$.observed_data)
    },
    #' @field simulation_results Access the simulations results.
    simulation_results = function() {
      if (is.null(private$.sim_results)) {
        self$run_simulations()
      }
      return(private$.sim_results)
    },
    #' @field pk_analysis_results Formatted pk-analyses results of the simulations
    pk_analysis_results = function() {
      if (is.null(private$.pk_analysis_results)) {
        self$run_pk_analysis()
      }
      return(private$.pk_analysis_results)
    },
    #' @field plots Access plots for snapshot simulations.
    plots = function() {
      if (is.null(private$.plots)) {
        self$create_plots()
      }
      return(private$.plots)
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
    cli_abort(
      message = c(
        x = "Invalid input type.",
        i = "Please provide a valid compound name, URL or path to a local file."
      )
    )
  }
  return(source)
}


update_snapshots <- function(snapshots) {
  temp_dir_in <- tempfile()
  dir.create(temp_dir_in)

  temp_dir_out <- tempfile()
  dir.create(temp_dir_out)

  # export snapshot to temp_dir_in to ensure even snasphot from url get converted
  map(to_list(snapshots), ~ .x$export(path = tempfile(tmpdir = temp_dir_in, fileext = ".json")))

  suppressMessages({
    # Convert snapshot to project to upgrade them to latest version
    ospsuite::convertSnapshot(
      temp_dir_in,
      format = "project",
      output = temp_dir_out,
      runSimulations = FALSE
    )

    # Convert back to snapshot to get json format
    ospsuite::convertSnapshot(
      temp_dir_out,
      format = "snapshot",
      output = temp_dir_out
    )
  })

  # Create Snapshots/Compounds objects from new jsons.
  snapshots <- map(
    list.files(temp_dir_out, pattern = ".json", full.names = TRUE),
    ~ Compound$new(input = .x)
  )
  if (length(snapshots) == 1) {
    return(snapshots[[1]])
  } else {
    return(snapshots)
  }
}

#' @title Extract defined interactions for compounds from a snapshot
#' @param snapshot A snapshot object.
#' @param compounds (Optional) A character vector of compound names to extract interactions for.
#' By default interactions are extracted for all compounds in the snapshot
#' @param quietly (Optional) Logical. If TRUE, the interactions are not printed to the console.
#' @export
extract_interactions <- function(snapshot, compounds = NULL, quietly = FALSE) {
  if (is.null(compounds)) {
    compounds <- snapshot$get_names("compounds")
  }

  all_interactions <- list()
  i <- 1
  # in each compound
  for (c in snapshot$compounds) {
    if (c$Name %in% compounds) {
      # in each process
      for (p in c$Processes) {
        # if InternalName of process is "CompetitiveInhibition" or "Induction"
        if (
          stringr::str_detect(string = p$InternalName, pattern = "Inhibition") |
            p$InternalName == "Induction"
        ) {
          all_interactions[[i]] <- list(
            Name = glue::glue("{p$Molecule}-{p$DataSource}"),
            MoleculeName = p$Molecule,
            CompoundName = c$Name
          )
          i <- i + 1
        }
      }
    }
  }

  if (!quietly) {
    for (c in compounds) {
      cli::cli_text("Compound: {c}")
      purrr::map(
        all_interactions,
        ~ if (.x$CompoundName == c) {
          cli::cli_ul(.x$Name)
        }
      )
    }
  }
  return(invisible(all_interactions))
}

#' @title Extract defined processes for compounds from a snapshot
#' @param snapshot A snapshot object.
#' @param compounds (Optional) A character vector of compound names to extract processes for.
#' By default processes are extracted for all compounds in the snapshot
#' @param quietly (Optional) Logical. If TRUE, the processes are not printed to the console.
#' @export
extract_processes <- function(snapshot, compounds = NULL, quietly = FALSE) {
  if (is.null(compounds)) {
    compounds <- snapshot$get_names("compounds")
  }

  all_processes <- vector(mode = "list", length = length(compounds))
  names(all_processes) <- compounds

  for (compound in compounds) {
    all_processes[[compound]] <- list()
    i <- 1

    for (p in snapshot$compounds[[which(
      snapshot$get_names("compounds") == compound
    )]]$Processes) {
      if (
        p$InternalName %in%
          c(
            "LiverClearance",
            "HepatocytesHalfTime",
            "HepatocytesRes",
            "LiverMicrosomeHalfTime",
            "LiverMicrosomeRes"
          )
      ) {
        all_processes[[compound]][[i]] <- list(
          Name = glue::glue("Total Hepatic Clearance-{p$DataSource}"),
          SystemicProcessType = "Hepatic"
        )
      } else if (
        p$InternalName %in%
          c(
            "KidneyClearance",
            "TubularSecretion_FirstOrder",
            "TubularSecretion_MM"
          )
      ) {
        all_processes[[compound]][[i]] <- list(
          Name = glue::glue("Renal Clearances-{p$DataSource}"),
          SystemicProcessType = "Renal"
        )
      } else if (p$InternalName == "GlomerularFiltration") {
        all_processes[[compound]][[i]] <- list(
          Name = glue::glue("Glomerular Filtration-{p$DataSource}"),
          SystemicProcessType = "GFR"
        )
      } else if (p$InternalName == "BiliaryClearance") {
        all_processes[[compound]][[i]] <- list(
          Name = glue::glue("Biliary Clearance-{p$DataSource}"),
          SystemicProcessType = "Biliary"
        )
      } else if (
        !is.null(p$Molecule) &&
          !(stringr::str_detect(
            string = p$InternalName,
            pattern = "Inhibition"
          ) |
            p$InternalName == "Induction")
      ) {
        all_processes[[compound]][[i]] <- list(
          Name = glue::glue("{p$Molecule}-{p$DataSource}"),
          MoleculeName = p$Molecule
        )
      }
      i <- length(all_processes[[compound]]) + 1
    }
  }

  if (!quietly) {
    for (c in compounds) {
      cli::cli_text("Compound: {c}")
      purrr::map(
        all_processes[[c]],
        ~ cli::cli_ul(.x$Name)
      )
    }
  }
  return(invisible(all_processes))
}
