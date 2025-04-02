test_that("ddi generic simulation can be run", {
  testthat::skip_on_os("mac")
  my_ddi <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))

  results <- run_ddi(my_ddi)
  expect_type(results, "list")
  expect_true(length(results) > 0)
  expect_true(is.data.frame(results[[1]]))
  expect_true(nrow(results[[1]]) > 0)
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
