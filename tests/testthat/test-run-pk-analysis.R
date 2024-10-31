test_that("run_pk_analysis works", {
  my_ddi <- get_test_ddi()

  expect_snapshot(run_pk_analysis(my_ddi))
})
