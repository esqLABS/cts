Protocol <- R6::R6Class("Protocol",
  public = list(
    name = NULL,
    initialize = function(name, type, interval,
                          dose, dose_unit = "mg",
                          end_time = 24, end_time_unit = "h",
                          ...) {
      self$name <- name

      rlang::arg_match(type,
        values = names(types),
        error_arg = "type"
      )

      private$.type <- type

      self$interval <- interval
      self$dose <- dose
      self$dose_unit <- dose_unit
      self$end_time <- end_time
      self$end_time_unit <- end_time_unit

      additional_args <- list(...)

      self$infusion_time <- additional_args$infusion_time
      self$infusion_time_unit <- additional_args$infusion_time_unit

      self$water_vol_per_body_weight <- additional_args$water_vol_per_body_weight
      self$water_vol_per_body_weight_unit <- additional_args$water_vol_per_body_weight_unit

      if (self$type == "oral" && is.null(self$water_vol_per_body_weight)) {
        cli_warn("No {.code water_vol_per_body_weight} provided, using default value of 3.5 ml/kg.")
        self$water_vol_per_body_weight <- 3.5
        self$water_vol_per_body_weight_unit <- "ml/kg"
      }

      if (self$type == "iv" && is.null(self$infusion_time)) {
        cli_warn("No {.code infusion_time} provided, using default value of 60 minutes.")
        self$infusion_time <- 60
        self$infusion_time_unit <- "min"
      }
    },
    print = function() {
      cli_text(self$name)
      cli_li("Application Type: {types[[self$type]]$human}")
      cli_li("Dosing Interval: {intervals[[self$interval]]$human}")
      cli_li("Dose: {self$dose} {self$dose_unit}")
      cli_li("End Time: {self$end_time} {self$end_time_unit}")
      if (self$type == "oral") {
        cli_li("Volume of water/body weight: {self$water_vol_per_body_weight} {self$water_vol_per_body_weight_unit}")
      }
      if (self$type == "iv") {
        cli_li("Infusion Time: {self$infusion_time} {self$infusion_time_unit}")
      }
      invisible(self)
    }
  ),
  private = list(
    .type = NULL,
    .interval = NULL,
    .dose = NULL,
    .dose_unit = NULL,
    .end_time = NULL,
    .end_time_unit = NULL,
    .infusion_time = NULL,
    .infusion_time_unit = NULL,
    .water_vol_per_body_weight = NULL,
    .water_vol_per_body_weight_unit = NULL
  ),
  active = list(
    data = function() {
      data <- list(
        Name = self$name,
        ApplicationType = types[[self$type]]$pksim,
        DosingInterval = intervals[[self$interval]]$pksim,
        Parameters = list(
          list(
            Name = "Start time",
            Value = 0,
            Unit = "h"
          ),
          list(
            Name = "InputDose",
            Value = self$dose,
            Unit = self$dose_unit
          ),
          list(
            Name = "End time",
            Value = self$end_time,
            Unit = self$end_time_unit
          )
        )
      )

      if (self$type == "iv") {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "Infusion time",
              Value = self$infusion_time,
              Unit = self$infusion_time_unit
            )
          )
        )
      }

      if (self$type == "oral") {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "Volume of water/body weight",
              Value = self$water_vol_per_body_weight,
              Unit = self$water_vol_per_body_weight_unit
            )
          )
        )
      }
      return(data)
    },
    type = function(value) {
      if (!missing(value)) {
        cli_abort("Protocol {.code type} cannot be changed, create a new one instead.")
      }

      return(private$.type)
    },
    interval = function(value) {
      if (!missing(value)) {
        rlang::arg_match(value,
          values = names(intervals),
          error_arg = "interval"
        )
        private$.interval <- value
      }

      return(private$.interval)
    },
    dose = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort("Dose should be numeric value.")
        }
        private$.dose <- value
      }
      return(private$.dose)
    },
    dose_unit = function(value) {
      if (!missing(value)) {
        rlang::arg_match(value,
          values = c("mg", "mg/kg", "mg/m²"),
          error_arg = "dose_unit"
        )

        private$.dose_unit <- value
      }

      return(private$.dose_unit)
    },
    end_time = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort("end_time should be numeric value.")
        }
        private$.end_time <- value
      }

      return(private$.end_time)
    },
    end_time_unit = function(value) {
      if (!missing(value)) {
        rlang::arg_match(value,
          values = unlist(ospsuite::ospUnits$Time),
          error_arg = "end_time_unit"
        )
        private$.end_time_unit <- value
      }

      return(private$.end_time_unit)
    },
    infusion_time = function(value) {
      if (!missing(value) && !is.null(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort("infusion_time should be numeric value.")
        }
        private$.infusion_time <- value
      }

      return(private$.infusion_time)
    },
    infusion_time_unit = function(value) {
      if (!missing(value) && !is.null(value)) {
        rlang::arg_match(value,
          values = unlist(ospsuite::ospUnits$Time),
          error_arg = "infusion_time_unit"
        )
        private$.infusion_time_unit <- value
      }

      return(private$.infusion_time_unit)
    },
    water_vol_per_body_weight = function(value) {
      if (!missing(value) && !is.null(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort("water_vol_per_body_weight should be numeric value.")
        }
        private$.water_vol_per_body_weight <- value
      }

      return(private$.water_vol_per_body_weight)
    },
    water_vol_per_body_weight_unit = function(value) {
      if (!missing(value) && !is.null(value)) {
        rlang::arg_match(value,
          values = unlist(ospsuite::ospUnits$`Volume per body weight`),
          error_arg = "water_vol_per_body_weight_unit"
        )
        private$.water_vol_per_body_weight_unit <- value
      }

      return(private$.water_vol_per_body_weight_unit)
    }
  )
)

