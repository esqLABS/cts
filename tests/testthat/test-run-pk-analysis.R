test_that("run pk analysis works", {
  my_ddi <- get_test_ddi()

  expect_snapshot(run_pk_analysis(my_ddi))
})
