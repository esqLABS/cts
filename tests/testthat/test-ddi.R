test_that("DDI snapshots can be imported", {
  expect_no_error(
    import_ddi(test_path("data/Levonorgestrel-Itraconazole-DDI.json"))
  )
})

test_that("DDI can be created from two compounds", {
  expect_no_error(
    suppressWarnings(
      create_ddi(itraconazole, levonorgestrel)
    )
  )
})

test_that("Compounds snapshots are correctly merged when creating a DDI", {
  ddi_merged <- suppressWarnings(create_ddi(itraconazole, levonorgestrel))

  ddi_ref <- import_ddi(test_path("data/Levonorgestrel-Itraconazole-DDI.json"))

  expect_equal(ddi_merged$compounds, ddi_ref$compounds)

  expect_equal(ddi_merged$individuals, ddi_ref$individuals)

  expect_equal(ddi_merged$populations, ddi_ref$populations)

  expect_equal(ddi_merged$formulations, ddi_ref$formulations)

  expect_equal(ddi_merged$protocols, ddi_ref$protocols)

  expect_equal(ddi_merged$expression_profiles, ddi_ref$expression_profiles)

  expect_equal(ddi_merged$observer_sets, ddi_ref$observer_sets)

  expect_equal(ddi_merged$events, ddi_ref$events)

  expect_equal(ddi_merged$simulations, ddi_ref$simulations)

  expect_equal(ddi_merged$observed_data, ddi_ref$observed_data)
})

test_that("Compound snapshot with different versions can be merged", {
  ddi <- create_ddi(itraconazole80, rifampicin)

  expect_equal(ddi$data$Version, 80)
})

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
