# User functions ----------------------------------------------------------

#' Create a simulation object
#'
#' This function creates a custom simulation.
#'
#' @param simulation_name Name of the simulation to be created.
#' @param individual Name of the individual to be used in the simulation.
#' @param population Name of the population to be used in the simulation.
#' @param victim Name of the victim compound to be used in the simulation
#' @param perpetrators (optional) Vector of names of the compounds to be used as perpetrators in the simulation.
#' @details Protocols used by each compounds need to be defined afterwards with set_compound_protocol().
#' New compound can also be added afterwards with add_compound(). Either individual or population should
#' be set, but not both.
#' @return A `Simulation` object
#' @export
#' @examples
#' # Create a simulation with an individual
#' sim <- create_simulation(
#'   simulation_name = "Drug interaction study",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#'
#' # Create a simulation with a population
#' pop_sim <- create_simulation(
#'   simulation_name = "Population study",
#'   population = "European adults",
#'   victim = "Warfarin",
#'   perpetrators = c("Rifampicin")
#' )
create_simulation <- function(
  simulation_name,
  individual = list(),
  population = list(),
  victim,
  perpetrators = NULL
) {
  # Combine Compound, Protocol and Formulation
  sim <- Simulation$new(
    name = simulation_name,
    compounds = purrr::map(c(victim, perpetrators), ~ list(Name = .x)),
    individual = individual,
    population = population
  )
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
#' @examples
#' # Create a compound snapshot first
#' midazolam <- compound("Midazolam")
#' itraconazole <- compound("Itraconazole")
#'
#' # Create a DDI object
#' ddi <- create_ddi(midazolam, itraconazole)
#'
#' # Create a simulation
#' sim <- create_simulation(
#'   simulation_name = "Basic simulation",
#'   individual = "European (P-gp modified, CYP3A4 36 h)",
#'   victim = "Midazolam",
#'   perpetrators = c("Itraconazole")
#' )
#'
#' # Add simulation to DDI with default options
#' ddi <- add_simulation(
#'   ddi,
#'   sim,
#'   options = list(add_interactions = FALSE, add_processes = TRUE)
#' )
add_simulation <- function(
  snapshot,
  simulation,
  options = list(add_interactions = TRUE, add_processes = TRUE)
) {
  snapshot$check_simulation(simulation)

  # Match protocols with formulations from snapshot
  for (compound_index in seq_along(simulation$compounds)) {
    compound <- simulation$compounds[[compound_index]]
    if (!is.null(compound$Protocol)) {
      # Find protocol in snapshot by name
      protocol_name <- compound$Protocol$Name
      protocol_found <- FALSE

      for (protocol in snapshot$protocols) {
        if (protocol$name == protocol_name) {
          protocol_found <- TRUE

          # Get formulation keys based on protocol type
          if ("Protocol" %in% class(protocol)) {
            formulation_keys <- list("Formulation")
          } else if ("AdvancedProtocol" %in% class(protocol)) {
            # For advanced protocols, get formulation keys from schema items
            formulation_keys <- unique(
              unlist(
                purrr::map(protocol$schemas, \(x) {
                  purrr::map(x$SchemaItems, \(y) {
                    y$formulation_key
                  })
                }),
                recursive = TRUE
              )
            )
          } else {
            # Default to Formulation if we can't determine
            formulation_keys <- list("Formulation")
          }

          # Match provided formulations with protocol keys
          if (length(compound$Protocol$Formulations) > 0) {
            # Extract formulation names from the list structure
            formulation_names <- purrr::map_chr(
              compound$Protocol$Formulations,
              "Name"
            )

            if (length(formulation_names) == 1) {
              # If single formulation provided, use it for all keys
              simulation$compounds[[
                compound_index
              ]]$Protocol$Formulations <- purrr::map(
                formulation_keys,
                \(key) {
                  list(Key = key, Name = formulation_names[1])
                }
              )
            } else {
              # Otherwise, ensure we have the right number of formulations
              if (length(formulation_names) != length(formulation_keys)) {
                cli_abort(c(
                  "Number of formulations doesn't match protocol requirements for compound {.val {compound$Name}}.",
                  "i" = "Protocol requires {length(formulation_keys)} formulation(s), but {length(formulation_names)} provided."
                ))
              }
              # Assign keys in order - use the specific keys from the protocol definition
              simulation$compounds[[
                compound_index
              ]]$Protocol$Formulations <- purrr::map2(
                formulation_keys,
                formulation_names,
                \(key, name) {
                  list(Key = key, Name = name)
                }
              )
            }

            # Validate that formulations exist in snapshot
            formulation_names_to_check <- purrr::map_chr(
              simulation$compounds[[compound_index]]$Protocol$Formulations,
              "Name"
            )
            for (formulation_name in formulation_names_to_check) {
              exists <- any(purrr::map_lgl(
                snapshot$formulations,
                ~ .x$name == formulation_name
              ))
              if (!exists) {
                cli::cli_warn(
                  "Simulation `{simulation$name}`: Formulation `{formulation_name}` not found in snapshot."
                )
              }
            }
          } else if (length(formulation_keys) > 0) {
            # No formulations provided but they are required by the protocol
            cli::cli_warn(
              "Simulation `{simulation$name}`: Missing formulation key(s) `{paste(formulation_keys, collapse = '`, `')}` for protocol `{protocol_name}`."
            )
          }

          break # Found the protocol, no need to continue loop
        }
      }

      if (!protocol_found) {
        cli::cli_warn(
          "Simulation {.val {simulation$name}}: Protocol {.val {protocol_name}} not found in snapshot for compound {.val {compound$Name}}."
        )
      }
    }
  }

  # get all defined interactions in snapshot
  all_interactions <- extract_interactions(snapshot, quietly = TRUE)
  all_interactions_compounds <- purrr::list_c(purrr::map(
    all_interactions,
    ~ .x$CompoundName
  ))
  all_interactions_molecules <- purrr::list_c(purrr::map(
    all_interactions,
    ~ .x$MoleculeName
  ))
  all_interactions_names <- purrr::list_c(purrr::map(
    all_interactions,
    ~ .x$Name
  ))

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
        cli::cli_warn(
          "Interaction {.code {x$Name}} not found for compound {.code {x$CompoundName}} in snapshot. Skipping."
        )
        return(NULL)
      } else {
        x$MoleculeName <- all_interactions[[index]]$MoleculeName
        return(x)
      }
    })
    simulation$interactions <- purrr::compact(valid_interactions)
  } else {
    if (isTRUE(options$add_interactions)) {
      cli::cli_warn(c(
        "Automatically adding interactions to the simulation.",
        "Using first interaction found for each enzyme/compound pair."
      ))

      selected_interactions <- which(
        !duplicated(interaction(
          all_interactions_compounds,
          all_interactions_molecules
        ))
      )
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
      valid_processes <- purrr::map(compound$Processes, \(p) {
        p_name <- p$Name
        index <- which(purrr::list_c(purrr::map(
          compound_processes,
          ~ {
            .x$Name == p_name
          }
        )))
        if (length(index) == 0) {
          cli::cli_warn(
            "Process {.code {p_name}} not found for compound {.code {compound_name}} in snapshot. Skipping."
          )
          return(NULL)
        } else {
          return(compound_processes[[index]])
        }
      })
      compound$Processes <- purrr::compact(valid_processes)
    } else {
      # if not processes are defined and add_processes is TRUE, add the first processes of each type/molecule found for each compound
      if (isTRUE(options$add_processes)) {
        cli::cli_warn(c(
          "Automatically adding processes to the simulation for compound {.code {compound_name}}.",
          "Using first processes of each type and of each metabolizing enzyme found."
        ))

        processes_types <- purrr::map(
          compound_processes,
          ~ ifelse(
            !is.null(.x$MoleculeName),
            .x$MoleculeName,
            .x$SystemicProcessType
          )
        )

        # Using first processes of each type/molecule found for each compound pair.
        selected_processes <- which(!duplicated(processes_types))
        compound$Processes <- compound_processes[selected_processes]
      }
    }

    simulation$compounds[[compound_index]]$Processes <- purrr::compact(
      compound$Processes
    )
  }

  snapshot$check_simulation(simulation)
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
#' @examples
#' # Create a compound snapshot first
#' midazolam <- compound("Midazolam")
#' itraconazole <- compound("Itraconazole")
#'
#' # Create a DDI object
#' ddi <- create_ddi(midazolam, itraconazole)
#'
#' # Create a simulation
#' sim <- create_simulation(
#'   simulation_name = "Basic simulation",
#'   individual = "European (P-gp modified, CYP3A4 36 h)",
#'   victim = "Midazolam",
#'   perpetrators = c("Itraconazole")
#' )
#'
#' # Add simulation to DDI with default options
#' ddi <- add_simulation(
#'   ddi,
#'   sim,
#'   options = list(add_interactions = FALSE, add_processes = TRUE)
#' )
#' # Remove a single simulation
#' snapshot <- remove_simulation(ddi, "Basic simulation")
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
#' @examples
#' sim <- create_simulation(
#'   simulation_name = "Basic simulation",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#' # Add compound without protocol
#' sim <- add_compound(sim, "Itraconazole")
#'
#' # Add compound with protocol
#' sim <- add_compound(sim, "Fluconazole", "Standard oral dose")
#'
#' # Add compound with protocol and formulation
#' sim <- add_compound(
#'   sim,
#'   "Clarithromycin",
#'   "Oral BID",
#'   formulation = "Tablet"
#' )
add_compound <- function(
  simulation,
  compound,
  protocol = NULL,
  formulation = list()
) {
  simulation$add_compound(compound, protocol, formulation)
  invisible(simulation)
}

