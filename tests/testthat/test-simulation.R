# Simulation Creation -----------------------------------------------------

test_that("Simulation can be initialized.", {
  expect_no_message(
    create_simulation(
      simulation_name = "Test",
      victim = "Levonorgestrel 1",
      individual = "Woman"
    )
  )

  expect_no_message(
    create_simulation(
      simulation_name = "Test",
      victim = "Levonorgestrel 1",
      perpetrators = "Itraconazole",
      individual = "Woman"
    )
  )
})

# Parameterize Simulation -------------------------------------------------

test_that("`add_compound` can add compounds to the simulation.", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    individual = "Woman"
  )
  expect_no_message(my_sim$add_compound(
    compound = "Itraconazole",
    protocol = "New protocol"
  ))
  expect_snapshot(my_sim)
})

test_that("`set_compound_protocol` validates input formats correctly", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  # Protocol must be string
  expect_error(
    set_compound_protocol(my_sim, compound = "Itraconazole", protocol = 123),
    "Protocol must be a single character string."
  )

  # Formulation must be character or list of characters
  expect_error(
    set_compound_protocol(
      my_sim,
      compound = "Itraconazole",
      protocol = "ITZ 100mg 21 days",
      formulation = 123
    ),
    "Formulation must be either a character string or a character vector of formulation names."
  )

  # List must contain only character values
  expect_error(
    set_compound_protocol(
      my_sim,
      compound = "Itraconazole",
      protocol = "ITZ 100mg 21 days",
      formulation = list(1, 2)
    ),
    "Formulation must be either a character string or a character vector of formulation names."
  )
})

test_that("`set_compound_protocol` accepts various formulation formats", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  # Single formulation name
  expect_no_message(
    set_compound_protocol(
      my_sim,
      "Itraconazole",
      "ITZ 100mg 21 days",
      "IR Dissolved"
    )
  )

  # Multiple formulation names as vector
  expect_no_message(
    set_compound_protocol(
      my_sim,
      "Levonorgestrel 1",
      "LNG_150 ug_21 Days",
      c("Microlut", "IR Dissolved")
    )
  )

  # Multiple formulation names as list
  expect_no_message(
    set_compound_protocol(
      my_sim,
      "Itraconazole",
      "ITZ 100mg 21 days",
      list("IR Dissolved", "Tablet")
    )
  )
})


test_that("Formulation keys are correctly assigned when adding simulation", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test1",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  # Single formulation gets mapped to all keys
  set_compound_protocol(
    my_sim,
    "Levonorgestrel 1",
    "LNG_150 ug_21 Days",
    "Microlut"
  )
  expect_no_error(add_simulation(
    ddi,
    my_sim,
    options = list(add_processes = FALSE, add_interactions = FALSE)
  ))

  # Create a new simulation with a different name for the second test
  my_sim2 <- create_simulation(
    simulation_name = "Test1b",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  # Multiple formulations get mapped in order - use valid formulations for this DDI
  set_compound_protocol(
    my_sim2,
    "Levonorgestrel 1",
    "LNG_150 ug_21 Days",
    "Microlut"
  )
  set_compound_protocol(
    my_sim2,
    "Itraconazole",
    "ITZ 100mg 21 days",
    "IR Dissolved"
  )
  expect_no_error(add_simulation(
    ddi,
    my_sim2,
    options = list(add_processes = FALSE, add_interactions = FALSE)
  ))
})

