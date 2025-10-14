test_that("protocol can be initialized", {
  expect_no_message(Protocol$new(
    name = "Test protocol",
    type = "ivb",
    interval = "single",
    dose = 300
  ))
})

test_that("Advanced protocol can be initialized", {
  expect_no_message(AdvancedProtocol$new(name = "Test protocol"))
})

test_that("Schema can be added and removed to/from advanced protocols.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  expect_no_message({
    add_schema(
      advanced_protocol = prot,
      start_time = 2,
      start_time_unit = "h",
      rep_nb = 5,
      time_btw_rep = 10,
      time_btw_rep_unit = "min",
      schema_name = "Schema 1"
    )
    remove_schema(advanced_protocol = prot, schema_name = "Schema 1")
  })
})

test_that("Adding schema with already existing name does not work.", {
  prot <- AdvancedProtocol$new(name = "Test protocol")
  add_schema(
    advanced_protocol = prot,
    start_time = 2,
    start_time_unit = "h",
    rep_nb = 5,
    time_btw_rep = 10,
    time_btw_rep_unit = "min"
  )

  expect_error(
    add_schema(
      advanced_protocol = prot,
      schema_name = "Schema 1",
      start_time = 0,
      start_time_unit = "h",
      rep_nb = 2,
      time_btw_rep = 1,
      time_btw_rep_unit = "h"
    ),
    "Schema `Schema 1` already exists."
  )
})

test_that("Administration can be added, replaced and removed to/from schema.", {
  prot <- create_advanced_protocol(name = "Test protocol") |>
    add_schema(
      schema_name = "my Schema",
      start_time = 2,
      start_time_unit = "h",
      rep_nb = 5,
      time_btw_rep = 10,
      time_btw_rep_unit = "min"
    ) |>
    add_administration(
      administration = create_protocol(
        name = "Test protocol",
        type = "ivb",
        interval = "single",
        dose = 300
      ),
      schema_name = "my Schema"
    )

  expect_message(
    prot |>
      add_administration(
        administration = create_protocol(
          name = "Test protocol",
          type = "ivb",
          interval = "single",
          dose = 400
        ),
        schema_name = "my Schema"
      )
  )

  expect_no_error(
    prot |>
      remove_administration(
        schema_name = "my Schema",
        administration_name = "Test protocol (schema item 2)"
      )
  )
})

test_that("Advanced protocol are corectly printed", {
  expect_snapshot(
    create_advanced_protocol(name = "Test protocol") |>
      add_schema(
        schema_name = "my Schema",
        start_time = 2,
        start_time_unit = "h",
        rep_nb = 5,
        time_btw_rep = 10,
        time_btw_rep_unit = "min"
      ) |>
      add_administration(
        administration = create_protocol(
          name = "Test protocol",
          type = "ivb",
          interval = "single",
          dose = 300
        ),
        schema_name = "my Schema"
      )
  )
})

test_that("create_protocol wrapper works", {
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  expect_s3_class(protocol, "Protocol")
  expect_equal(protocol$name, "Test Protocol")
  expect_equal(protocol$type, "oral")
  expect_equal(protocol$interval, "24")
  expect_equal(protocol$dose, 500)
  expect_equal(protocol$dose_unit, "mg")
})

test_that("add_protocol and remove_protocol wrappers work", {
  # Create a compound snapshot
  test_snap <- Snapshot$new(rifampicin$source)

  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Get original count
  original_count <- length(test_snap$protocols)

  # Add protocol
  test_snap <- add_protocol(test_snap, protocol)

  # Check protocol was added
  expect_equal(length(test_snap$protocols), original_count + 1)
  expect_true("Test Protocol" %in% test_snap$get_names("protocols"))

  # Remove protocol
  test_snap <- remove_protocol(test_snap, "Test Protocol")

  # Check protocol was removed
  expect_equal(length(test_snap$protocols), original_count)
  expect_false("Test Protocol" %in% test_snap$get_names("protocols"))
})

test_that("Protocol setters and getters work correctly", {
  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Test immutable type
  expect_error(protocol$type <- "iv")

  # Test interval setter
  protocol$interval <- "12-12"
  expect_equal(protocol$interval, "12-12")

  # Test interval validation
  expect_error(protocol$interval <- "invalid")

  # Test dose setter
  protocol$dose <- 1000
  expect_equal(protocol$dose, 1000)

  # Test dose validation
  expect_error(protocol$dose <- "not a number")

  # Test dose_unit setter - use a valid value
  protocol$dose_unit <- "mg/kg"
  expect_equal(protocol$dose_unit, "mg/kg")

  # Test dose_unit validation
  expect_error(protocol$dose_unit <- "invalid_unit")

  # Test end_time setter
  protocol$end_time <- 48
  expect_equal(protocol$end_time, 48)

  # Test water_vol_per_body_weight
  if (protocol$type == "oral") {
    protocol$water_vol_per_body_weight <- 5.0
    expect_equal(protocol$water_vol_per_body_weight, 5.0)
  }
})

