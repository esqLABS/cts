test_that("OutputSchema can be initialized.", {
  expect_no_message(
    SnapshotOutputSchema$new()
  )
})

test_that("OutputSchema print method works.", {
  expect_snapshot(
    SnapshotOutputSchema$new()
  )
})

test_that("`set_interval` can clear and add intervals to the schema.", {
  output_schema <- SnapshotOutputSchema$new()
  output_schema$set_interval(start_time = 0, end_time = 60, resolution = 1, unit = "min")

  expect_snapshot(output_schema)
})

test_that("`add_interval` works", {
  output_schema <- SnapshotOutputSchema$new()
  output_schema$add_interval(start_time = 0, end_time = 70, resolution = 2, unit = "min")

  expect_snapshot(output_schema)
})


test_that("`set interval` check numeric value of input.", {
  output_schema <- SnapshotOutputSchema$new()
  expect_error(output_schema$set_interval(start_time = "a", end_time = 60, resolution = 1, unit = "min"),
  "`start_time`, `end_time` and `resolution` must be numeric.")
})

test_that("`set interval` check validity of unit", {
  output_schema <- SnapshotOutputSchema$new()
  expect_error(
    output_schema$set_interval(start_time = 0, end_time = 60, resolution = 1, unit = "minutes"),
    "`unit` must be a valid time unit"
  )
})