test_that("Formulation keys are correctly assigned when adding simulation with advanced protocol", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  # Create advanced protocol with loading dose and maintenance dose
  advanced_protocol <- create_advanced_protocol("ITZ Loading Dose")

  # Add loading dose schema (first day, higher dose)
  add_schema(
    advanced_protocol,
    start_time = 0,
    start_time_unit = "h",
    rep_nb = 1,
    time_btw_rep = 24,
    time_btw_rep_unit = "h",
    schema_name = "Loading Dose"
  )

  # Add maintenance dose schema (following days, lower dose)
  add_schema(
    advanced_protocol,
    start_time = 24,
    start_time_unit = "h",
    rep_nb = 13,
    time_btw_rep = 24,
    time_btw_rep_unit = "h",
    schema_name = "Maintenance Dose"
  )

  # Create loading dose protocol (200mg twice daily)
  loading_dose <- create_protocol(
    name = "Loading 200mg",
    type = "oral",
    interval = "single",
    dose = 200,
    dose_unit = "mg"
  )

  # Create maintenance dose protocol (100mg daily)
  maintenance_dose <- create_protocol(
    name = "Maintenance 100mg",
    type = "oral",
    interval = "single",
    dose = 100,
    dose_unit = "mg"
  )

  # Add protocols to their respective schemas
  add_administration(
    advanced_protocol,
    schema_name = "Loading Dose",
    administration = loading_dose,
    formulation_key = "Formulation 1"
  )

  add_administration(
    advanced_protocol,
    schema_name = "Maintenance Dose",
    administration = maintenance_dose,
    formulation_key = "Formulation 2"
  )

  # Add the advanced protocol to the DDI snapshot
  expect_no_error(add_protocol(ddi, advanced_protocol))

  # Create simulation with advanced protocol
  my_sim <- create_simulation(
    simulation_name = "Test_Advanced_Multi",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  # Set the advanced protocol for Itraconazole
  set_compound_protocol(
    my_sim,
    "Itraconazole",
    "ITZ Loading Dose",
    c("IR Dissolved", "IR Dissolved") # Use real formulations that exist in the snapshot
  )

  # Set protocol for Levonorgestrel
  set_compound_protocol(
    my_sim,
    "Levonorgestrel 1",
    "LNG_150 ug_21 Days",
    "Microlut"
  )

  # Add to snapshot to verify everything works
  expect_no_error(add_simulation(
    ddi,
    my_sim,
    options = list(add_processes = FALSE, add_interactions = FALSE)
  ))
})


test_that("Adding population to a simulation compound works.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    population = "Women"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  expect_snapshot(my_sim)
})

test_that("Adding a population and an individual does not work.", {
  expect_error(
    create_simulation(
      simulation_name = "Test",
      victim = "Levonorgestrel 1",
      perpetrators = "Itraconazole",
      population = "Women",
      individual = "Woman"
    ),
    "Only one of `individual` or `population` can be set."
  )
})


test_that("Setting a population in a simulation remove defined individual and vice versa.", {
  sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )

  sim$set_population("Women")
  expect_snapshot(sim)
  sim$set_individual("Woman SHBG 40% more")
  expect_snapshot(sim)
})


test_that("Adding/setting outptuts to a simulation object works.", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  expect_snapshot(my_sim)

  add_outputs(
    my_sim,
    "Organism|ArterialBlood|Plasma|Levonorgestrel 1|Concentration in container"
  )
  expect_snapshot(my_sim)

  set_outputs(
    my_sim,
    c(
      "Organism|VenousBlood|Plasma|Itraconazole|Concentration in container",
      "Organism|VenousBlood|Plasma|Levonorgestrel 1|Concentration in container"
    )
  )
  expect_snapshot(my_sim)
})

test_that("Simulation output interval can be set and added", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )
  expect_no_message(set_output_interval(
    my_sim,
    start_time = 0,
    end_time = 2,
    resolution = 20,
    unit = "h"
  ))
  expect_no_message(add_output_interval(
    my_sim,
    start_time = 2,
    end_time = 48,
    resolution = 1,
    unit = "h"
  ))
  expect_snapshot(my_sim)
  expect_snapshot(add_simulation(ddi, my_sim))
})


# Simulations parameters checked when added to snapshot -------------------

test_that("Adding default interactions works.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test2",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  expect_warning(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = TRUE, add_processes = FALSE)
    ),
    "Automatically adding interactions to the simulation.\nUsing first interaction found for each enzyme/compound pair."
  )
  expect_snapshot(my_sim)
})

test_that("Adding manual interactions works.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test3",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  add_interactions(
    my_sim,
    "Itraconazole",
    interactions = c("CYP3A4-Isoherranen, 2004", "ABCB1-Shityakov 2014")
  )

  expect_no_message(add_simulation(
    ddi,
    my_sim,
    list(add_interactions = FALSE, add_processes = FALSE)
  ))
})

test_that("Adding unknown interactions throws a warning.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test4",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  add_interactions(
    my_sim,
    "Itraconazole",
    interactions = "CYP3A8-Unknown"
  )

  expect_warning(
    add_simulation(
      ddi,
      my_sim,
      list(add_interactions = FALSE, add_processes = FALSE)
    ),
    "Interaction `CYP3A8-Unknown` not found for compound `Itraconazole` in snapshot. Skipping."
  )
  expect_snapshot(my_sim)
})


