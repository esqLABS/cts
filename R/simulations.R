#' Add a simulation to a `Snapshot` or DDI object
#'
#' This function adds a simulation to a `Snapshot` or `DDI` object.
#' @param snapshot The `Snapshot` or `DDI` object to which the simulation will be added.
#' @param simulation `Simulation` object created by `create_simulation()`, to be added to the `Snapshot` or `DDI` object.
#'
#' @return The `Snapshot` or `DDI` object with the simulation added.
#' @export
add_simulation <- function(snapshot, simulation) {
  snapshot$check_simulation(simulation)
  snapshot$add_simulation(simulation$data)
  invisible(snapshot)
}

#' Remove simulation(s) from a `Snapshot` or `DDI` object
#'
#' This function removes a simulation from a `Snapshot` or `DDI` object.
#' @param snapshot The `Snapshot` or `DDI` object to which the simulation(s) should be removed.
#' @param simulation_names Names of the simulations to be removed from the `Snapshot` or `DDI` object
#'
#' @return The `Snapshot` or `DDI` object with the simulation(s) removed
#' @export
remove_simulation <- function(snapshot, simulation_name) {
  snapshot$remove_simulation(simulation_name)
  invisible(snapshot)
}

#' Add compound to a `Simulation` object
#'
#' This function adds a compounds to a simulation object.
#' @param simulation The `Simulation` object (as created by `create_simulation`) to which the compound should be added.
#' @param compound Name of the compound to add to the simulation
#' @param protocol Name of protocol used for `compound`.
#' @param formulation Formulation key/name mapping for the chosen protocol.
#' @return The `Simulation` object with added compound.
#' @export
add_compound <- function(simulation, compound, protocol = NULL, formulation = list()) {
  simulation$add_compound(compound, protocol, formulation)
  invisible(simulation)
}

#' Set protocol for an already used compound from a `Simulation` object
#'
#' This function set the protocol of the specified compounds.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param compound Name of the compound for which to set the protocol.
#' @param protocol Name of protocol used for `compound`.
#' @param formulation Formulation key/name mapping for the chosen protocol.
#' @return The updated `Simulation` object
#' @export
set_compound_protocol <- function(simulation, compound, protocol, formulation = list()) {
  simulation$set_compound_protocol(compound, protocol, formulation)
  invisible(simulation)
}

#' Clears the output interval from the simulation and adds a new one.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param start_time Start time of the interval in `unit`
#' @param end_time End time of the interval in `unit`
#' @param resolution resolution in points per `unit`
#' @param unit time unit for the interval.
#' @return The updated `Simulation` object.
#' @export
set_output_interval = function(simulation, start_time, end_time, resolution, unit) {
  simulation$output_schema$set_interval(start_time, end_time, resolution, unit)
  invisible(simulation)
}

#' Adds an interval to the output schema of the simulation
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param start_time Start time of the interval in `unit`
#' @param end_time End time of the interval in `unit`
#' @param resolution resolution in points per `unit`
#' @param unit time unit for the interval.
#' @return The updated `Simulation` object.
#' @export
add_output_interval = function(simulation, start_time, end_time, resolution, unit) {
  simulation$output_schema$add_interval(start_time, end_time, resolution, unit)
  invisible(simulation)
}

