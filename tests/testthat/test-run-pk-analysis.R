test_that("run_pk_analysis works", {
  my_ddi <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))

  run_ddi(my_ddi)

  expect_snapshot(run_pk_analysis(my_ddi))
  expect_snapshot(my_ddi$pk_analysis_raw)
})