#' Set Protocol and Formulation for a Compound in a Simulation
#'
#' @description
#' Sets the protocol and formulation for a compound in a simulation.
#'
#' @param simulation A Simulation object
#' @param compound Name of the compound
#' @param protocol A character string specifying the protocol name
#' @param formulation Optional. Either a character string or a character vector of formulation names.
#'   If a single formulation is provided, it will be used for all protocol keys.
#'   If multiple formulations are provided, they will be mapped in order to the protocol keys.
#'
#' @return The simulation object (invisibly)
#'
#' @examples
#' sim <- create_simulation(
#'   simulation_name = "Test",
#'   victim = "Rifampicin",
#'   perpetrators = "Midazolam",
#'   individual = "European (P-gp modified, CYP3A4 36 h)"
#' )
#' sim <- set_compound_protocol(sim, "Midazolam", "Single oral dose", "Tablet")
#'
#' @export
set_compound_protocol <- function(
  simulation,
  compound,
  protocol,
  formulation = list()
) {
  # ensure protocol is a character string
  if (!is.character(protocol) || length(protocol) != 1) {
    cli_abort("Protocol must be a single character string.")
  }

  # ensure formulation is given in the correct format if provided
  if (length(formulation) > 0) {
    if (is.character(formulation)) {
      # Convert character vector to list of formulation specifications
      # For simple protocol or when we don't yet know what keys to use,
      # just use "Formulation" as the key - the actual keys will be determined in add_simulation
      formulation <- purrr::map(
        formulation,
        \(x) list(Key = "Formulation", Name = x)
      )
    } else if (is.list(formulation)) {
      # Check if all elements are character (now required)
      if (all(unlist(purrr::map(formulation, is.character)))) {
        # Convert list of characters to Key/Name format
        formulation <- purrr::map(
          formulation,
          \(x) list(Key = "Formulation", Name = x)
        )
      } else {
        cli_abort(
          "Formulation must be either a character string or a character vector of formulation names."
        )
      }
    } else {
      cli_abort(
        "Formulation must be either a character string or a character vector of formulation names."
      )
    }
  }

  simulation$set_compound_protocol(compound, protocol, formulation)
  invisible(simulation)
}

