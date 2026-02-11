my_ddi <- get_test_ddi()

lng <- levonorgestrel$clone()
# keep 2 pop sim
remove_simulation(lng, simulation_name = lng$get_names("simulations")[-c(1,3)])
# reduce n_individual for tests
lng$populations[[1]]$Settings$NumberOfIndividuals <- 3
lng$populations[[3]]$Settings$NumberOfIndividuals <- 3

test_that("run_pk_analysis works", {
  testthat::skip_on_os("mac")
  expect_no_error(run_pk_analysis(my_ddi))
})

test_that("get_pk_analysis works for single simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(my_ddi$get_pk_analysis())
})

test_that("get_pk_analysis works for pop simulation", {
  testthat::skip_on_os("mac")

  expect_snapshot(lng$get_pk_analysis(aggregation = "median", digits = 5))
})

test_that("pretty_pk works for single simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(pretty_pk(my_ddi, molecule_name = "Levonorgestrel 1", pk_parameter = c("C_max", "C_tEnd")))
})

test_that("pretty_pk works for pop simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(pretty_pk(lng, molecule_name = "Levonorgestrel 1", pk_parameter = c("AUC_tEnd", "C_tEnd")))
})

test_that("compare_pk for single simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(compare_pk(my_ddi))
})

test_that("compare_pk works for pop simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(compare_pk(lng))
  expect_snapshot(compare_pk(lng, reference_simulation = "Bayer Study 19604 - control Day 1"))
})
