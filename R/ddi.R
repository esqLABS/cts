#' Create a Drug-Drug Interaction (DDI) Simulation
#'
#' @param ... a set of compounds created by `compound()`
#'
#' @return a Drug-Drug Interaction (DDI) simulation object
#' @export
#'
#' @examples
#' \dontrun{
#' rifampicin <- compound("Rifampicin")
#' midazolam <- compound("Midazolam")
#' create_ddi(rifampicin, midazolam)
#' }
create_ddi <- function(...) {
  ddi <- DDI$new()

  ddi$combine(...)
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
#' #' \dontrun{
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

      # Keep the highest version number
      self$data$Version <- unlist(max(map_int(list(...), ~ .x$data$Version), na.rm = TRUE))

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
          map(list(...), ~ .x$data[[s]])
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
