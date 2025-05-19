test_that("ddi generic simulation can be run", {
  testthat::skip_on_os("mac")

  expect_snapshot(dplyr::glimpse(get_test_ddi_results()[[1]]))
})

test_that("run ddi arguments work as expected", {
  testthat::skip_on_os("mac")

  my_ddi <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))

  temp_dir <- tempfile()
  dir.create(temp_dir)
  results <- run_ddi(my_ddi, path = temp_dir, exportPKML = TRUE)

  expect_true(length(list.files(temp_dir, pattern = ".csv")) > 0)
  expect_true(length(list.files(temp_dir, pattern = ".pkml")) > 0)
})


test_that("Run added simulations works", {
  testthat::skip_on_os("mac")

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

  suppressWarnings(
    add_simulation(
      ddi,
      my_sim,
      options = list(add_interactions = TRUE, add_processes = TRUE)
    )
  )

  suppressWarnings(
    add_simulation(
      ddi,
      my_sim2,
      options = list(add_interactions = TRUE, add_processes = TRUE)
    )
  )

  temp_dir <- tempfile()
  dir.create(temp_dir)

  results <- run_ddi(ddi)

  expect_snapshot(dplyr::glimpse(results[[1]]))
  expect_snapshot(dplyr::glimpse(results[[2]]))
})
