test_that("buildingblocks_url works", {
  expect_true(!is.null(jsonlite::fromJSON(buildingblocks_url)))
})

test_that("get_buildingblocks_data retrieves and format data as expected", {
  buildingblocks_data <- get_buildingblocks_data()
  expect_true(is.list(buildingblocks_data))
  expect_true(all(names(buildingblocks_data) != ""))
  expect_true(all(sapply(buildingblocks_data, function(x) grepl("https://", x))))
})

test_that("available componds building blocks are listed", {
  suppressMessages({
    expect_true(length(list_compounds()) > 0)
  })
})

test_that("download building block works", {
  suppressMessages({
    expect_true(is.list(compound("Rifampicin")))
  })
})
