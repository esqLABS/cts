test_that("PD Calculation works", {
  testthat::skip_on_os("mac")

  # clone levonorgestrel snapshot and remove all simulations
  levo_itra <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))
  sim_to_remove <- levo_itra$get_names("simulations")
  remove_simulation(levo_itra, sim_to_remove)

  # add simulation with levonorgestrel only
  levo_only_sim <- create_simulation(
    simulation_name = "Levonorgestrel only",
    victim = "Levonorgestrel 1",
    individual = "Woman"
  )
  set_compound_protocol(
    levo_only_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_output_interval(
    levo_only_sim,
    start_time = 0,
    end_time = 21,
    unit = "day(s)",
    resolution = 24
  )

  suppressWarnings(
    add_simulation(
      levo_itra,
      levo_only_sim,
      options = list(add_interactions = TRUE, add_processes = TRUE)
    )
  )

  # add simulation with levonorgestrel and itraconazole only
  levo_itra_sim <- create_simulation(
    simulation_name = "Levonorgestrel + Itraconazole",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    individual = "Woman"
  )
  set_compound_protocol(
    levo_itra_sim,
    compound = "Levonorgestrel 1",
    protocol = "LNG_150 ug_21 Days",
    formulation = "Microlut"
  )
  set_compound_protocol(
    levo_itra_sim,
    compound = "Itraconazole",
    protocol = "ITZ 100mg 21 days",
    formulation = "IR Dissolved"
  )
  set_output_interval(
    levo_itra_sim,
    start_time = 0,
    end_time = 21,
    unit = "day(s)",
    resolution = 24
  )

  suppressWarnings(
    add_simulation(
      levo_itra,
      levo_itra_sim,
      options = list(add_interactions = TRUE, add_processes = TRUE)
    )
  )

  resPEARL <- pearlIndex(levo_itra)
  resOR <- ovulationRate(levo_itra)

  expect_equal(resPEARL$"Levonorgestrel only", 69.37474)
  expect_equal(resPEARL$"Levonorgestrel + Itraconazole", 66.7824156)
  expect_equal(resOR$"Levonorgestrel only", 98.0770419)
  expect_equal(resOR$"Levonorgestrel + Itraconazole", 96.8524025)

})
