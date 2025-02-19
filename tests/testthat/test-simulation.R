# Simulation Creation -----------------------------------------------------

test_that("Simulation can be initialized.", {
  expect_no_message(
    create_simulation(
      simulation_name = "Test",
      victim = "Rifampicin",
      perpetrators = "Midazolam",
      individual = "European (P-gp modified, CYP3A4 36 h)"
    )
  )
})

# Parameterize Simulation -------------------------------------------------

test_that("`add_compound` can add compounds to the simulation.", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_no_message(my_sim$add_compound(compound = "Test compound 2", protocol = "New protocol"))
  expect_snapshot(my_sim)
})

test_that("`set_compound_protocol` can set a new protocol for a compound.", {
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_no_message(set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)"))
  expect_no_message(set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Tablet (Dormicum)"))))
  expect_snapshot(my_sim)
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
  set_compound_protocol(my_sim, compound = "Levonorgestrel 1", protocol = "LNG_150 ug_21 Days", formulation = list(list(Key = "Formulation", Name = "Microlut")))
  set_compound_protocol(my_sim, compound = "Itraconazole", protocol = "ITZ 100mg 21 days", formulation = list(list(Key = "Formulation", Name = "IR Dissolved")))

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
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_snapshot(my_sim)

  add_outputs(my_sim, "Organism|ArterialBlood|Plasma|Rifampicin|Concentration in container")
  expect_snapshot(my_sim)

  set_outputs(
    my_sim,
    c(
      "Organism|VenousBlood|Plasma|Midazolam|Concentration in container",
      "Organism|VenousBlood|Plasma|Rifampicin|Concentration in container"
    )
  )
  expect_snapshot(my_sim)
})

test_that("Simulation output interval can be set and added", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Tablet (Dormicum)")))
  expect_no_message(set_output_interval(my_sim, start_time = 0, end_time = 2, resolution = 20, unit = "h"))
  expect_no_message(add_output_interval(my_sim, start_time = 2, end_time = 48, resolution = 1, unit = "h"))
  expect_snapshot(my_sim)
  expect_snapshot(add_simulation(ddi, my_sim))
})


# Simulations parameters checked when added to snapshot -------------------

test_that("Adding default interactions works.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  expect_warning(add_simulation(ddi, my_sim, options = list(add_interactions = TRUE, add_processes = FALSE)), "Automatically adding interactions to the simulation.\nUsing first interaction found for each enzyme/compound pair.")
  expect_snapshot(my_sim)
})

test_that("Adding manual interactions works.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  add_interactions(my_sim, "Rifampicin", interactions = c("CYP3A4-Kajosaari 2005", "P-gp-Reitman 2011"))

  expect_no_message(add_simulation(ddi, my_sim, list(add_interactions = FALSE, add_processes = FALSE)))
})

test_that("Adding unknown interactions throws a warning.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  add_interactions(my_sim, "Rifampicin", interactions = c("CYP3A8-Kajo", "P-gp-Reitman 2011"))

  expect_warning(add_simulation(ddi, my_sim, list(add_interactions = FALSE, add_processes = FALSE)), "Interaction `CYP3A8-Kajo` not found for compound `Rifampicin` in snapshot. Skipping.")
  expect_snapshot(my_sim)
})


test_that("Adding default processes works.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  # nested test of Rifampicin and Midazolam warnings
  expect_warning(
    expect_warning(
      add_simulation(ddi, my_sim, options = list(add_interactions = FALSE, add_processes = TRUE)),
      "Automatically adding processes to the simulation for compound `Rifampicin`.\nUsing first processes of each type and of each metabolizing enzyme found."
    ),
    "Automatically adding processes to the simulation for compound `Midazolam`.\nUsing first processes of each type and of each metabolizing enzyme found."
  )

  expect_snapshot(my_sim)
})

test_that("Adding processes to a simulation compound works.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  expect_snapshot(my_sim)

  add_processes(my_sim, compound = "Rifampicin", c("AADAC-Nakajima 2011", "P-gp-Collett 2004"))
  add_processes(my_sim, compound = "Midazolam", "CYP3A4-Optimized")
  expect_snapshot(my_sim)

  expect_no_message(add_simulation(ddi, my_sim, options = list(add_interactions = FALSE)))
})

test_that("Adding unknown processes throws a warning.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Oral solution")))

  add_processes(my_sim, "Rifampicin", "CYP3A8-Kajo")

  expect_warning(add_simulation(ddi, my_sim, options = list(add_processes = FALSE)), "Process `CYP3A8-Kajo` not found for compound `Rifampicin` in snapshot. Skipping.")
  expect_snapshot(my_sim)
})



# Add Simulation to snapshot ----------------------------------------------

test_that("Add a valid simulation works", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Tablet (Dormicum)")))

  expect_no_message(add_simulation(ddi, my_sim, options = list(add_interactions = FALSE, add_processes = FALSE)))
})

test_that("Add simulation without compound protocol works", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_no_message(add_simulation(ddi, my_sim, options = list(add_interactions = FALSE, add_processes = FALSE)))
  expect_snapshot(my_sim)
})


test_that("Add simulation with identical name throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Generic DDI simulation",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_error(add_simulation(ddi, my_sim), "Simulation with name `Generic DDI simulation` already exists.", fixed = TRUE)
})

test_that("Add simulation with inexistant individual throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "Human"
  )
  expect_error(add_simulation(ddi, my_sim), "Individual `Human` not found in snapshot.", fixed = TRUE)
})

test_that("Add a simulation with inexistant protocol throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "Inexistant Protocol")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "Inexistant Protocol2")

  expect_error(add_simulation(ddi, my_sim), "Protocols `Inexistant Protocol` and `Inexistant Protocol2` not found in snapshot.", fixed = TRUE)
})

test_that("Add a simulation with inexistant formulation throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg", formulation = list(list(Key = "Formulation", Name = "Inexistant Formulation")))
  expect_error(add_simulation(ddi, my_sim), "Formulations `Inexistant Formulation` not found in snapshot.", fixed = TRUE)
})

test_that("Add a simulation with missing formulation for a protocol throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "iv 300 mg (0.5 h)")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "po 3.5 mg")
  expect_error(add_simulation(ddi, my_sim), "Missing formulation key(s) `Formulation` for protocol `po 3.5 mg`.", fixed = TRUE)
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
  set_compound_protocol(my_sim, compound = "Levonorgestrel 1", protocol = "LNG_150 ug_21 Days", formulation = list(list(Key = "Formulation", Name = "Microlut")))
  set_compound_protocol(my_sim, compound = "Itraconazole", protocol = "ITZ 100mg 21 days", formulation = list(list(Key = "Formulation", Name = "IR Dissolved")))

  expect_snapshot(my_sim)

  expect_error(add_simulation(ddi, my_sim), "Population `UnknowPop` not found in snapshot.")
})