#' R6 Class Representing a Simulation
#'
#' @description
#' A simulation is a JSON file that contains all the information about a a simulation
#' (individual, compounds, protocols, ... used in the simulation).
#' This class is used to create the json corresponding to a simulation.
Simulation <- R6::R6Class(
  classname = "Simulation",
  public = list(
    #' @field name Name of the simulation
    name = NULL,

    #' @description
    #' Create a Simulation object.
    #' @param name character string corresponding to the simulation name.
    #' @param compounds list of compounds names used in the simulation.
    #' @param individual name of the individual used in the simulation.
    #' @return A new `Simulation` object.
    initialize = function(name, compounds = list(), individual = list()) {
      self$name <- name
      self$compounds <- compounds
      self$individual <- individual
      self$output_schema <- SnapshotOutputSchema$new()
    },

    #' @description
    #' Set the individual to be used in the simulation.
    #' @param individual name of the individual used in the simulation.
    #' @return The updated `Simulation` object.
    set_individual = function(individual) {
      self$individual <- individual
    },
    #' @description
    #' Add the compounds to be used in the simulation.
    #' @param compound name of the compound to be added in the simulation.
    #' @param protocol name of the protocol used for the compound.
    #' @param formulation oral formulation key mapping for the protocol if needed
    #' @return The updated `Simulation` object.
    add_compound = function(compound, protocol = NULL, formulation = list()) {
      if (!is.character(compound)) {
        cli_abort("`compound` must be a character.")
      }
      if (length(compound) > 1) {
        cli_abort("Compounds can only be added one at a time.")
      }
      self$compounds <- c(self$compounds, list(list(Name = compound)))
      if (!is.null(protocol)) {
        self$set_compound_protocol(compound, protocol, formulation)
      }
      invisible(self)
    },
    #' @description
    #' Set the protocol to be used in for a given compound.
    #' @param compound name of the compound for which to set the protocol.
    #' @param protocol name of the protocol used for the compound.
    #' @param formulation oral formulation key mapping for the protocol if needed,
    #' @return The updated `Simulation` object.
    set_compound_protocol = function(compound, protocol, formulation = list()) {
      if (!is.character(compound)) {
        cli_abort("`compound` must be a character.")
      }
      if (length(compound) > 1) {
        cli_abort("Protocol can only be set for a single compound at a time.")
      }

      compoundIdx <- which(purrr::list_c(purrr::map(self$compounds, ~.x$Name)) == compound)
      if (length(compoundIdx) == 0) {
        cli_abort("`compound` not found. Use `add_compound()` to add a new compound.")
      }

      self$compounds[[compoundIdx]]$Protocol <- list(Name = protocol, Formulations = formulation)
      invisible(self)
    },

    #' @description
    #' Clears the output interval from the simulation and adds a new one.
    #' @param startTime Start time of the interval in `unit`
    #' @param endTime End time of the interval in `unit`
    #' @param resolution resolution in points per `unit`
    #' @param unit time unit for the interval.
    #' @return The updated `Simulation` object.
    set_output_interval = function(startTime, endTime, resolution, unit) {
      self$output_schema$set_interval(startTime, endTime, resolution, unit)
    },
    #' @description
    #' Adds an interval to the output schema of the simulation
    #' @param startTime Start time of the interval in `unit`
    #' @param endTime End time of the interval in `unit`
    #' @param resolution resolution in points per `unit`
    #' @param unit time unit for the interval.
    #' @return The updated `Simulation` object.
    add_output_interval = function(startTime, endTime, resolution, unit) {
      self$output_schema$add_interval(startTime, endTime, resolution, unit)
    },
    # set_output_selection = function(),
    # add_output_selection = function(),
    # remove_output_selection = function(),
    #' @description
    #' Pretty print the simulation object.
    print = function() {
      cli::cli_text("Simulation name: ", self$name)
      cli::cli_text("Individual: ", self$individual)
      purrr::map(private$.compounds, ~{
        cli::cli_text("Compound: ", .x$Name)
        cli::cli_li(paste0("Protocol: ", .x$Protocol$Name))
        cli::cli_li("Formulations: ")
        purrr::map(.x$Protocol$Formulations, ~{
          cli::cli_ol(paste0(.x$Key, ": ", .x$Name))
        })
      })
      self$output_schema$print()
      invisible(self)
    }
  ),
  private = list(
    .model = "4Comp",
    .solver = NULL,
    .output_schema = list(),
    .parameters = list(),
    .output_selection = list(),
    .individual = list(),
    .compounds = list(),
    .interactions = list(),
    .has_results = FALSE
  ),

  active = list(
    #' @field data dynamic json representation of the simulation object
    data = function() {
      data <- list(
        Name = self$name,
        Model = self$model,
        Solver = self$solver,
        OutputSchema = self$output_schema$data,
        Parameters = self$parameters,
        OutputSelection = self$output_selection,
        Individual = self$individual,
        Compounds = self$compounds,
        Interactions = self$interactions,
        HasResults = self$has_results
      )
      return(data)
    },
    #' @field model model used in the simulation
    model = function(value) {
      if (!missing(value)) {
        cli_abort("Model cannot be changed")
      }
      return(private$.model)
    },
    #' @field solver solver setting used in the simulation
    solver = function(value) {
      if (!missing(value)) {
        private$.solver <- value
      }
      return(private$.solver)
    },
    #' @field output_schema Output time intervals setting used in the simulation
    output_schema = function(value) {
      if (!missing(value)) {
        private$.output_schema <- value
      }
      return(private$.output_schema)
    },
    #' @field individual Individual used in the simulation
    individual = function(value) {
      if (!missing(value)) {
        private$.individual <- value
      }
      return(private$.individual)
    },
    #' @field compounds Compounds used in the simulation
    compounds = function(value) {
      if (!missing(value)) {
        private$.compounds <- value
      }
      return(private$.compounds)
    },
    #' @field interactions Interactions used in the simulation
    interactions = function(value) {
      if (!missing(value)) {
        private$.interactions <- value
      }
      return(private$.interactions)
    },
    #' @field has_results wether or not the simulation has results
    has_results = function(value) {
      if (!missing(value)) {
        private$.has_results <- value
      }
      return(private$.has_results)
    }
  )
)

#' Create a simulation object
#'
#' This function creates a custom simulation.
#'
#' @param simulation_name Name of the simulation to be created.
#' @param individual Name of the individual to be used in the simulation.
#' @param victim Name of the victim compound to be used in the simulation.
#' @param perpetrators Vector of names of the compounds to be used as perpetrators in the simulation
#' @details Protocols used by each compounds need to be defined afterwards with set_compound_protocol().
#' New compound can also be added afterwards with add_compound().
#' @return A `Simulation` object
#' @export
create_simulation <- function(simulation_name, individual, victim, perpetrators) {
  # Combine Compound, Protocol and Formulation
  sim <- Simulation$new(
    name = simulation_name,
    compounds = purrr::map(c(victim, perpetrators), ~list(Name = .x)),
    individual = individual
  )
  return(sim)
}
