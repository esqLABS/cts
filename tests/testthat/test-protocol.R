test_that("protocol can be initialized", {
  expect_no_message(Protocol$new(name = "Test protocol", type = "ivb", interval = "single", dose = 300))
})

test_that("Advanced protocol can be initialized", {
  expect_no_message(AdvancedProtocol$new(name = "Test protocol"))
})

test_that("Schema can be added and removed to/from advanced protocols.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  expect_no_message({
    add_schema(
      advanced_protocol = prot,
      start_time = 2, start_time_unit = "h",
      rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min",
      schema_name = "Schema 1"
    )
    remove_schema(advanced_protocol = prot, schema_name = "Schema 1")
  })
})

test_that("Adding schema with already existing name does not work.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  add_schema(advanced_protocol = prot, start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min")

  expect_error(
    add_schema(advanced_protocol = prot, schema_name = "Schema 1", start_time = 0, start_time_unit = "h", rep_nb = 2, time_btw_rep = 1, time_btw_rep_unit = "h"),
    "Schema `Schema 1` already exists."
  )
})

test_that("Administration can be added, replaced and removed to/from schema.", {
  prot <- create_advanced_protocol(name = "Test protocol") |>
    add_schema(schema_name = "my Schema", start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min") |>
    add_administration(
      administration = create_protocol(name = "Test protocol", type = "ivb", interval = "single", dose = 300),
      schema_name = "my Schema"
    )

  expect_message(
    prot |>
    add_administration(
      administration = create_protocol(name = "Test protocol", type = "ivb", interval = "single", dose = 400),
      schema_name = "my Schema"
    )
    )

  expect_no_error(
    prot |>
    remove_administration(schema_name = "my Schema", administration_name = "Test protocol (schema item 2)")
  )
})

test_that("Advanced protocol are corectly printed", {
  expect_snapshot(
    create_advanced_protocol(name = "Test protocol") |>
      add_schema(schema_name = "my Schema", start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min") |>
      add_administration(
        administration = create_protocol(name = "Test protocol", type = "ivb", interval = "single", dose = 300),
        schema_name = "my Schema"
      )
  )
})
