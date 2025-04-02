#' Create a new administration protocol
#'
#' @param name a character string representing the protocol name.
#' @param type a character string representing the protocol type. Can be one of:
#'  - oral: oral administration
#'  - ivb: intravenous bolus
#'  - iv: intravenous
#' @param interval a character string representing the administration interval. Can be one of:
#'  - single
#'  - 24
#'  - 12-12
#'  - 8-8-8
#'  - 6-6-6-6
#'  - 6-6-12
#' @param dose a numeric value representing the dose.
#' @param dose_unit a character string representing the dose unit. Default is "mg".
#' @param end_time a numeric value representing the end time of the protocol. Default is 24.
#' @param end_time_unit a character string representing the end time unit. Default is "h".
#' @param ... additional parameters that depends on the `type` of administration:
#' - for oral administrations:
#'  - water_vol_per_body_weight. Default is 3.5.
#'  - water_vol_per_body_weight_unit: Default is "ml/kg".
#' - for intravenous:
#'  - infusion_time. Default is 0.5.
#'  - infusion_time_unit. Default is "h".
#'
#' @return a Protocol object
#' @export
#' @examples
#' # Create an oral administration protocol
#' oral_protocol <- create_protocol(
#'   name = "Oral dose",
#'   type = "oral",
#'   interval = "single",
#'   dose = 500,
#'   dose_unit = "mg"
#' )
#'
#' # Create an intravenous protocol with custom infusion time
#' iv_protocol <- create_protocol(
#'   name = "IV infusion",
#'   type = "iv",
#'   interval = "12-12",
#'   dose = 250,
#'   dose_unit = "mg",
#'   infusion_time = 30,
#'   infusion_time_unit = "min"
#' )
create_protocol <- function(
  name,
  type,
  interval,
  dose,
  dose_unit = "mg",
  end_time = 24,
  end_time_unit = "h",
  ...
) {
  Protocol$new(
    name,
    type,
    interval,
    dose,
    dose_unit = dose_unit,
    end_time = end_time,
    end_time_unit = end_time_unit,
    ...
  )
}

#' Add a protocol to a snapshot
#'
#' @param snapshot a snapshot object.
#' @param protocol a protocol object created with `create_protocol()`.
#'
#' @return the updated snapshot with new protocol
#' @export
#' @examples
#' # Create a compound snapshot
#' midazolam <- compound("Midazolam")
#'
#' # Create a protocol
#' protocol <- create_protocol(
#'   name = "Standard dose",
#'   type = "oral",
#'   interval = "24",
#'   dose = 500
#' )
#'
#' # Add protocol to compound snapshot
#' midazolam <- add_protocol(midazolam, protocol)
add_protocol <- function(snapshot, protocol) {
  snapshot$add_protocol(protocol)
  invisible(snapshot)
}

#' Remove a protocol from a snapshot
#'
#' @param snapshot a snapshot object.
#' @param protocol_name a character vector of protocol name(s) to remove
#'
#' @return the updated snapshot without the specified protocols
#' @export
#' @examples
#' # Create a compound snapshot
#' midazolam <- compound("Midazolam")
#'
#' # Create and add some protocols
#' protocol1 <- create_protocol("Protocol 1", "oral", "single", 100)
#' protocol2 <- create_protocol("Protocol 2", "iv", "24", 50)
#' midazolam <- add_protocol(midazolam, protocol1)
#' midazolam <- add_protocol(midazolam, protocol2)
#'
#' # Remove a protocol from a snapshot
#' midazolam <- remove_protocol(midazolam, "Protocol 1")
#'
#' # Remove multiple protocols at once
#' midazolam <- remove_protocol(midazolam, c("Protocol 1", "Protocol 2"))
remove_protocol <- function(snapshot, protocol_name) {
  snapshot$remove_protocol(protocol_name)
  invisible(snapshot)
}


protocol_types <- list(
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
  "6-6-12" = list(
    pksim = "DI_6_6_12",
    human = "Each 6 hours then 12 hours afters"
  )
)


