lng <- levonorgestrel$clone()
# keep 2 pop sim
remove_simulation(lng, simulation_name = lng$get_names("simulations")[-c(1,3)])
# reduce n_individual for tests
lng$populations[[1]]$Settings$NumberOfIndividuals <- 3
lng$populations[[3]]$Settings$NumberOfIndividuals <- 3

test_that("for_single_sim", {
  testthat::skip_on_os("mac")
  my_ddi <- get_test_ddi()
  expect_no_error(run_pk_analysis(my_ddi))
  expect_snapshot(my_ddi$get_pk_analysis())
  expect_snapshot(pretty_pk(my_ddi, molecule_name = "Levonorgestrel 1", pk_parameter = c("C_max", "C_tEnd")))
  expect_snapshot(compare_pk(my_ddi))

})

test_that("for pop simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(lng$get_pk_analysis(aggregation = "median", digits = 5))
  expect_snapshot(pretty_pk(lng, molecule_name = "Levonorgestrel 1", pk_parameter = c("AUC_tEnd", "C_tEnd")))
  expect_snapshot(compare_pk(lng))
  expect_snapshot(compare_pk(lng, reference_simulation = "Bayer Study 19604 - control Day 1"))

})

