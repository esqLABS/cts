fill_simulation_template <- function(template_path, max_protocol_duration, victim, perpetrator, individual, victim_formulation, perpetrator_formulation, victim_protocol, perpetrator_protocol) {
  template <- readr::read_file(template_path)
  filled_template <- glue::glue(template, .open = "${", .close = "}$")
  jsonlite::fromJSON(txt = filled_template, simplifyVector = T, simplifyDataFrame = FALSE)
}

extract_compound_processes <- function(compound) {
  all_processes <- list()
  i <- 1

  for (p in compound$Processes) {
    if (p$InternalName == "LiverClearance") {
      all_processes[[i]] <- list(
        Name = glue::glue("Total Hepatic Clearance-{p$DataSource}"),
        SystemicProcessType = "Hepatic"
      )
      i <- i + 1
    }

    if (p$InternalName == "GlomerularFiltration") {
      all_processes[[i]] <- list(
        Name = glue::glue("Glomerular Filtration-{p$DataSource}"),
        SystemicProcessType = "GFR"
      )
      i <- i + 1
    }

    if (p$InternalName == "BiliaryClearance") {
      all_processes[[i]] <- list(
        Name = glue::glue("Biliary Clearance-{p$DataSource}"),
        SystemicProcessType = "Biliary"
      )
      i <- i + 1
    }

    if (!is.null(p$Molecule) && !(p$InternalName == "CompetitiveInhibition" | p$InternalName == "Induction")) {
      all_processes[[i]] <- list(
        Name = glue::glue("{p$Molecule}-{p$DataSource}"),
        MoleculeName = p$Molecule
      )
      i <- i + 1
    }
  }
  return(all_processes)
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

  # extract processes
  processes <- extract_compound_processes(ddi)
  # add compounds processes under each simulations/compound
  simulation_compounds_names <- list_c(purrr::map(filled_template$Simulations[[1]]$Compounds, "Name"))

  for (c in simulation_compounds_names) {
    template_index <- which(c == simulation_compounds_names)
    ddi_index <- which(c == ddi$get_names("compounds"))
    filled_template$Simulations[[1]]$Compounds[[template_index]]$Processes <- extract_compound_processes(ddi$compounds[[ddi_index]])
  }

  return(filled_template$Simulations)
}