Protocol <- R6::R6Class(
  "Protocol",
  public = list(
    name = NULL,
    initialize = function(
      name,
      type,
      interval,
      dose,
      dose_unit = "mg",
      end_time = 24,
      end_time_unit = "h",
      ...
    ) {
      self$name <- name

      rlang::arg_match(type, values = names(protocol_types), error_arg = "type")

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
        cli_inform(c(
          "!" = "No {.code water_vol_per_body_weight} provided, using default value of 3.5 ml/kg."
        ))
        self$water_vol_per_body_weight <- 3.5
      }

      if (
        !is.null(self$water_vol_per_body_weight) &
          is.null(self$water_vol_per_body_weight_unit)
      ) {
        self$water_vol_per_body_weight_unit <- "ml/kg"
      }

      if (self$type == "iv" && is.null(self$infusion_time)) {
        cli_inform(c(
          "!" = "No {.code infusion_time} provided, using default value of 60 minutes."
        ))
        self$infusion_time <- 60
      }

      if (!is.null(self$infusion_time) & is.null(self$infusion_time_unit)) {
        self$infusion_time_unit <- "min"
      }
    },
    format_method = function(advanced = FALSE) {
      cli::cli({
        if (!advanced) cli_text(self$name)
        cli_li("Application Type: {protocol_types[[self$type]]$human}")
        if (!advanced) {
          cli_li("Dosing Interval: {intervals[[self$interval]]$human}")
        } else {
          if (!is.null(private$.formulation_key)) {
            cli_li("FormulationKey: {private$.formulation_key}")
          }
        }
        cli_li("Dose: {self$dose} {self$dose_unit}")
        if (self$interval != "single") {
          cli_li("End Time: {self$end_time} {self$end_time_unit}")
        }
        if (self$type == "oral") {
          cli_li(
            "Volume of water/body weight: {self$water_vol_per_body_weight} {self$water_vol_per_body_weight_unit}"
          )
        }
        if (self$type == "iv") {
          cli_li(
            "Infusion Time: {self$infusion_time} {self$infusion_time_unit}"
          )
        }
      })
    },
    print = function(advanced = FALSE) {
      cat(cli::cli_format_method(self$format_method(advanced)), sep = "\n")
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
    .water_vol_per_body_weight_unit = NULL,
    .formulation_key = NULL
  ),
  active = list(
    data = function() {
      data <- list(
        Name = self$name,
        ApplicationType = protocol_types[[self$type]]$pksim,
        DosingInterval = intervals[[self$interval]]$pksim,
        FormulationKey = self$formulation_key,
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
          )
        )
      )

      # don't write if default value
      if (!(self$end_time == 24 & self$end_time_unit == "h")) {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "End time",
              Value = self$end_time,
              Unit = self$end_time_unit
            )
          )
        )
      }

      # don't write if default value
      if (
        self$type == "iv" &&
          !(self$infusion_time == 60 && self$infusion_time_unit == "min")
      ) {
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
        # written even if set to default value but only if oral administration
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
      # remove FormulationKey if null
      data <- purrr::compact(data)

      return(data)
    },
    type = function(value) {
      if (!missing(value)) {
        cli_abort(c(
          "x" = "Protocol {.code type} cannot be changed, create a new one instead."
        ))
      }

      return(private$.type)
    },
    interval = function(value) {
      if (!missing(value)) {
        rlang::arg_match(
          value,
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
          cli::cli_abort(c("x" = "Dose should be numeric value."))
        }
        private$.dose <- value
      }
      return(private$.dose)
    },
    dose_unit = function(value) {
      if (!missing(value)) {
        rlang::arg_match(
          value,
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
          cli::cli_abort(c("x" = "end_time should be numeric value."))
        }
        private$.end_time <- value
      }

      return(private$.end_time)
    },
    end_time_unit = function(value) {
      if (!missing(value)) {
        rlang::arg_match(
          value,
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
          cli::cli_abort(c("x" = "infusion_time should be numeric value."))
        }
        private$.infusion_time <- value
      }

      return(private$.infusion_time)
    },
    infusion_time_unit = function(value) {
      if (!missing(value) && !is.null(value)) {
        rlang::arg_match(
          value,
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
          cli::cli_abort(c(
            "x" = "water_vol_per_body_weight should be numeric value."
          ))
        }
        private$.water_vol_per_body_weight <- value
      }

      return(private$.water_vol_per_body_weight)
    },
    water_vol_per_body_weight_unit = function(value) {
      if (!missing(value) && !is.null(value)) {
        rlang::arg_match(
          value,
          values = unlist(ospsuite::ospUnits$`Volume per body weight`),
          error_arg = "water_vol_per_body_weight_unit"
        )
        private$.water_vol_per_body_weight_unit <- value
      }

      return(private$.water_vol_per_body_weight_unit)
    },
    formulation_key = function(value) {
      if (!missing(value) && !is.null(value)) {
        if (!is.character(value)) {
          cli::cli_abort(c(
            "x" = "`formulation_key` must be a character string."
          ))
        }
        private$.formulation_key <- value
      }
      return(private$.formulation_key)
    }
  )
)

