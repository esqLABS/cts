test_that("protocol can be initialized", {
  expect_no_message(Protocol$new(name = "Test protocol", type = "ivb", interval = "single", dose = 300))
})

test_that("Advanced protocol can be initialized", {
  expect_no_message(AdvancedProtocol$new(name = "Test protocol"))
})

test_that("Schema can be added to advanced protocols.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  expect_no_message(
    add_schema_to_protocol(advanced_protocol = prot, start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min")
  )
})

test_that("Adding schema with already existing name does not work.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  add_schema_to_protocol(advanced_protocol = prot, start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min")

  expect_error(
    add_schema_to_protocol(advanced_protocol = prot, schema_name = "Schema 1", start_time = 0, start_time_unit = "h", rep_nb = 2, time_btw_rep = 1, time_btw_rep_unit = "h"),
    "Schema `Schema 1` already exists."
  )
})

test_that("Protocol can be added to schema.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  add_schema_to_protocol(advanced_protocol = prot, start_time = 2, start_time_unit = "h", rep_nb = 5, time_btw_rep = 10, time_btw_rep_unit = "min")

  expect_no_message(
    add_protocol_to_schema(
      advanced_protocol = prot,
      protocol = Protocol$new(name = "Test protocol", type = "ivb", interval = "single", dose = 300),
      schema_name = "Schema 1")
  )
})
