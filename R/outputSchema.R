#' R6 Class Representing a Snapshot Output Schema
#'
#' @description
#' This class is used to create the json corresponding to a simulation output schema snapshot
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
              Unit = paste0("pts/", x$unit)
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
    #' @param unit time unit for the interval. Should be one of ospsuite::ospUnits$Time.
    add_interval = function(start_time, end_time, resolution, unit = "h") {
      if (!is.numeric(c(start_time, end_time, resolution))) {
        cli::cli_abort(
          "`start_time`, `end_time` and `resolution` must be numeric."
        )
      }
      if (!(unit %in% ospsuite::getUnitsForDimension("Time"))) {
        cli::cli_abort(
          "`unit` must be a valid time unit. See `ospsuite::ospUnits$Time` for available units."
        )
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
      purrr::iwalk(self$intervals, function(interval, i) {
        cli::cli_li("Interval {i}")
        ul <- cli::cli_ul()
        cli::cli_li(
          "Start time: {interval$start_time} {interval$unit}"
        )
        cli::cli_li(
          "End time: {interval$end_time} {interval$unit}"
        )
        cli::cli_li(
          "Resolution: {interval$resolution} pts/{interval$unit}"
        )
        cli::cli_end(ul)
      })
      invisible(self)
    }
  ),
  private = list(
    .intervals = list(list(
      start_time = 0,
      end_time = 24,
      resolution = 4,
      unit = "h"
    ))
  )
)
