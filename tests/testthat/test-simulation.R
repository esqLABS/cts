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


test_that("Correct simulation can be added to a ddi object.", {
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

test_that("Simulation with identical name throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Generic DDI simulation",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  expect_error(add_simulation(ddi, my_sim), "Simulation with name `Generic DDI simulation` already exists.", fixed = TRUE)
})

test_that("Simulation with inexistant individual throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "Human"
  )
  expect_error(add_simulation(ddi, my_sim), "Individual `Human` not found in snapshot.", fixed = TRUE)
})

test_that("Simulation with inexistant protocol throws an error.", {
  ddi <- suppressWarnings(create_ddi(rifampicin, midazolam))
  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Rifampicin",
    perpetrators = "Midazolam",
    individual = "European (P-gp modified, CYP3A4 36 h)"
  )
  set_compound_protocol(my_sim, compound = "Rifampicin", protocol = "Inexistant Protocol")
  set_compound_protocol(my_sim, compound = "Midazolam", protocol = "Inexistant Protocol2")

  expect_error(add_simulation(ddi, my_sim), "Protocols `Inexistant Protocol` and `Inexistant Protocol2` not found in snapshot." , fixed = TRUE)
})

test_that("Simulation with inexistant formulation throws an error.", {
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

test_that("Simulation with missing formulation for a protocol throws an error.", {
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

test_that("Adding unknowkn interactions throws a warning.", {
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
    c("Organism|VenousBlood|Plasma|Midazolam|Concentration in container",
      "Organism|VenousBlood|Plasma|Rifampicin|Concentration in container")
  )
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

test_that("Adding unknowkn processes throws a warning.", {
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