#' Create a new advanced administration protocol
#'
#' @param name a character string representing the protocol name.
#'
#' @return an AdvancedProtocol object
#' @export
#' @examples
#' # Create an advanced protocol for complex dosing regimen
#' advanced_protocol <- create_advanced_protocol("Complex dosing regimen")
create_advanced_protocol <- function(name) {
  AdvancedProtocol$new(name)
}

#' Add a schema of administration to an advanced protocol
#'
#' @description
#' Add a schema to an advanced protocol
#' @param advanced_protocol The protocol to which to add the schema
#' @param start_time Starting time of the schema
#' @param start_time_unit Time unit for `start_time` of the schema
#' @param rep_nb Number of repetitions of the schema
#' @param time_btw_rep Time between repetitions of the schema
#' @param time_btw_rep_unit Time unit for `time_btw_rep` of the schema
#' @param schema_name Name of the schema. (Optional) If not given schema name will be in the form of "Schema X"
#' @return The updated `AdvancedProtocol` object.
#' @export
#' @examples
#' # Create an advanced protocol
#' advanced_protocol <- create_advanced_protocol("Weekly dosing")
#'
#' # Add a schema for weekly administration
#' advanced_protocol <- add_schema(
#'   advanced_protocol,
#'   start_time = 0,
#'   start_time_unit = "h",
#'   rep_nb = 4,
#'   time_btw_rep = 7,
#'   time_btw_rep_unit = "day",
#'   schema_name = "Weekly dosing"
#' )
add_schema <- function(
  advanced_protocol,
  start_time,
  start_time_unit,
  rep_nb,
  time_btw_rep,
  time_btw_rep_unit,
  schema_name = NULL
) {
  # check that protocol is an AdvancedProtocol object
  check_advanced(advanced_protocol)

  advanced_protocol$add_schema(
    start_time = start_time,
    start_time_unit = start_time_unit,
    rep_nb = rep_nb,
    time_btw_rep = time_btw_rep,
    time_btw_rep_unit = time_btw_rep_unit,
    schema_name = schema_name
  )
}

#' Remove a schema of administration from an advanced protocol
#'
#' @description Remove a schema from an advanced protocol
#' @param advanced_protocol The protocol to which to remove the schema
#' @param schema_name Name of the schema to remove
#' @return The updated `AdvancedProtocol` object.
#'
#' @export
#' @examples
#' #' # Create an advanced protocol
#' advanced_protocol <- create_advanced_protocol("Weekly dosing")
#'
#' # Add a schema for weekly administration
#' advanced_protocol <- add_schema(
#'   advanced_protocol,
#'   start_time = 0,
#'   start_time_unit = "h",
#'   rep_nb = 4,
#'   time_btw_rep = 7,
#'   time_btw_rep_unit = "day",
#'   schema_name = "Weekly dosing"
#' )
#'
#' # Remove a schema from an advanced protocol
#' advanced_protocol <- remove_schema(advanced_protocol, "Weekly dosing")
remove_schema <- function(advanced_protocol, schema_name) {
  # check that protocol is an AdvancedProtocol object
  check_advanced(advanced_protocol)

  advanced_protocol$remove_schema(schema_name)
}

