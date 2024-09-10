test_that("model_library_url works", {
  expect_true(!is.null(jsonlite::fromJSON(model_library_url)))
})

test_that("get_osp_model_library retrieves and format data as expected", {
  model_library_data <- get_osp_model_library()
  expect_true(is.list(model_library_data))
  expect_true(all(names(model_library_data) != ""))
  expect_true(all(sapply(model_library_data, function(x) grepl("https://", x))))
})

test_that("available componds building blocks are listed", {
  suppressMessages({
    expect_true(length(list_compounds()) > 0)
  })
})