AdvancedProtocol <- R6::R6Class("AdvancedProtocol",
  public = list(
    data = NULL,
    name = NULL,
    initialize = function(data) {
      self$data <- data
      self$name <- data$Name
    },
    print = function() {
      cli_text("Advanced Protocol: {self$name}")
      cli_text("Print no supported")
    }
  ),
  private = list(),
  active = list()
)

types <- list(
  "oral" = list(pksim = "Oral", human = "Oral"),
  "ivb" = list(pksim = "IntravenousBolus", human = "Intravenous Bolus"),
  "iv" = list(pksim = "Intravenous", human = "Intravenous")
)


intervals <- list(
  "single" = list(pksim = "Single", human = "Single Dose"),
  "24" = list(pksim = "DI_24", human = "Once each 24 hours"),
  "12-12" = list(pksim = "DI_12_12", human = "Each 12 hours"),
  "8-8-8" = list(pksim = "DI_8_8_8", human = "Each 8 hours"),
  "6-6-6-6" = list(pksim = "DI_6_6_6_6", human = "Each 6 hours"),
  "6-6-12" = list(pksim = "DI_6_6_12", human = "Each 6 hours then 12 hours afters")
)

protocol_from_data <- function(protocol_data) {
  name <- protocol_data$Name

  if (!is.null(protocol_data$Schemas)) {
    # cli_warn("Advanced protocol are not fully supported")
    return(AdvancedProtocol$new(data = protocol_data))
  }

  type <- protocol_data$ApplicationType
  interval <- protocol_data$DosingInterval

  start_time_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "Start time")
  start_time_value <- purrr::pluck(start_time_data, 1, "Value")
  start_time_unit <- purrr::pluck(start_time_data, 1, "Unit")

  dose_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "InputDose")
  dose_value <- purrr::pluck(dose_data, 1, "Value")
  dose_unit <- purrr::pluck(dose_data, 1, "Unit")

  end_time_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "End time")
  end_time_value <- purrr::pluck(end_time_data, 1, "Value")
  end_time_unit <- purrr::pluck(end_time_data, 1, "Unit")

  water_vol_per_body_weight_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "Volume of water/body weight")
  water_vol_per_body_weight_value <- purrr::pluck(water_vol_per_body_weight_data, 1, "Value")
  water_vol_per_body_weight_unit <- purrr::pluck(water_vol_per_body_weight_data, 1, "Unit")


  infusion_time_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "Infusion time")
  infusion_time_value <- purrr::pluck(infusion_time_data, 1, "Value")
  infusion_time_unit <- purrr::pluck(infusion_time_data, 1, "Unit")

  return(
    Protocol$new(
      name = name,
      type = names(keep(types, ~ .x$pksim == type)),
      interval = names(keep(intervals, ~ .x$pksim == interval)),
      start_time = start_time_value, start_time_unit = start_time_unit,
      dose = dose_value, dose_unit = dose_unit,
      end_time = end_time_value %||% 24, end_time_unit = end_time_unit %||% "h",
      infusion_time = infusion_time_value, infusion_time_unit = infusion_time_unit,
      water_vol_per_body_weight = water_vol_per_body_weight_value,
      water_vol_per_body_weight_unit = water_vol_per_body_weight_unit
    )
  )
}

create_protocol <- function(name, type, interval,
                            dose, dose_unit = "mg",
                            end_time = 24, end_time_unit = "h",
                            ...) {
  Protocol$new(name, type, interval,
    dose,
    dose_unit = dose_unit,
    end_time = end_time, end_time_unit = end_time_unit,
    ...
  )
}