#' Clears the output interval from the simulation and adds a new one.
#' @param simulation The `Simulation` object (as created by `create_simulation`).
#' @param start_time Start time of the interval in `unit`
#' @param end_time End time of the interval in `unit`
#' @param resolution resolution in points per `unit`
#' @param unit time unit for the interval. Should be one of ospsuite::ospUnits$Time.
#' @return The updated `Simulation` object.
#' @export
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Output interval example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#'
#' # Set output interval for 24 hours with 10 points per hour
#' sim <- set_output_interval(sim, 0, 24, 10, "h")
#'
#' # Set output interval for 7 days with 24 points per day
#' sim <- set_output_interval(sim, 0, 7, 24, "day(s)")
set_output_interval <- function(
  simulation,
  start_time,
  end_time,
  resolution,
  unit
) {
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
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Output interval example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("itraconazole")
#' )
#'
#' # Add an output interval for the first hour with high resolution
#' sim <- add_output_interval(sim, 0, 1, 60, "h")
#'
#' # Add another interval for the rest of the day with lower resolution
#' sim <- add_output_interval(sim, 1, 24, 10, "h")
add_output_interval <- function(
  simulation,
  start_time,
  end_time,
  resolution,
  unit
) {
  simulation$output_schema$add_interval(start_time, end_time, resolution, unit)
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
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Interaction example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole", "Rifampicin")
#' )
#'
#' # Add a single interaction
#' sim <- add_interactions(sim, "Ketoconazole", "CYP3A4-inhibition")
#'
#' # Add multiple interactions
#' sim <- add_interactions(
#'   sim,
#'   "Rifampicin",
#'   c("CYP3A4-induction", "P-gp-induction")
#' )
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
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Process example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#'
#' # Add a single process
#' sim <- add_processes(sim, "Midazolam", "Hepatic metabolism")
#'
#' # Add multiple processes
#' sim <- add_processes(
#'   sim,
#'   "Ketoconazole",
#'   c("Hepatic metabolism", "Renal clearance")
#' )
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
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Output example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#'
#' # Set a single output path
#' sim <- set_outputs(sim, "Organism|Venous Blood|Plasma|Midazolam|Concentration")
#'
#' # Set multiple output paths
#' sim <- set_outputs(
#'   sim,
#'   c(
#'     "Organism|Venous Blood|Plasma|Midazolam|Concentration",
#'     "Organism|Liver|Intracellular|Midazolam|Concentration"
#'   )
#' )
set_outputs <- function(simulation, paths) {
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
#' @examples
#' # Create a simulation first
#' sim <- create_simulation(
#'   simulation_name = "Add output example",
#'   individual = "Adult male",
#'   victim = "Midazolam",
#'   perpetrators = c("Ketoconazole")
#' )
#'
#' # Add a single output path
#' sim <- add_outputs(sim, "Organism|Venous Blood|Plasma|Ketoconazole|Concentration")
#'
#' # Add multiple output paths
#' sim <- add_outputs(
#'   sim,
#'   c(
#'     "Organism|Liver|Intracellular|Ketoconazole|Concentration",
#'     "Organism|Kidney|Intracellular|Ketoconazole|Concentration"
#'   )
#' )
add_outputs <- function(simulation, paths) {
  simulation$add_output_selections(paths)
  invisible(simulation)
}

#' Get observer names from a snapshot
#'
#' @description
#' Returns the names of all observer sets defined in the snapshot.
#' Observer outputs can be used as output selections in simulations
#' to include custom calculated quantities (e.g., sum of species,
#' fold-change in concentration) in simulation results.
#' @param snapshot A `Snapshot` or `DDI` object.
#' @return A character vector of observer set names.
#' @export
#' @examples
#' \dontrun{
#' ddi <- create_ddi("path/to/snapshot.json")
#' # List available observers
#' get_observer_names(ddi)
#' # Use observer name in output selections
#' sim <- create_simulation("my_sim", victim = "Drug", individual = "Human")
#' add_outputs(sim, "Organism|VenousBlood|Plasma|Drug|Sum_species")
#' }
get_observer_names <- function(snapshot) {
  snapshot$get_observer_names()
}

# Object definition -------------------------------------------------------

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
    #' @param population name of the population used in the simulation.
    #' @return A new `Simulation` object.
    initialize = function(
      name,
      compounds = list(),
      individual = list(),
      population = list()
    ) {
      self$name <- name
      self$compounds <- compounds
      if (length(individual) > 0 && length(population) > 0) {
        cli_abort("Only one of `individual` or `population` can be set.")
      }
      self$output_schema <- SnapshotOutputSchema$new()
      if (length(individual) > 0) {
        self$individual <- individual
      } else if (length(population) > 0) {
        self$population <- population
      }

      # initialize with default outputs paths PVB bound and unbound
      self$set_output_selections(
        c(
          paste0("Organism|PeripheralVenousBlood|", unlist(compounds), "|Plasma Unbound (Peripheral Venous Blood)"),
          paste0("Organism|PeripheralVenousBlood|", unlist(compounds), "|Plasma (Peripheral Venous Blood)")
        )
      )
    },
    #' @description
    #' Set the individual to be used in the simulation.
    #' @param individual name of the individual used in the simulation.
    #' @return The updated `Simulation` object.
    set_individual = function(individual) {
      self$individual <- individual
    },
    #' @description
    #' Set the individual to be used in the simulation.
    #' @param population name of the individual used in the simulation.
    #' @return The updated `Simulation` object.
    set_population = function(population) {
      self$population <- population
    },
    #' @description
    #' Add the compounds to be used in the simulation.
    #' @param compound name of the compound to be added in the simulation.
    #' @param protocol name of the protocol used for the compound.
    #' @param formulation character string or vector of formulation names to use with the protocol.
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

      compoundIdx <- which(
        purrr::list_c(purrr::map(self$compounds, ~ .x$Name)) == compound
      )
      if (length(compoundIdx) == 0) {
        cli_abort(
          "`compound` not found. Use `add_compound()` to add a new compound."
        )
      }

      # If we have multiple formulations, assign sequential keys
      if (length(formulation) > 1) {
        # For multiple formulations, use sequential keys like "Formulation 1", "Formulation 2", etc.
        formulation <- purrr::map2(
          seq_along(formulation),
          formulation,
          function(i, form) {
            form$Key <- paste("Formulation", i)
            return(form)
          }
        )
      }

      self$compounds[[compoundIdx]]$Protocol <- list(
        Name = protocol,
        Formulations = formulation
      )
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

      self$interactions <- c(
        self$interactions,
        purrr::map(interactions, ~ list(Name = .x, CompoundName = compound))
      )
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

      compound_index <- which(purrr::map(self$compounds, ~ .x$Name) == compound)
      self$compounds[[compound_index]]$Processes <- c(
        self$processes,
        purrr::map(processes, ~ list(Name = .x))
      )
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
      cat(
        cli::cli_format_method({
          cli::cli_text("Simulation name: {self$name}")
          if (length(self$population) > 0) {
            cli::cli_text("Population: {self$population}")
          } else {
            cli::cli_text("Individual: {self$individual}")
          }
          purrr::walk(private$.compounds, \(x) {
            cli::cli_text("Compound: {x$Name}")
            cli::cli_li("Protocol: {x$Protocol$Name}")
            # if formulation is not empty
            if (length(x$Protocol$Formulations) > 0) {
              if (length(x$Protocol$Formulations) == 1) {
                # Single formulation - print on same line
                cli::cli_li("Formulations: {x$Protocol$Formulations[[1]]$Name}")
              } else {
                # Multiple formulations - print as nested list
                cli::cli_li("Formulations: ")
                purrr::walk(x$Protocol$Formulations, \(f) {
                  cli::cli_ol("{f$Key}: {f$Name}")
                })
              }
            } else {
              cli::cli_li("Formulations: ")
            }
            cli::cli_li("Processes: ")
            ol <- cli::cli_ol()
            purrr::map(x$Processes, \(p) {
              cli::cli_li(p$Name)
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
          self$output_schema$print()
          cli::cli_text("Outputs: ")
          cli::cli_li(self$output_selections)
        }),
        sep = "\n"
      )
      invisible(self)
    }
  ),
  private = list(
    .model = "4Comp",
    .solver = NULL,
    .parameters = list(),
    .output_schema = list(),
    .output_selections = list(),
    .individual = list(),
    .population = list(),
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
        Parameter = self$parameters,
        OutputSelections = self$output_selections,
        Individual = self$individual,
        Population = self$population,
        Compounds = self$compounds,
        Interactions = self$interactions,
        HasResults = self$has_results
      )

      if (length(self$individual) == 0) {
        data <- purrr::discard_at(data, "Individual")
      } else if (length(self$population) == 0) {
        data <- purrr::discard_at(data, "Population")
      }

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
        # if individual ensure no population is also set
        private$.population <- list()
        private$.individual <- value
      }
      return(private$.individual)
    },
    #' @field population Population used in the simulation
    population = function(value) {
      if (!missing(value)) {
        # if population ensure no individual is also set
        private$.individual <- list()
        private$.population <- value
      }
      return(private$.population)
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
