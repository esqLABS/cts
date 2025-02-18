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
  sim$set_output_selections(glue::glue("Organism|PeripheralVenousBlood|{victim}|Plasma (Peripheral Venous Blood)"))
  return(sim)
}

#' Add a simulation to a `Snapshot` or DDI object
#'
#' This function adds a simulation to a `Snapshot` or `DDI` object.
#' @param snapshot The `Snapshot` or `DDI` object to which the simulation will be added.
#' @param simulation `Simulation` object created by `create_simulation()`, to be added to the `Snapshot` or `DDI` object.
#' @param options a named list of options to customize the simulation.
#'   - add_interactions: logical, whether to automatically add the first interactions for each
#'      enzyme/compound pair to the simulation (only used if no interaction have been defined in the simulation).
#'   - add_processes: logical, whether to automatically add the first process of each type/molecule for each
#'      compound to the simulation (only used if no processes have been defined in the simulation for a compound).
#' @return The `Snapshot` or `DDI` object with the simulation added.
#' @export
add_simulation <- function(snapshot, simulation, options = list(add_interactions = TRUE, add_processes = TRUE)) {
  snapshot$check_simulation(simulation)

  # get all defined interactions in snapshot
  all_interactions <- extract_interactions(snapshot, quietly = TRUE)
  all_interactions_compounds <- purrr::list_c(purrr::map(all_interactions, ~ .x$CompoundName))
  all_interactions_molecules <- purrr::list_c(purrr::map(all_interactions, ~ .x$MoleculeName))
  all_interactions_names <- purrr::list_c(purrr::map(all_interactions, ~ .x$Name))

  # add molecule to used interactions in sim as defined in snapshot
  # (can't just split name by `-` as some molecule have `-` in their name)
  if (length(simulation$interactions) > 0) {
    valid_interactions <- purrr::map(simulation$interactions, \(x) {
      index <- intersect(
        which(all_interactions_compounds == x$CompoundName),
        which(all_interactions_names == x$Name)
      )

      # check that the interaction is valid
      if (length(index) == 0) {
        cli::cli_warn("Interaction {.code {x$Name}} not found for compound {.code {x$CompoundName}} in snapshot. Skipping.")
        return(NULL)
      } else {
        x$MoleculeName <- all_interactions[[index]]$MoleculeName
        return(x)
      }
    })
    simulation$interactions <- purrr::compact(valid_interactions)

  } else {
    if (isTRUE(options$add_interactions)) {
      cli::cli_warn(c('Automatically adding interactions to the simulation.', 'Using first interaction found for each enzyme/compound pair.'))

      selected_interactions <- which(!duplicated(interaction(all_interactions_compounds, all_interactions_molecules)))
      simulation$interactions <- all_interactions[selected_interactions]
    }
  }

  # get processes defined in snapshot to match with given processes names
  all_processes <- extract_processes(snapshot, quietly = TRUE)
  for (compound_index in seq_along(simulation$compounds)) {
    compound <- simulation$compounds[[compound_index]]
    compound_name <- simulation$compounds[[compound_index]]$Name
    compound_processes <- all_processes[[compound_name]]

    # add processes used in sim as defined in snapshot
    if (length(compound$Processes) > 0) {
      for (i in seq_along(compound$Processes)) {
        p_name <- compound$Processes[[i]]$Name
        index <- which(purrr::list_c(purrr::map(compound_processes, ~ {.x$Name == p_name})))
        if (length(index) == 0) {
          cli::cli_warn("Process {.code {p_name}} not found for compound {.code {compound_name}} in snapshot. Skipping.")
          compound$Processes[[i]] <- NULL
        } else {
          compound$Processes[[i]] <- compound_processes[[index]]
        }
      }
    } else {
      # if not processes are defined and add_processes is TRUE, add the first processes of each type/molecule found for each compound
      if (isTRUE(options$add_processes)) {
        cli::cli_warn(c('Automatically adding processes to the simulation for compound {.code {compound_name}}.',
                        'Using first processes of each type and of each metabolizing enzyme found.'))

        processes_types <- purrr::map(compound_processes, ~ ifelse(!is.null(.x$MoleculeName), .x$MoleculeName, .x$SystemicProcessType))

        # Using first processes of each type/molecule found for each compound pair.
        selected_processes <- which(!duplicated(processes_types))
        compound$Processes <- compound_processes[selected_processes]
      }
    }

    simulation$compounds[[compound_index]]$Processes <- purrr::compact(compound$Processes)
  }

  snapshot$add_simulation(simulation$data)
  invisible(snapshot)
}

#' Remove simulation(s) from a `Snapshot` or `DDI` object
#'
#' This function removes a simulation from a `Snapshot` or `DDI` object.
#' @param snapshot The `Snapshot` or `DDI` object to which the simulation(s) should be removed.
#' @param simulation_name Names of the simulations to be removed from the `Snapshot` or `DDI` object
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

#' Add interactions for an already used compound from a `Simulation` object
#'
#' This function add the interactions of the specified compounds.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param compound name of the compound for which to add interaction
#' @param interactions name of interactions to use
#' @return The updated `Simulation` object
#' @export
add_interactions <- function(simulation, compound, interactions) {
  simulation$add_compound_interactions(compound, interactions)
  invisible(simulation)
}

