lng <- levonorgestrel$clone()
# keep 2 pop sim
remove_simulation(lng, simulation_name = lng$get_names("simulations")[-c(1,3)])
# reduce n_individual for tests
lng$populations[[1]]$number_of_individuals <- 3
lng$populations[[3]]$number_of_individuals <- 3

test_that("for_single_sim", {
  testthat::skip_on_os("mac")
  my_ddi <- get_test_ddi()
  expect_no_error(suppressWarnings(run_pk_analysis(my_ddi)))
  expect_snapshot(suppressWarnings(my_ddi$get_pk_analysis()))
  expect_snapshot(suppressWarnings(pretty_pk(my_ddi)))
  expect_snapshot(suppressWarnings(compare_pk(my_ddi, molecule_name = "Levonorgestrel 1", pk_parameter = c("AUC_tEnd", "C_tEnd"))))
  expect_snapshot(suppressWarnings(compare_pk(my_ddi, aggregation = "median")))

})

test_that("for pop simulation", {
  testthat::skip_on_os("mac")
  expect_snapshot(suppressWarnings(lng$get_pk_analysis(aggregation = "median", digits = 5)))
  expect_snapshot(suppressWarnings(lng$get_pk_analysis(aggregation = "mean", digits = 5)))
  expect_snapshot(suppressWarnings(pretty_pk(lng, aggregation = "median")))
  expect_snapshot(suppressWarnings(pretty_pk(lng, aggregation = "mean", molecule_name = "Levonorgestrel 1", pk_parameter = c("AUC_tEnd", "C_tEnd"))))
  expect_snapshot(suppressWarnings(compare_pk(lng, aggregation = "median", simulation_name = "Bayer Study 19604 - control Day 1")))
  expect_snapshot(suppressWarnings(compare_pk(lng, aggregation = "median",  reference_simulation_name = "Bayer Study 19604 - control Day 1")))
  expect_snapshot(suppressWarnings(compare_pk(lng, aggregation = "mean", reference_simulation_name = "Bayer Study 19604 - control Day 1")))
})