test_that("Adding default processes works.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test5",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  # nested test of Levonorgestrel and Itraconazole warnings
  expect_warning(
    expect_warning(
      add_simulation(
        ddi,
        my_sim,
        options = list(add_interactions = FALSE, add_processes = TRUE)
      ),
      "Automatically adding processes to the simulation for compound `Levonorgestrel 1`.\nUsing first processes of each type and of each metabolizing enzyme found."
    ),
    "Automatically adding processes to the simulation for compound `Itraconazole`.\nUsing first processes of each type and of each metabolizing enzyme found."
  )

  expect_snapshot(my_sim)
})

test_that("Adding processes to a simulation compound works.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test6",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  expect_snapshot(my_sim)

  add_processes(
    my_sim,
    compound = "Levonorgestrel 1",
    c("CYP3A4-Parameter Identification")
  )
  add_processes(my_sim, compound = "Itraconazole", "CYP3A4-Isoherranen 2004")
  expect_snapshot(my_sim)

  expect_no_message(add_simulation(
    ddi,
    my_sim,
    options = list(add_interactions = FALSE)
  ))
})

test_that("Adding unknown processes throws a warning.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test7",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  add_processes(my_sim, "Itraconazole", "CYP3A8-Unknown")

  expect_warning(
    add_simulation(ddi, my_sim, options = list(add_processes = FALSE)),
    "Process `CYP3A8-Unknown` not found for compound `Itraconazole` in snapshot. Skipping."
  )
  expect_snapshot(my_sim)
})


# Add Simulation to snapshot ----------------------------------------------

test_that("Add a valid simulation works", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  # Add a simulation with only victim
  my_sim2 <- create_simulation(
    simulation_name = "Test 2",
    victim = "Levonorgestrel 1",
    individual = "Woman"
  )

  set_compound_protocol(
    my_sim2,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )

  expect_no_message(
    suppressWarnings(
      add_simulation(
        ddi,
        my_sim,
        options = list(add_interactions = TRUE, add_processes = TRUE)
      )
    )
  )

  expect_no_message(
    suppressWarnings(
      add_simulation(
        ddi,
        my_sim2,
        options = list(add_interactions = TRUE, add_processes = TRUE)
      )
    )
  )

  expect_snapshot(my_sim)
  expect_snapshot(my_sim2)
  expect_snapshot(ddi)
})

test_that("Add simulation without compound protocol works", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  expect_no_message(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = FALSE, add_processes = FALSE)
    )
  )
  expect_snapshot(my_sim)
})


test_that("Add simulation with identical name throws an error.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  # First add a simulation
  my_sim <- create_simulation(
    simulation_name = "Test9",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )
  add_simulation(
    ddi,
    my_sim,
    options = list(add_interactions = FALSE, add_processes = FALSE)
  )

  # Try to add another with the same name
  expect_error(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = FALSE, add_processes = FALSE)
    ),
    "Simulation with name `Test9` already exists.",
    fixed = TRUE
  )
})

test_that("Add simulation with inexistant individual throws an error.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Human"
  )
  expect_error(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = FALSE, add_processes = FALSE)
    ),
    "Individual `Human` not found in snapshot.",
    fixed = TRUE
  )
})

test_that("Add a simulation with inexistant protocol throws an error.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "Inexistant Protocol"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "Inexistant Protocol2"
  )

  expect_error(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = FALSE, add_processes = FALSE)
    )
  )
})

test_that("Add a simulation with inexistant formulation throws an error.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test10",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "Inexistant Formulation"
  )
  expect_error(
    add_simulation(ddi, my_sim),
    "Formulations `Inexistant Formulation` not found in snapshot.",
    fixed = TRUE
  )
})

test_that("Add a simulation with missing formulation for a protocol throws an error.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test11",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  # Missing formulation for Itraconazole
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days"
  )
  expect_error(
    add_simulation(ddi, my_sim),
    "Missing formulation key(s) `Formulation` for protocol `ITZ 100mg 21 days`.",
    fixed = TRUE
  )
})

test_that("Add a simulation with an unknown population throws an error", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    population = "UnknowPop"
  )
  set_compound_protocol(
    my_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    my_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )

  expect_snapshot(my_sim)

  expect_error(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = FALSE, add_processes = FALSE)
    ),
    "Population `UnknowPop` not found in snapshot."
  )
})