#' Add administration to an existing schema
#'
#' @description
#' Add an administration to an existing schema of an advanced protocol
#' @param advanced_protocol The protocol to which to add to the simple protocol to the schema `schema_name`
#' @param schema_name Name of the schema to add the protocol to
#' @param administration The protocol to add to the schema called `schema_name`
#' Must be a `Protocol` object, with a `single` dosing interval
#' @param formulation_key Formulation key for mapping to formulation for oral protocol. If NULL
#' it will be automatically assigned in the form of "Formulation X"
#' @return The updated `AdvancedProtocol` object.
#' @export
#' @examples
#' # Create an advanced protocol
#' advanced_protocol <- create_advanced_protocol("Complex regimen")
#'
#' # Add a schema
#' advanced_protocol <- add_schema(
#'   advanced_protocol,
#'   start_time = 0,
#'   start_time_unit = "h",
#'   rep_nb = 3,
#'   time_btw_rep = 24,
#'   time_btw_rep_unit = "h",
#'   schema_name = "Daily dosing"
#' )
#'
#' # Create a single dose protocol
#' single_dose <- create_protocol(
#'   name = "Morning dose",
#'   type = "oral",
#'   interval = "single",
#'   dose = 250,
#'   dose_unit = "mg"
#' )
#'
#' # Add the administration to the schema
#' advanced_protocol <- add_administration(
#'   advanced_protocol,
#'   schema_name = "Daily dosing",
#'   administration = single_dose
#' )
add_administration <- function(
  advanced_protocol,
  schema_name,
  administration,
  formulation_key = NULL
) {
  # check that protocol is an AdvancedProtocol object
  check_advanced(advanced_protocol)

  advanced_protocol$add_administration(
    administration,
    schema_name,
    formulation_key
  )
}

#' Remove administration from an existing schema
#' @description
#' Remove an administration from an existing schema of an advanced protocol
#' @param advanced_protocol The protocol to which to remove the simple protocol from the schema `schema_name`
#' @param schema_name Name of the schema to remove the protocol from
#' @param administration_name The name of the administration protocol to remove from the schema called `schema_name`
#' @return The updated `AdvancedProtocol` object.
#' @export
#' @examples
#' # Create an advanced protocol
#' advanced_protocol <- create_advanced_protocol("Complex regimen")
#'
#' # Add a schema
#' advanced_protocol <- add_schema(
#'   advanced_protocol,
#'   start_time = 0,
#'   start_time_unit = "h",
#'   rep_nb = 3,
#'   time_btw_rep = 24,
#'   time_btw_rep_unit = "h",
#'   schema_name = "Daily dosing"
#' )
#'
#' # Create and add a single dose protocol
#' morning_dose <- create_protocol(
#'   name = "Morning dose",
#'   type = "oral",
#'   interval = "single",
#'   dose = 250,
#'   dose_unit = "mg"
#' )
#'
#' # Add the administration to the schema
#' advanced_protocol <- add_administration(
#'   advanced_protocol,
#'   schema_name = "Daily dosing",
#'   administration = morning_dose
#' )
#'
#' # Remove an administration from a schema
#' advanced_protocol <- remove_administration(
#'   advanced_protocol,
#'   schema_name = "Daily dosing",
#'   administration_name = "Morning dose"
#' )
remove_administration <- function(
  advanced_protocol,
  schema_name,
  administration_name
) {
  # check that protocol is an AdvancedProtocol object
  check_advanced(advanced_protocol)

  advanced_protocol$remove_administration(
    schema_name,
    protocol_name = administration_name
  )
}

