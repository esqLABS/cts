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
  output_schema$set_interval(start_time = 0, end_time = 6, resolution = 30, unit = "month(s)")

  expect_snapshot(output_schema)
})

test_that("Conversion of resolution works", {
  output_schema <- SnapshotOutputSchema$new()
  output_schema$set_interval(start_time = 0, end_time = 6, resolution = 30, unit = "month(s)")
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Value, 30/ospsuite::toUnit("Time", 1, "day(s)", "month(s)"))
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Unit, "pts/day")

  output_schema$set_interval(start_time = 0, end_time = 6, resolution = 365.25, unit = "year(s)")
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Value, 1)
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Unit, "pts/day")

  output_schema$set_interval(start_time = 0, end_time = 6, resolution = 7, unit = "week(s)")
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Value, 1)
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Unit, "pts/day")

  output_schema$set_interval(start_time = 0, end_time = 6, resolution = 1000, unit = "ks")
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Value, 1)
  expect_equal(output_schema$data[[1]]$Parameters[[3]]$Unit, "pts/s")
})

test_that("`add_interval` works", {
  output_schema <- SnapshotOutputSchema$new()
  output_schema$add_interval(start_time = 0, end_time = 70, resolution = 2, unit = "min")

  expect_snapshot(output_schema)
})


test_that("`set interval` check numeric value of input.", {
  output_schema <- SnapshotOutputSchema$new()
  expect_error(
    output_schema$set_interval(start_time = "a", end_time = 10, resolution = 1, unit = "week(s)"),
    "`start_time`, `end_time` and `resolution` must be numeric."
  )
})

test_that("`set interval` check validity of unit", {
  output_schema <- SnapshotOutputSchema$new()
  expect_error(
    output_schema$set_interval(start_time = 0, end_time = 60, resolution = 1, unit = "minutes"),
    "`unit` must be a valid time unit"
  )
})
