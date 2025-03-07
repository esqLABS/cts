#' Create a Drug-Drug Interaction (DDI) Simulation
#'
#' This function creates a DDI simulation by combining a main compound (victim)
#' with one or more additional compounds (perpetrators).
#'
#' @param victim The main compound in the DDI interaction, created by `compound()`,
#'  mandatory.
#' @param ... Additional `Compounds` objects to be added as perpetrators in the
#' DDI interaction,
#'
#' @param options a named list of options to customize the DDI simulation. Default is to use `default_options`.
#'   - import_simulations: logical, whether to import the simulations from the victim and perpetrators. default is FALSE.
#'   - create_ddi_simulation: logical, whether to create a generic simulation template. default is TRUE.
#'      generic simulation will use:
#'        - the first compound defined as perpetrator,
#'        - the first protocol of the victim and perpetrator compounds,
#'        - the first formulation of the victim and perpetrator compounds,
#'        - the first individual defined in victim compounds.
#'
#' @return a Drug-Drug Interaction (DDI) simulation object
#' @export
#'
#' @examples
#' # Create compounds
#' midazolam <- compound("Midazolam")
#' itraconazole <- compound("Itraconazole")
#'
#' # Create a basic DDI simulation
#' ddi <- create_ddi(victim = midazolam, itraconazole)
#'
#' # Create a DDI with custom options
#' ddi_custom <- create_ddi(
#'   victim = midazolam,
#'   itraconazole,
#'   options = list(
#'     import_simulations = TRUE,
#'     create_ddi_simulation = FALSE
#'   )
#' )
#'
#' # Create a DDI with multiple perpetrators
#' rifampicin <- compound("Rifampicin")
#'
#' \dontrun{
#' ddi_multi <- create_ddi(victim = midazolam, itraconazole, rifampicin)
#' }
create_ddi <- function(victim, ..., options = NULL) {
  if (is.null(victim)) {
    cli::cli_abort("At least one victim compound must be provided.")
  }

  perpetrators <- c(...)

  if (length(perpetrators) == 0) {
    cli::cli_abort("At least one perpetrator compound must be provided.")
  }
  if (length(to_list(victim)) > 1) {
    cli::cli_abort("Please provide exactly one victim compound.")
  }

  ddi <- DDI$new(victim = victim, perpetrators, options = options)

  ddi
}

#' Import Drug-Drug Interaction (DDI) Simulation from Snapshot
#'
#' @inheritParams get_source
#'
#' @return a DDI object
#' @export
#'
#' @examples
#' \dontrun{
#' import_ddi("Rifampicin-Midazolam-DDI.json")
#' }
import_ddi <- function(input) {
  ddi <- DDI$new(file = input)
  ddi
}

#' Export Drug-Drug Interaction (DDI) Simulation to Snapshot
#' @param ddi a DDI object
#' @param path a character string that is the path to the snapshot
#' @export
#' @examples
#' # Create compounds
#' midazolam <- compound("Midazolam")
#' rifampicin <- compound("Rifampicin")
#' 
#' # Create a DDI simulation
#' ddi <- create_ddi(victim = midazolam, rifampicin)
#' 
#' # Export to a temporary file
#' temp_file <- tempfile(fileext = ".json")
#' export_ddi(ddi, temp_file)
#' 
#' # Verify the file was created
#' file.exists(temp_file)
export_ddi <- function(ddi, path) {
  path <- with_json_suffix(path)
  ddi$export(path)
}

#' Run Drug-Drug Interaction (DDI) Simulations defined in the ddi project
#' @param ddi a DDI object
#' @param path a character string representing the path to where to save
#' simulations results. Default is NULL. If not NULL, will save the simulation
#' results as .csv files at provided location.
#' @param exportPKML logical. Whether to export the PKML files. Default is FALSE.
#' @export
#' @examples
#' # Create compounds
#' midazolam <- compound("Midazolam")
#' itraconazole <- compound("Itraconazole")
#'
#' # Create a DDI simulation
#' ddi <- create_ddi(victim = midazolam, itraconazole)
#'
#' # Run simulations without saving results
#' results <- run_ddi(ddi)
#'
#' # Run simulations and save results to a directory
#' results <- run_ddi(ddi, path = "simulation_results")
#'
#' # Run simulations and export PKML files
#' results <- run_ddi(ddi, path = "simulation_results", exportPKML = TRUE)
run_ddi <- function(ddi, path = NULL, exportPKML = FALSE) {
  ddi$run_simulations(path, exportPKML)
  return(ddi$simulation_results)
}