#' Add processes for an already used compound from a `Simulation` object
#'
#' This function add the interactions of the specified compounds.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param compound name of the compound for which to add interaction
#' @param processes name of interactions to use
#' @return The updated `Simulation` object
#' @export
add_processes <- function(simulation, compound, processes) {
  simulation$add_compound_processes(compound, processes)
  invisible(simulation)
}

#' Set outputs to a `Simulation` object
#'
#' @description
#' Set the outputs to be used for plotting to the simulation.
#' This removes any previously set outputs.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param paths path of the output to use for plotting
#' @return The updated `Simulation` object.
#' @export
set_outputs = function(simulation, paths) {
  simulation$set_output_selections(paths)
  invisible(simulation)
}

#' Add outputs to a already defined outputs of a `Simulation` object
#'
#' @description
#' Add some outputs to be used for plotting to the simulation.
#' This add the output to any previously set outputs.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param paths path of the output to add for plotting
#' @return The updated `Simulation` object.
#' @export
add_outputs = function(simulation, paths) {
  simulation$add_output_selections(paths)
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
    #' Add the interactions to be used in for a given compound.
    #' @param compound name of the compound for which to add interaction
    #' @param interactions name of the molecule with which the compound interacts.
    #' @return The updated `Simulation` object.
    add_compound_interactions = function(compound, interactions) {
      if (!is.character(compound)) {
        cli_abort("`compound` must be a character.")
      }
      if (!is.character(interactions)) {
        cli_abort("`interactions` must be a character vector.")
      }
      if (length(compound) > 1) {
        cli_abort("Interactions for a single compound can be set at a time.")
      }

      self$interactions <- c(self$interactions, purrr::map(interactions, ~ list(Name = .x, CompoundName = compound)))
      invisible(self)
    },
    #' @description
    #' Add the interactions to be used in for a given compound.
    #' @param compound name of the compound for which to add interaction
    #' @param processes name of the molecule with which the compound interacts.
    #' @return The updated `Simulation` object.
    add_compound_processes = function(compound, processes) {
      if (!is.character(compound)) {
        cli_abort("`compound` must be a character.")
      }
      if (!is.character(processes)) {
        cli_abort("`interactions` must be a character vector.")
      }
      if (length(compound) > 1) {
        cli_abort("Interactions for a single compound can be set at a time.")
      }

      compound_index <- which(purrr::map(self$compounds, ~.x$Name) == compound)
      self$compounds[[compound_index]]$Processes <- c(self$processes, purrr::map(processes, ~ list(Name = .x)))
      invisible(self)
    },
    # set_output_schema = function()
    # add_output_schema = function()
    #' @description
    #' Set the outputs to be used for plotting.
    #' This removes any previously set outputs.
    #' @param paths path of the output to use for plotting
    #' @return The updated `Simulation` object.
    set_output_selections = function(paths) {
      self$output_selections <- c(list(), paths)
      invisible(self)
    },
    #' @description
    #' Add some outputs to be used for plotting.
    #' This add the output to any previously set outputs.
    #' @param paths path of the output to add for plotting
    #' @return The updated `Simulation` object.
    add_output_selections = function(paths) {
      self$output_selections <- c(self$output_selections, paths)
      invisible(self)
    },
    # remove_output_selection = function(),
    #' @description
    #' Pretty print the simulation object.
    print = function() {
      cli::cli_text("Simulation name: ", self$name)
      cli::cli_text("Individual: ", self$individual)
      purrr::map(private$.compounds, \(x) {
        cli::cli_text("Compound: ", x$Name)
        cli::cli_li(paste0("Protocol: ", x$Protocol$Name))
        cli::cli_li("Formulations: ")
        ol <- cli::cli_ol()
        purrr::map(x$Protocol$Formulations, \(f) {
          cli::cli_li(paste0(f$Key, ": ", f$Name))
        })
        cli::cli_end(ol)
        cli::cli_li("Processes: ")
        ol <- cli::cli_ol()
        purrr::map(x$Processes, \(p) {
          cli::cli_li(paste0(p$Name))
        })
        cli::cli_end(ol)
        cli::cli_li("Interactions: ")
        ol <- cli::cli_ol()
        purrr::map(private$.interactions, \(y) {
          if (y$CompoundName == x$Name) {
            cli::cli_li(y$Name)
          }
        })
        cli::cli_end(ol)
      })
      cli::cli_text("Outputs: ")
      cli::cli_li(self$output_selections)
      invisible(self)
    }
  ),
  private = list(
    .model = "4Comp",
    .solver = NULL,
    .output_schema = list(
      list(
        "Parameters" = list(
          list(
            "Name" = "Start time",
            "Value" = 0.0,
            "Unit" = "h"
          ),
          list(
            "Name" = "End time",
            "Value" = 24,
            "Unit" = "h"
          ),
          list(
            "Name" = "Resolution",
            "Value" = 4.0,
            "Unit" = "pts/h"
          )
        )
      )
    ),
    .parameters = list(),
    .output_selections = list(),
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
        OutputSchema = self$output_schema,
        Parameter = self$parameters,
        OutputSelections = self$output_selections,
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
    #' @field output_selections Output to be returned when running the simulation
    output_selections = function(value) {
      if (!missing(value)) {
        private$.output_selections <- value
      }
      return(private$.output_selections)
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
        # ensure uniqueness of interactions every times it is changed
        private$.interactions <- unique(value)
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