test_that("Protocol can be printed", {
  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Test that print produces expected output using snapshot
  expect_snapshot(protocol)
})

test_that("Protocol with formulation key can be printed", {
  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Set formulation key
  protocol$formulation_key <- "TestFormulation"

  # Check it appears in advanced print using snapshot
  expect_snapshot(print(protocol, advanced = TRUE))
})

test_that("Protocol data structure is correctly built", {
  # Create an oral protocol
  oral_protocol <- create_protocol(
    name = "Oral Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Get the data representation
  data <- oral_protocol$data

  # Check structure
  expect_equal(data$Name, "Oral Protocol")
  expect_equal(data$ApplicationType, "Oral")
  expect_equal(data$DosingInterval, "DI_24")

  # Create an IV protocol with custom infusion time
  iv_protocol <- create_protocol(
    name = "IV Protocol",
    type = "iv",
    interval = "single",
    dose = 200,
    infusion_time = 30,
    infusion_time_unit = "min"
  )

  # Get the data representation
  data <- iv_protocol$data

  # Check structure
  expect_equal(data$Name, "IV Protocol")
  expect_equal(data$ApplicationType, "Intravenous")
  expect_equal(data$DosingInterval, "Single")

  # Check parameters
  param_names <- sapply(data$Parameters, function(p) p$Name)
  expect_true("InputDose" %in% param_names)
  expect_true("Infusion time" %in% param_names)

  # Find the infusion time parameter
  infusion_param <- data$Parameters[sapply(
    data$Parameters,
    function(p) p$Name == "Infusion time"
  )][[1]]
  expect_equal(infusion_param$Value, 30)
  expect_equal(infusion_param$Unit, "min")
})

test_that("Protocol properly handles formulation key", {
  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Initially formulation key should be NULL
  expect_null(protocol$formulation_key)

  # Set formulation key
  protocol$formulation_key <- "TestFormulation"
  expect_equal(protocol$formulation_key, "TestFormulation")

  # Check it appears in data
  data <- protocol$data
  expect_equal(data$FormulationKey, "TestFormulation")
})

test_that("Protocol with default values formats correctly", {
  # Create a protocol with all default values
  protocol <- create_protocol(
    name = "Default Protocol",
    type = "oral",
    interval = "single",
    dose = 100
  )

  # Get data representation
  data <- protocol$data

  # For single dose, end time shouldn't be included
  param_names <- sapply(data$Parameters, function(p) p$Name)
  expect_false("End time" %in% param_names)

  # Create a protocol with non-default end time
  protocol <- create_protocol(
    name = "Custom End Time",
    type = "oral",
    interval = "24",
    dose = 100,
    end_time = 48,
    end_time_unit = "h"
  )

  # Get data representation
  data <- protocol$data

  # Custom end time should be included
  param_names <- sapply(data$Parameters, function(p) p$Name)
  expect_true("End time" %in% param_names)

  # Find the end time parameter
  end_time_param <- data$Parameters[sapply(
    data$Parameters,
    function(p) p$Name == "End time"
  )][[1]]
  expect_equal(end_time_param$Value, 48)
  expect_equal(end_time_param$Unit, "h")
})

test_that("Protocol supports custom start_time", {
  # Create a protocol with default start time
  protocol_default <- create_protocol(
    name = "Default Start",
    type = "oral",
    interval = "single",
    dose = 100
  )

  # Check default start time
  expect_equal(protocol_default$start_time, 0)
  expect_equal(protocol_default$start_time_unit, "h")

  # Create a protocol with custom start time
  protocol_custom <- create_protocol(
    name = "Custom Start",
    type = "oral",
    interval = "24",
    dose = 100,
    start_time = 24,
    start_time_unit = "h",
    end_time = 72,
    end_time_unit = "h"
  )

  # Check custom start time
  expect_equal(protocol_custom$start_time, 24)
  expect_equal(protocol_custom$start_time_unit, "h")
})

test_that("Protocol start_time appears in data structure", {
  # Create a protocol with custom start time
  protocol <- create_protocol(
    name = "Delayed Protocol",
    type = "iv",
    interval = "single",
    dose = 200,
    start_time = 48,
    start_time_unit = "h"
  )

  # Get data representation
  data <- protocol$data

  # Check start time is in parameters
  param_names <- sapply(data$Parameters, function(p) p$Name)
  expect_true("Start time" %in% param_names)

  # Find the start time parameter
  start_time_param <- data$Parameters[sapply(
    data$Parameters,
    function(p) p$Name == "Start time"
  )][[1]]
  expect_equal(start_time_param$Value, 48)
  expect_equal(start_time_param$Unit, "h")
})

test_that("Protocol start_time setters and getters work correctly", {
  # Create a protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500
  )

  # Test start_time setter
  protocol$start_time <- 12
  expect_equal(protocol$start_time, 12)

  # Test start_time validation
  expect_error(protocol$start_time <- "not a number")

  # Test start_time_unit setter
  protocol$start_time_unit <- "min"
  expect_equal(protocol$start_time_unit, "min")

  # Test start_time_unit validation
  expect_error(protocol$start_time_unit <- "invalid_unit")
})

