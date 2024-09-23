#' Create a Drug-Drug Interaction (DDI) Simulation
#'
#' @param victim The main compound in the DDI interaction, created by `compound()`,
#' mandatory.
#' @param ... Additional compounds (perpetrators) in the DDI interaction,
#' created by `compound()`.

#'
#' @return a Drug-Drug Interaction (DDI) simulation object
#' @export
#'
#' @examples
#' \dontrun{
#' rifampicin <- compound("Rifampicin")
#' midazolam <- compound("Midazolam")
#' create_ddi(victim = rifampicin, midazolam)
#' }
create_ddi <- function(victim, ...) {
  perpetrators <- list(...)

  if (length(perpetrators) == 0) {
    cli::cli_abort("At least one perpetrator compound must be provided.")
  }

  # validate all elements are of class 'Compound'
  compounds <- c(list(victim), perpetrators)
  is_compound <- vapply(
    compounds, \(comp) inherits(comp, "Compound"), logical(1)
  )

  if (!all(is_compound)) {
    invalid_indices <- which(!is_compound)
    invalid_classes <- vapply(compounds[invalid_indices], class, character(1))

    invalid_details <- paste0("[", invalid_indices, "] ", invalid_classes)
    cli_abort(c(
      "All compounds must be of class 'Compound'. Invalid entries found at position(s):",
      invalid_details
    ))
  }
  ddi <- DDI$new()

  do.call(ddi$combine, compounds)
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
  ddi <- DDI$new()
  ddi$import(input = input)
  ddi
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
    #' @description
    #' Create a DDI object.
    #' @return A new `DDI` object.
    initialize = function() {
      self$source <- NULL
      self$data <- list()
    },
    #' @description
    #' Combine multiple compounds into a DDI simulation.
    #' @param ... a set of compounds created by `compound()`
    combine = function(...) {
      self$source <- "Merge"

      snapshots <- list(...)

      snapshot_versions <- map(snapshots, ~ .x$data$Version) %>% list_c()

      # If Snapshots have different versions
      if (length(unique(snapshot_versions)) > 1) {
        cli_process_start("Multiple versions detected. Converting to the latest version.")

        temp_dir <- tempfile()
        dir.create(temp_dir)

        paths <- map(snapshots, ~ .x$source) %>% list_c()

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

        snapshots <- map(list.files(temp_dir, pattern = ".json", full.names = TRUE), ~ Compound$new(input = .x))
      }

      self$data$Version <- unique(map_int(snapshots, ~ .x$data$Version))

      sections_to_merge <- c(
        "Compounds",
        "Individuals",
        "Populations",
        "Formulations",
        "Protocols",
        "ExpressionProfiles",
        "ObserverSets",
        "Events",
        "Simulations",
        "ObservedData"
      )

      walk(sections_to_merge, function(s) {
        # Merge all elements in section
        section_merged <- list_flatten(
          map(snapshots, ~ .x$data[[s]])
        )

        # Remove NULL elements
        section_non_null <- keep(section_merged, ~ !is.null(.x))

        # Detect duplicated Named element and remove them except first occurence
        names <- map(section_non_null, "Name") %>% list_c()
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

        self$data[[s]] <- section_unique
      })
    },
    #' @description
    #' Import a DDI simulation from a JSON file.
    #' @param input character string that is wether
    #' - a compound name from the list of available compounds `list_compounds()`.
    #' - a URL to a compound building block.
    #' - a Path to a local file.
    import = function(input) {
      self$source <- get_source(input)
      self$data <- private$read_json(self$source)
    }
  ),
  private = list(),
  active = list()
)
