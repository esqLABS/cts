test_that("run_pk_analysis works", {
  my_ddi <- get_test_ddi()

  expect_no_error(run_pk_analysis(my_ddi))

})
