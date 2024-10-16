test_that("DDI snapshots can be imported", {
  expect_no_error(
    import_ddi(test_path("data/Levonorgestrel-Itraconazole-DDI.json"))
  )
})

test_that("create_ddi prints the correct status message", {
  expect_snapshot(
    capture_messages(
      suppressWarnings(ddi <- create_ddi(rifampicin, c(midazolam, midazolam)))
    )
  )
})

test_that("print ddi object works", {
  expect_snapshot(
    levo_itra_ddi
  )

  ddi <- DDI$new()
  expect_error({
    ddi$print()
  })
})


test_that("DDI can be created from two compounds", {
  expect_no_error(
    suppressWarnings(
      create_ddi(levonorgestrel, itraconazole)
    )
  )
})

test_that("options are checked", {
  # option is not a list
  expect_error(create_ddi(levonorgestrel, itraconazole, options = 1))
  # unsuported option
  expect_error(create_ddi(levonorgestrel, itraconazole, options = list(bad_option = 1)))
  # bad option value
  expect_error(suppressMessages(create_ddi(levonorgestrel, itraconazole, options = list(import_simulations = 1))))
})

test_that("Compounds snapshots are correctly merged when creating a DDI", {
  ddi_merged <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))

  ddi_ref <- levo_itra_ddi

  expect_equal(ddi_merged$compounds, ddi_ref$compounds)

  expect_equal(ddi_merged$individuals, ddi_ref$individuals)

  expect_equal(ddi_merged$populations, ddi_ref$populations)

  expect_equal(ddi_merged$formulations, ddi_ref$formulations)

  expect_equal(ddi_merged$protocols, ddi_ref$protocols)

  expect_equal(ddi_merged$expression_profiles, ddi_ref$expression_profiles)

  expect_equal(ddi_merged$observer_sets, ddi_ref$observer_sets)

  expect_equal(ddi_merged$events, ddi_ref$events)

  expect_equal(ddi_merged$observed_data, ddi_ref$observed_data)

  # Compare simulations when they are imported (import_simulations = TRUE)
  ddi_merged <- suppressWarnings(create_ddi(levonorgestrel, itraconazole,
    options = list(
      import_simulations = TRUE,
      create_ddi_simulation = FALSE
    )
  ))

  expect_equal(ddi_merged$simulations, ddi_ref$simulations)
})

# test_that("Compound snapshot with different versions can be merged", {
#   ddi <- create_ddi(itraconazole80, rifampicin)
#
#   expect_equal(ddi$data$Version, 80)
# })

test_that("An error is thrown when victim or perpetrator are missing", {
  expect_error(
    create_ddi(perpetrator = midazolam),
    "At least one victim compound must be provided."
  )

  expect_error(
    create_ddi(victim = rifampicin),
    "At least one perpetrator compound must be provided."
  )
})

test_that("An error is thrown when victim is not length 1", {
  expect_error(
    create_ddi(victim = c(rifampicin, midazolam), perpetrator = midazolam),
    "Please provide exactly one victim compound."
  )
})

test_that("An error is thrown when victim or perpetrator are not a Compound", {
  expect_error(
    create_ddi(rifampicin, "not a compound"),
    "All compounds must be of class 'Compound'"
  )
  expect_error(
    create_ddi(rifampicin, list(midazolam, "not a compound")),
    "All compounds must be of class 'Compound'"
  )
  expect_error(
    create_ddi(rifampicin, list(midazolam, NULL)),
    "All compounds must be of class 'Compound'"
  )

  expect_error(
    create_ddi("not a compound", rifampicin),
    "All compounds must be of class 'Compound'"
  )
})

test_that("DDI can be exported", {
  temp_file <- withr::local_tempfile(fileext = ".json")

  export_ddi(levo_itra_ddi, temp_file)

  expect_snapshot_file(temp_file, name = "exported_ddi_snapshot.json")
})
