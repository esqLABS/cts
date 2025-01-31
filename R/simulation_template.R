fill_simulation_template <- function(template_path, max_protocol_duration, victim, perpetrator, individual, victim_formulation, perpetrator_formulation, victim_protocol, perpetrator_protocol) {
  template <- readr::read_file(template_path)
  filled_template <- glue::glue(template, .open = "${", .close = "}$")
  jsonlite::fromJSON(txt = filled_template, simplifyVector = T, simplifyDataFrame = FALSE)
}

create_generic_simulation <- function(ddi, template_path, max_protocol_duration, victim, perpetrator, individual, victim_formulation, perpetrator_formulation, victim_protocol, perpetrator_protocol) {
  # fill the simulation template
  filled_template <- fill_simulation_template(template_path, max_protocol_duration, victim, perpetrator, individual, victim_formulation, perpetrator_formulation, victim_protocol, perpetrator_protocol)

  # extract molecule interactions from the ddi object
  all_interactions <- extract_interactions(ddi, quietly = TRUE)
  all_interactions_compounds <- purrr::list_c(purrr::map(all_interactions, ~ .x$CompoundName))
  all_interactions_molecules <- purrr::list_c(purrr::map(all_interactions, ~ .x$MoleculeName))

  # add interactions to the simulation template
  # Using first interaction found for each enzyme/compound pair.
  selected_interactions <- which(!duplicated(interaction(all_interactions_compounds, all_interactions_molecules)))
  filled_template$Simulations[[1]]$Interactions <- all_interactions[selected_interactions]

  # add compounds processes under each simulations/compound
  simulation_compounds_names <- list_c(purrr::map(filled_template$Simulations[[1]]$Compounds, "Name"))
  processes <- extract_processes(ddi, quietly = TRUE)

  for (c in simulation_compounds_names) {
    processes_types <- purrr::map(processes[[c]], ~ ifelse(!is.null(.x$Molecule), .x$Molecule, .x$SystemicProcessType))

    # Using first processes of each type/molecule found for each compound pair.
    selected_processes <- which(!duplicated(processes_types))

    template_index <- which(c == simulation_compounds_names)
    filled_template$Simulations[[1]]$Compounds[[template_index]]$Processes <- processes[[c]][selected_processes]
  }

  return(filled_template$Simulations)
}