#' @noRd
AdvancedProtocol <- R6::R6Class(
  "AdvancedProtocol",
  public = list(
    #' @field name Protocol name
    name = NULL,
    #' @description
    #' Create an AdvancedProtocol object.
    #' @param name character string representing the name of the protocol
    #' @param time_unit main time_unit for the protocol
    #' @return A new `AdvancedProtocol` object.
    initialize = function(name, time_unit = NULL) {
      self$name <- name
      # set default main time unit
      if (is.null(time_unit)) {
        time_unit <- "h"
      }
      private$.time_unit <- time_unit
    },
    #' @description
    #' Add a schema of administration
    #' @param start_time Starting time of the schema
    #' @param start_time_unit Time unit for `start_time` of the schema
    #' @param rep_nb Number of repetitions of the schema
    #' @param time_btw_rep Time between repetitions of the schema
    #' @param time_btw_rep_unit Time unit for `time_btw_rep` of the schema
    #' @param schema_name Name of the schema
    #' @return The updated `AdvancedProtocol` object.
    add_schema = function(
      start_time,
      start_time_unit,
      rep_nb,
      time_btw_rep,
      time_btw_rep_unit,
      schema_name
    ) {
      # add default schema_name if not given
      if (is.null(schema_name)) {
        schema_name <- paste0("Schema ", length(self$schemas) + 1)
      }

      # ensure schema name does not exist
      if (
        schema_name %in%
          sapply(self$schemas, \(x) {
            x$Name
          })
      ) {
        cli::cli_abort(c("x" = "Schema {.var {schema_name}} already exists."))
      }
      private$.schemas <- c(
        private$.schemas,
        list(
          list(
            Name = schema_name,
            SchemaItems = list(),
            StartTime = start_time,
            StartTimeUnit = start_time_unit,
            NumberOfRepetitions = rep_nb,
            TimeBetweenRepetitions = time_btw_rep,
            TimeBetweenRepetitionsUnit = time_btw_rep_unit
          )
        )
      )
      invisible(self)
    },
    #' @description
    #' Remove a schema of administration
    #' @param schema_name Name of the schema to remove
    #' @return The updated `AdvancedProtocol` object.
    remove_schema = function(schema_name) {
      # check that schema exists
      private$.check_schema(schema_name)
      private$.schemas <- purrr::discard(private$.schemas, \(x) {
        x$Name == schema_name
      })
      invisible(self)
    },
    #' @description
    #' Add a protocol of administration to an existing schema
    #' @param protocol The administration `Protocol` to add to the schema
    #' @param schema_name Name of the schema to add the protocol to
    #' @param formulation_key Formulation key for mapping to formulation for oral protocol. If NULL
    #' it will be automatically assigned
    #' @return The updated `AdvancedProtocol` object.
    add_administration = function(
      protocol,
      schema_name,
      formulation_key = NULL
    ) {
      # check that schema exists
      private$.check_schema(schema_name)

      # check that protocol is single
      if (!("Protocol" %in% class(protocol)) || protocol$interval != "single") {
        cli::cli_abort(c(
          "x" = "Only `Protocol` objects with a `single` dose interval can be added to a schema."
        ))
      }
      # If the protocol is Oral add a formulation key (default "Formulation X"), the formulation name is not already used for a different formulation
      if (protocol$type == "oral" && is.null(formulation_key)) {
        existing_formulation_key <- unlist(
          purrr::map(private$.schemas, \(x) {
            purrr:::map(x$SchemaItems, \(y) {
              y$formulation_key
            })
          }),
          recursive = T
        )

        # take first potential formulation key
        tentative_formulation_key <- paste0(
          "Formulation ",
          1:(length(existing_formulation_key) + 1)
        )
        protocol$formulation_key <- tentative_formulation_key[which.min(
          tentative_formulation_key %in% existing_formulation_key
        )]
      } else {
        # update protocol with correct formulation key
        protocol$formulation_key <- formulation_key
      }

      # get schema index from name
      schema_index <- private$.get_schema_index(schema_name)

      if (
        protocol$name %in%
          list_c(purrr::map(
            private$.schemas[[schema_index]]$SchemaItems,
            "name"
          ))
      ) {
        # rename protocol to ensure uniqueness
        og_name <- protocol$name
        protocol$name <-
          paste0(
            protocol$name,
            " (schema item ",
            length(private$.schemas[[schema_index]]$SchemaItems) + 1,
            ")"
          )
        cli::cli_inform(c(
          "!" = "Protocol {.var {og_name}} already exists in schema {.var {schema_name}}.",
          "i" = "Renaming protocol to {.var {protocol$name}} to ensure uniqueness."
        ))
      }
      private$.schemas[[schema_index]]$SchemaItems <- c(
        private$.schemas[[schema_index]]$SchemaItems,
        protocol
      )
      invisible(self)
    },
    #' @description
    #' Remove a protocol of administration from an existing schema
    #' @param schema_name Name of the schema to remove the protocol from
    #' @param protocol The protocol to remove from the schema
    #' @return The updated `AdvancedProtocol` object.
    remove_administration = function(schema_name, protocol_name) {
      # check that schema and protocol exists
      private$.check_administration(schema_name, protocol_name)

      schema_index <- private$.get_schema_index(schema_name)

      private$.schemas[[schema_index]]$SchemaItems <-
        purrr::discard(private$.schemas[[schema_index]]$SchemaItems, \(x) {
          x$name == protocol_name
        })
      invisible(self)
    },
    #' @description
    #' Print the object to the console
    print = function() {
      cat(
        cli::cli_format_method({
          cli::cli_text(self$name)
          purrr::walk(self$schemas, \(x) {
            cli::cli_li("Schema: {x$Name}")
            ul <- cli::cli_ul()
            cli::cli_li("Start time: {x$StartTime} {x$StartTimeUnit}")
            cli::cli_li("Number of repetitions: {x$NumberOfRepetitions}")
            cli::cli_li(
              "Time between repetitions: {x$TimeBetweenRepetitions} {x$TimeBetweenRepetitionsUnit}"
            )
            purrr::imap(x$SchemaItems, \(y, j) {
              cli::cli_ol(y$name)
              ul3 <- cli::cli_ul()
              cli::cli_li(y$format_method(advanced = TRUE))
              cli::cli_end(ul3)
            })
            cli::cli_end(ul2)
          })
        }),
        sep = "\n"
      )
      invisible(self)
    }
  ),
  active = list(
    #' @field schemas List of schemas for the advanced protocol
    schemas = function(value) {
      if (missing(value)) {
        private$.schemas
      } else {
        cli_abort(c("x" = "Use dedicated functions to set schemas."))
      }
    },
    #' @field data dynamic json representation of the protocol object
    data = function() {
      data <- list(
        Name = self$name,
        DosingInterval = "Single", # administrations within a schema are always single
        Schemas = purrr::map(
          private$.schemas,
          \(x) {
            list(
              Name = x$Name,
              SchemaItems = purrr::map(
                x$SchemaItems,
                \(y) {
                  prot_data <- y$data
                  prot_data$DosingInterval <- NULL
                  # remove null field (i.e. protentially FormulationKey or DosingInterval)
                  prot_data <- purrr::compact(prot_data)
                  return(prot_data)
                }
              ),
              Parameters = list(
                list(
                  Name = "Start time",
                  Value = x$StartTime,
                  Unit = x$StartTimeUnit
                ),
                list(
                  Name = "NumberOfRepetitions",
                  Value = x$NumberOfRepetitions
                ),
                list(
                  Name = "TimeBetweenRepetitions",
                  Value = x$TimeBetweenRepetitions,
                  Unit = x$TimeBetweenRepetitionsUnit
                )
              )
            )
          }
        ),
        TimeUnit = private$.time_unit
      )
      return(data)
    }
  ),
  private = list(
    .name = NULL,
    .time_unit = NULL,
    .schemas = NULL,
    # check if schema exist in advanced protocol object
    .check_schema = function(schema_name) {
      if (
        !any(
          sapply(private$.schemas, \(x) {
            x$Name
          }) ==
            schema_name
        )
      ) {
        cli::cli_abort(c("x" = "Could not find schema {.var {schema_name}}."))
      }
    },
    # check if administration exist in schema
    .check_administration = function(schema_name, protocol_name) {
      private$.check_schema(schema_name)
      if (
        !any(
          sapply(
            private$.schemas[[private$.get_schema_index(
              schema_name
            )]]$SchemaItems,
            \(x) {
              x$name
            }
          ) ==
            protocol_name
        )
      ) {
        cli::cli_abort(c(
          "x" = "Could not find protocol {.var {protocol_name}} in schema {.var {schema_name}}."
        ))
      }
    },
    # get schema index from name
    .get_schema_index = function(schema_name) {
      private$.check_schema(schema_name)
      return(which(
        sapply(private$.schemas, \(x) {
          x$Name
        }) ==
          schema_name
      ))
    }
  )
)

