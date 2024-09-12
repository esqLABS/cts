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

import_ddi <- function(input) {
  ddi <- DDI$new()
  ddi$import(input = input)
  ddi
}

DDI <- R6::R6Class(
  classname = "DDI",
  class = TRUE,
  inherit = Snapshot,
  public = list(
    data = NULL,
    source = NULL,
    initialize = function() {
      self$source <- NULL
      self$data <- list()
    },
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
    import = function(input) {
      self$source <- private$get_source(input)
      self$data <- jsonlite::fromJSON(self$source, simplifyDataFrame = FALSE, simplifyVector = FALSE, )
    }
  ),
  private = list(),
  active = list()
)
