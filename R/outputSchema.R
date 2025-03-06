#' R6 Class Representing a Snapshot Output Schema
#'
#' @description
#' This class is used to create the json corresponding to a simulation output schema snapshot
#' @examples
#' # Create a new output schema
#' schema <- SnapshotOutputSchema$new()
#'
#' # Print the default schema
#' schema$print()
#'
#' # Clear all intervals
#' schema$clear()
#'
#' # Add a high-resolution interval for the first hour
#' schema$add_interval(0, 1, 60, "h")
#'
#' # Add another interval with lower resolution
#' schema$add_interval(1, 24, 10, "h")
#'
#' # Set a single interval (replaces all existing intervals)
#' schema$set_interval(0, 48, 6, "h")
#'
#' # Access the intervals data
#' intervals <- schema$intervals
#'
#' # Get the JSON representation
#' json_data <- schema$data
SnapshotOutputSchema <- R6::R6Class(
  "SnapshotOutputSchema",
  cloneable = FALSE,
  active = list(
    #' @field intervals All intervals defined in the schema (Read-Only)
    intervals = function(value) {
      if (missing(value)) {
        return(private$.intervals)
      } else {
        private$.intervals <- value
      }
    },
    #' @field data dynamic json representation of the output schema object
    data = function() {
      data <- lapply(self$intervals, \(x) {
        list(
          Parameters = list(
            list(
              Name = "Start time",
              Value = x$start_time,
              Unit = x$unit
            ),
            list(
              Name = "End time",
              Value = x$end_time,
              Unit = x$unit
            ),
            list(
              Name = "Resolution",
              Value = x$resolution,
              Unit = paste0("pts/",x$unit)
            )
          )
        )
      })
      return(data)
    }
  ),
  public = list(
    #' @description
    #' Clears all intervals
    clear = function() {
      private$.intervals <- list()
      invisible(self)
    },
    #' @description
    #' Adds an interval to the schema
    #' @param start_time Start time for the interval in `unit`
    #' @param end_time End time for the interval in `unit`
    #' @param resolution resolution in points per `unit`
    #' @param unit time unit for the interval
    add_interval = function(start_time, end_time, resolution, unit = "h") {
      if (!is.numeric(c(start_time, end_time, resolution))) {
        cli::cli_abort("`start_time`, `end_time` and `resolution` must be numeric.")
      }
      if (!(unit %in% ospsuite::getUnitsForDimension("Time"))) {
        cli::cli_abort("`unit` must be a valid time unit.")
      }

      # add interval
      self$intervals <- c(
        self$intervals,
        list(
          list(
            start_time = start_time,
            end_time = end_time,
            resolution = resolution,
            unit = unit
          )
        )
      )
      invisible(self)
    },
    #' @description
    #' Clear any previously existing intervals and set a new one
    #' @param ... Same parameters as add_interval
    set_interval = function(...) {
      self$clear()
      self$add_interval(...)
    },
    #' @description
    #' Print the object to the console
    print = function() {
      cli::cli_text("Output schema: ")
      for (i in seq_along(self$intervals)) {
        cli::cli_li(paste0("Interval ", i))
        ul <- cli::cli_ul()
        cli::cli_li(paste0("Start time: ", self$intervals[[i]]$start_time, " ", self$intervals[[i]]$unit))
        cli::cli_li(paste0("End time: ", self$intervals[[i]]$end_time, " ", self$intervals[[i]]$unit))
        cli::cli_li(paste0("Resolution: ", self$intervals[[i]]$resolution, " pts/", self$intervals[[i]]$unit))
        cli::cli_end(ul)
      }
      invisible(self)
    }
  ),
  private = list(
    .intervals = list(list(start_time = 0, end_time = 24, resolution = 4, unit = "h"))
  )
)