protocol_from_data <- function(protocol_data) {
  name <- protocol_data$Name
  # If the imported file contains an advanced protocol
  if (!is.null(protocol_data$Schemas)) {
    protocol <- AdvancedProtocol$new(
      name = name,
      time_unit = protocol_data$TimeUnit
    )
    for (schema in protocol_data$Schemas) {
      start_time_data <- purrr::keep(
        schema$Parameters,
        ~ .x$Name == "Start time"
      )
      start_time_value <- purrr::pluck(start_time_data, 1, "Value")
      start_time_unit <- purrr::pluck(start_time_data, 1, "Unit")

      rep_nb_data <- purrr::keep(
        schema$Parameters,
        ~ .x$Name == "NumberOfRepetitions"
      )
      rep_nb_value <- purrr::pluck(rep_nb_data, 1, "Value")

      time_btw_rep_data <- purrr::keep(
        schema$Parameters,
        ~ .x$Name == "TimeBetweenRepetitions"
      )
      time_btw_rep_value <- purrr::pluck(time_btw_rep_data, 1, "Value")
      time_btw_rep_unit <- purrr::pluck(time_btw_rep_data, 1, "Unit")

      protocol$add_schema(
        start_time = start_time_value,
        start_time_unit = start_time_unit,
        rep_nb = rep_nb_value,
        time_btw_rep = time_btw_rep_value,
        time_btw_rep_unit = time_btw_rep_unit,
        schema_name = schema$Name
      )

      for (schema_item in schema$SchemaItems) {
        # add single dosing interval to Schema item to be able to reuse the protocol_from_data function
        schema_item$DosingInterval <- "Single"
        key <- schema_item$FormulationKey
        protocol$add_administration(
          protocol = protocol_from_data(schema_item),
          schema_name = schema$Name,
          formulation_key = key
        )
      }
    }
  } else {
    # Otherwise, it is a simple protocol
    type <- protocol_data$ApplicationType
    interval <- protocol_data$DosingInterval

    start_time_data <- purrr::keep(
      protocol_data$Parameters,
      ~ .x$Name == "Start time"
    )
    start_time_value <- purrr::pluck(start_time_data, 1, "Value")
    start_time_unit <- purrr::pluck(start_time_data, 1, "Unit")

    dose_data <- purrr::keep(protocol_data$Parameters, ~ .x$Name == "InputDose")
    dose_value <- purrr::pluck(dose_data, 1, "Value")
    dose_unit <- purrr::pluck(dose_data, 1, "Unit")

    end_time_data <- purrr::keep(
      protocol_data$Parameters,
      ~ .x$Name == "End time"
    )
    end_time_value <- purrr::pluck(end_time_data, 1, "Value")
    end_time_unit <- purrr::pluck(end_time_data, 1, "Unit")

    water_vol_per_body_weight_data <- purrr::keep(
      protocol_data$Parameters,
      ~ .x$Name == "Volume of water/body weight"
    )
    water_vol_per_body_weight_value <- purrr::pluck(
      water_vol_per_body_weight_data,
      1,
      "Value"
    )
    water_vol_per_body_weight_unit <- purrr::pluck(
      water_vol_per_body_weight_data,
      1,
      "Unit"
    )

    infusion_time_data <- purrr::keep(
      protocol_data$Parameters,
      ~ .x$Name == "Infusion time"
    )
    infusion_time_value <- purrr::pluck(infusion_time_data, 1, "Value")
    infusion_time_unit <- purrr::pluck(infusion_time_data, 1, "Unit")

    protocol <- Protocol$new(
      name = name,
      type = names(keep(protocol_types, ~ .x$pksim == type)),
      interval = names(keep(intervals, ~ .x$pksim == interval)),
      start_time = start_time_value,
      start_time_unit = start_time_unit,
      dose = dose_value,
      dose_unit = dose_unit,
      end_time = end_time_value %||% 24,
      end_time_unit = end_time_unit %||% "h",
      infusion_time = infusion_time_value,
      infusion_time_unit = infusion_time_unit,
      water_vol_per_body_weight = water_vol_per_body_weight_value,
      water_vol_per_body_weight_unit = water_vol_per_body_weight_unit
    )
  }

  return(protocol)
}

check_advanced <- function(protocol) {
  if (!("AdvancedProtocol" %in% class(protocol))) {
    cli::cli_abort(c("x" = "protocol must be and `AdvancedProtocol` object."))
  }
}