test_that("Protocol start_time with different units", {
  # Create a protocol with start time in minutes
  protocol_min <- create_protocol(
    name = "Start in Minutes",
    type = "ivb",
    interval = "single",
    dose = 100,
    start_time = 30,
    start_time_unit = "min"
  )

  expect_equal(protocol_min$start_time, 30)
  expect_equal(protocol_min$start_time_unit, "min")

  # Check it appears correctly in data
  data <- protocol_min$data
  start_time_param <- data$Parameters[sapply(
    data$Parameters,
    function(p) p$Name == "Start time"
  )][[1]]
  expect_equal(start_time_param$Value, 30)
  expect_equal(start_time_param$Unit, "min")
})

test_that("Protocol with non-default start_time prints correctly", {
  # Create a protocol with custom start time
  protocol <- create_protocol(
    name = "Delayed Start Protocol",
    type = "oral",
    interval = "24",
    dose = 500,
    start_time = 192,
    start_time_unit = "h",
    end_time = 216,
    end_time_unit = "h"
  )

  # Test that print produces expected output using snapshot
  expect_snapshot(protocol)
})

test_that("Protocol validates that end_time is after start_time", {
  # Should error when end_time is before start_time
  expect_error(
    create_protocol(
      name = "Invalid Protocol",
      type = "oral",
      interval = "24",
      dose = 500,
      start_time = 48,
      start_time_unit = "h",
      end_time = 24,
      end_time_unit = "h"
    ),
    "End time must be after start time"
  )

  # Should error when end_time equals start_time
  expect_error(
    create_protocol(
      name = "Invalid Protocol 2",
      type = "oral",
      interval = "24",
      dose = 500,
      start_time = 24,
      start_time_unit = "h",
      end_time = 24,
      end_time_unit = "h"
    ),
    "End time must be after start time"
  )

  # Should work when end_time is after start_time
  expect_no_error(
    create_protocol(
      name = "Valid Protocol",
      type = "oral",
      interval = "24",
      dose = 500,
      start_time = 24,
      start_time_unit = "h",
      end_time = 48,
      end_time_unit = "h"
    )
  )

  # Should work with different units
  expect_no_error(
    create_protocol(
      name = "Valid Protocol Mixed Units",
      type = "oral",
      interval = "24",
      dose = 500,
      start_time = 30,
      start_time_unit = "min",
      end_time = 2,
      end_time_unit = "h"
    )
  )
})

test_that("Protocol time validation works with setters", {
  # Create a valid protocol
  protocol <- create_protocol(
    name = "Test Protocol",
    type = "oral",
    interval = "24",
    dose = 500,
    start_time = 0,
    start_time_unit = "h",
    end_time = 48,
    end_time_unit = "h"
  )

  # Should error when setting start_time after end_time
  expect_error(
    protocol$start_time <- 72,
    "End time must be after start time"
  )

  # Should error when setting end_time before start_time
  expect_error(
    protocol$end_time <- 0,
    "End time must be after start time"
  )

  # Should work when times are valid
  expect_no_error(protocol$start_time <- 12)
  expect_equal(protocol$start_time, 12)

  expect_no_error(protocol$end_time <- 96)
  expect_equal(protocol$end_time, 96)
})

test_that("Protocol time validation does not apply to single dose", {
  # Single dose protocols should not validate time order
  expect_no_error(
    create_protocol(
      name = "Single Dose",
      type = "oral",
      interval = "single",
      dose = 500,
      start_time = 48,
      start_time_unit = "h",
      end_time = 24,  # This would be invalid for non-single, but OK for single
      end_time_unit = "h"
    )
  )
})