#' Run Pk-Analysis for DDI simulations defined in the ddi project
#' @param ddi a DDI object
#' @param path a character string representing the path to where to save
#' pk analysis results. Default is NULL. If not NULL, will save the pk analysis
#' results as .csv files at provided location.
#' @export
#' @examples
#' # Create compounds
#' midazolam <- compound("Midazolam")
#' rifampicin <- compound("Rifampicin")
#' 
#' # Create a DDI simulation
#' ddi <- create_ddi(victim = midazolam, rifampicin)
#'
#' # Run PK analysis without saving results
#' pk_results <- run_pk_analysis(ddi)
#'
#' # Run PK analysis and save results to a directory
#' pk_results <- run_pk_analysis(ddi, path = "pk_analysis_results")
run_pk_analysis <- function(ddi, path = NULL) {
  ddi$run_pk_analysis(path)
  return(ddi$pk_analysis_results)
}

#' Plot DDI simulations defined in the ddi project
#' @param ddi a DDI object
#' @param simulationNames a character vector of simulation names for which to generate plots.
#' Default is NULL, i.e. plots will be generated for all simulations.
#' @param ... additional arguments to pass to the plotPopulationTimeProfile (for example aggregation method)
#' @return a list of plots
#' @export
#' @examples
#' # Create compounds 
#' midazolam <- compound("Midazolam")
#' rifampicin <- compound("Rifampicin")
#' 
#' # Create a DDI simulation
#' ddi <- create_ddi(victim = midazolam, rifampicin)
#' 
#' # Plot all simulation results
#' plots <- plot_ddi_results(ddi)
#'
#' # Plot specific simulations
#' plots <- plot_ddi_results(ddi, simulationNames = c("Midazolam_alone", "DDI_simulation"))
plot_ddi_results <- function(ddi, simulationNames = NULL, ...) {

  ddi$create_plots(...)
  # By default return all simulations plots
  if (is.null(simulationNames)) {
    return(ddi$plots)
  } else {
    if (any(!simulationNames %in% ddi$get_names("simulations"))) {
      cli::cli_alert_warning("Some simulation names are not found in the DDI project. Returning only found simulations.")
    }
    return(purrr::compact(ddi$plots[simulationNames]))
  }
}

