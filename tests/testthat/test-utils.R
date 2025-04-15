test_that("check_internet works", {
  expect_no_error(check_internet())
})

test_that("is_file_url works", {
  expect_true(is_file_url(
    "https://raw.githubusercontent.com/Open-Systems-Pharmacology/OSPSuite.BuildingBlockTemplates/main/templates.json"
  ))
  expect_false(is_file_url("path/to/file"))
})

test_that("is_file_local works", {
  expect_true(is_file_local(test_path("data", "Itraconazole-Model.json")))
  expect_false(is_file_local(test_path("data")))
})

test_that("to_list works as expected", {
  expect_equal(to_list(NULL), list(NULL))
  expect_equal(to_list(c(1, 2)), list(1, 2))
  expect_equal(to_list(c("a", "b")), list("a", "b"))
  expect_equal(to_list(list(1, 2)), list(1, 2))
  expect_equal(to_list(list(rifampicin)), to_list(rifampicin))
  expect_equal(to_list(c(rifampicin, midazolam)), list(rifampicin, midazolam))
})

test_that("with_json_suffix works correctly", {
  # Test with paths that don't have .json suffix
  expect_equal(with_json_suffix("file"), "file.json")
  expect_equal(
    with_json_suffix(c("file1", "file2")),
    c("file1.json", "file2.json")
  )

  # Test with paths that already have .json suffix
  expect_equal(with_json_suffix("file.json"), "file.json")
  expect_equal(
    with_json_suffix(c("file1.json", "file2")),
    c("file1.json", "file2.json")
  )

  # Test with empty string
  expect_equal(with_json_suffix(""), ".json")
})

test_that("pivot_pk_analysis works correctly", {
  # Create a sample PK analysis data frame
  pk_data <- tibble::tibble(
    QuantityPath = c(
      "Path|CompoundA|More",
      "Path|CompoundB|More",
      "Path|CompoundA|Other"
    ),
    Value = c(1.5, 2.5, 3.5),
    IndividualId = c(1, 1, 1)
  )

  compound_names <- c("CompoundA", "CompoundB")

  result <- pivot_pk_analysis(pk_data, compound_names)

  # Check structure of result
  expect_true(tibble::is_tibble(result))
  expect_equal(nrow(result), 2)

  # Check columns
  expect_true(all(
    c("QuantityPath", "CompoundA", "CompoundB") %in% colnames(result)
  ))

  # Check data transformation
  expect_equal(result$QuantityPath, c("Path|More", "Path|Other"))
  expect_equal(result$CompoundA, c(1.5, 3.5))
  expect_equal(result$CompoundB[1], 2.5)
  expect_true(is.na(result$CompoundB[2]))
})

test_that("translate_end_time_unit works correctly", {
  # Test all available time units
  expect_equal(translate_end_time_unit("s"), 1)
  expect_equal(translate_end_time_unit("min"), 60)
  expect_equal(translate_end_time_unit("ks"), 1000)
  expect_equal(translate_end_time_unit("h"), 3600)
  expect_equal(translate_end_time_unit("day(s)"), 86400)
  expect_equal(translate_end_time_unit("week(s)"), 604800)
  expect_equal(translate_end_time_unit("month(s)"), 2628000)
  expect_equal(translate_end_time_unit("year(s)"), 31536000)
})