#' R6 Class Representing a DDI Snapshot
#'
#' @description
#' A snapshot is a JSON file that contains all the information about a model.
#' This class is used to import, access and manipulate the data from a DDI snapshot.
DDI <- R6::R6Class(
  classname = "DDI",
  class = TRUE,
  inherit = Snapshot,
  public = list(
    #' @field options options to customize the DDI simulation. see `create_ddi()`.
    options = NULL,
    #' @field metadata a list to store information useful for developers.
    metadata = NULL,

    #' @description
    #' Create a DDI object.
    #' @param victim a `Compound` object representing the victim compound.
    #' @param ... a list of `Compound` objects representing the perpetrator compounds.
    #' @param file a character string representing the path to the snapshot file to import.
    #' @param options a named list of options to customize the DDI simulation. Default is to use `default_options`.
    #' @return A new `DDI` object.
    initialize = function(victim=NULL, ..., file = NULL, options = NULL) {
      self$source <- NULL

      self$metadata <- list()
      if (!is.null(options)) {
        private$validate_options(options)
        self$options <- modifyList(default_options, options)
      } else {
        self$options <- default_options
      }

      if (!missing(victim) && !missing(file)) {
        cli::cli_abort("Please provide either compounds or file, not both.")
      }

      if (!is.null(victim)) {
        do.call(what = private$combine, c(victim, ...))
      }

      if (!is.null(file)) {
        private$import(file)
      }
    },
    #' @description
    #' Nicely print the DDI object.
    print = function() {
      if (is.null(self$source)) {
        cli::cli_abort("DDI have not been initialized. Use {.code create_ddi()} or {.code import_ddi()} to create a DDI object.")
      }

      compound_names <- suppressMessages(self$compoundsNames)

      cli_text("DDI project containing:")
      cli::cli_text("{.strong Victim compound:}")
      cli::cli_li(self$victim)
      cli::cli_text("{.strong Perpetrator {qty(self$perpetrators)}compound{?s}:}")
      cli::cli_li(self$perpetrators)
      cli::cli_text("{.strong {qty(self$simulations)}Simulation{?s}:}")
      cli::cli_li(self$get_names("simulations"))
      invisible(self)
    }
  ),
  private = list(
    # Validate options
    validate_options = function(options) {
      # check option is a list
      if (!is.list(options)) {
        cli::cli_abort("Options must be a named list. see")
      }

      # check options is supported
      if (!all(names(options) %in% names(default_options))) {
        unsuported_options <- names(options)[!names(options) %in% names(default_options)]
        cli_abort("Unsupported options found: {unsuported_options}")
      }

      # check options types
      types_comparison <- list_c(purrr::imap(options, ~ typeof(.x) == typeof(default_options[[.y]])))
      if (!all(types_comparison)) {
        for (i in seq_along(types_comparison)) {
          cli::cli_alert_danger("Option {names(options)[i]} must be of type {typeof(default_options[[i]])}.")
        }
        cli::cli_abort("Some options have invalid types.")
      }
    },
    # Validate that all inputs are of class 'Compound'
    # @param compounds A list of compound objects to validate.
    validate_compounds = function(compounds) {
      is_compound <- vapply(
        compounds, \(comp) inherits(comp, "Compound"), logical(1)
      )

      if (!all(is_compound)) {
        invalid_indices <- which(!is_compound)
        invalid_classes <- vapply(compounds[invalid_indices], class, character(1))

        invalid_details <- paste0("[", invalid_indices, "] ", invalid_classes)
        cli::cli_abort(c(
          "All compounds must be of class 'Compound'. Invalid entries found at position(s):",
          invalid_details
        ))
      }
    },
    # Combine multiple compounds into a DDI simulation.
    # @param ... a set of compounds created by `compound()`
    combine = function(...) {
      self$source <- "Merge"

      snapshots <- list(...)

      # Validate that all inputs are of class 'Compound'
      private$validate_compounds(snapshots)

      snapshot_versions <- list_c(map(snapshots, ~ .x$data$Version))

      # If Snapshots have different versions
      if (length(unique(snapshot_versions)) > 1) {
        cli_process_start("Multiple versions detected. Converting to the latest version.")

        snapshots <- update_snapshots(snapshots)
      }

      self$version <- unique(map_int(snapshots, ~ .x$version))

      self$metadata$protocols$victim <- snapshots[[1]]$get_names("protocols")
      self$metadata$protocols$perpetrators <- list_c(purrr::map(snapshots[-1], ~ .x$get_names("protocols")))
      self$metadata$formulations$victim <- snapshots[[1]]$get_names("formulations")
      self$metadata$formulations$perpetrators <- list_c(purrr::map(snapshots[-1], ~ .x$get_names("formulations")))

      sections_to_merge <- c(
        "compounds",
        "individuals",
        "populations",
        "formulations",
        "protocols",
        "expression_profiles",
        "observer_sets",
        "events",
        "observed_data"
      )
      if (self$options$import_simulations) {
        sections_to_merge <- c(sections_to_merge, "simulations")
      }

      walk(sections_to_merge, function(s) {
        # Merge all elements in section
        section_merged <- list_flatten(
          map(snapshots, ~ .x[[s]])
        )
        # Remove NULL elements
        section_non_null <- keep(section_merged, ~ !is.null(.x))

        # Detect duplicated Named element and remove them except first occurence
        names <- list_c(map(section_non_null, "Name"))
        duplicated <- names[duplicated(names)]
        n_duplicated <- length(duplicated)
        if (length(duplicated) > 0) {
          cli_warn(c(
            "!" = "{n_duplicated} duplicated name{?s} found in {s}: {duplicated}",
            "i" = "Keeping only the first element for each duplicated name."
          ))
          section_unique <- keep(section_non_null, !duplicated(names))
        } else {
          section_unique <- section_non_null
        }

        self[[s]] <- section_unique
      })

      if (self$options$create_ddi_simulation) {
        # Set simulated time to maximum protocol duration + 1 day
        protocols <- purrr::keep(self$protocols, ~ .x$name %in% c(self$metadata$protocols$victim[1], self$metadata$protocols$perpetrators[1]))
        max_protocol_duration <- c(0)
        for (p in protocols) {
          # transform protocol duration in seconds
          protocol_duration <- p$end_time * translate_end_time_unit(p$end_time_unit)
          if (protocol_duration == max(max_protocol_duration, protocol_duration)) {
            max_protocol_duration <- protocol_duration
          }
        }
        max_protocol_duration <- max_protocol_duration + 86400


        # Add generic ddi simulation
        generic_simulation <-
          create_generic_simulation(self,
            system.file("extdata", "generic_simulation_template.json", package = "cts"),
            max_protocol_duration = max_protocol_duration,
            victim = self$victim,
            perpetrator = self$perpetrators[1],
            victim_formulation = self$metadata$formulations$victim[1],
            perpetrator_formulation = self$metadata$formulations$perpetrators[1],
            victim_protocol = self$metadata$protocols$victim[1],
            perpetrator_protocol = self$metadata$protocols$perpetrators[1],
            individual = self$individuals[[1]]$Name
          )

        self$add_simulation(generic_simulation[[1]])
      }
    },
    # Import a DDI simulation from a JSON file.
    # @param input character string that is wether
    # - a compound name from the list of available compounds `list_compounds()`.
    # - a URL to a compound building block.
    # - a Path to a local file.
    import = function(input) {
      self$source <- get_source(input)
      # initialize from parent
      super$initialize(input)
      # self$data <- private$read_json(self$source)
    }
  ),
  active = list(
    #' @field victim returns the victim compound of the ddi project
    victim = function() {
      self$get_names("compounds")[1]
    },
    #' @field perpetrators returns the names of all perpetrators compounds of the ddi project
    perpetrators = function() {
      self$get_names("compounds")[-1]
    }
  )
)

default_options <-
  list(
    import_simulations = FALSE,
    create_ddi_simulation = TRUE
  )
