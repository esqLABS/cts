test_that("Creating Compound from name works", {
  expect_no_error(
    suppressMessages({
      compound("Rifampicin")
    })
  )
})

test_that("Creating Compound from file works", {
  expect_no_error(
    suppressMessages({
      compound(test_path("data/Rifampicin-Model.json"))
    })
  )
})

test_that("Creating Compound from url works", {
  expect_no_error(
    suppressMessages({
      compound(
        "https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json"
      )
    })
  )
})

test_that("Providing wrong input type fails with explicit error", {
  # Wrong molecule name
  expect_error(compound("Midasolam"))

  # Faulty URL
  expect_error(compound("https://bad_url.com/data.json"))

  # Bad file path
  expect_error(compound(test_path("data/Rifampicine-Model.json")))
})


test_that("get_names and print function works", {
  expect_snapshot({
    rifampicin
  })
})

test_that("Snapshot can be exported as JSON files and recreated from it", {
  temp_file <- withr::local_tempfile(fileext = ".json")

  rifampicin_snap$export(temp_file)
  expect_true(file.exists(temp_file))

  expect_no_error(
    new_snap <- Snapshot$new(temp_file)
  )

  # overwrite source for comparison purposes
  new_snap$source <- rifampicin_snap$source

  expect_equal(
    rifampicin_snap$data,
    new_snap$data
  )
})


test_that("Snapshots can be updated", {
  testthat::skip_on_os("mac")
  updated_rif <- update_snapshots(rifampicin)

  expect_equal(updated_rif$data$Version, 80)
})

test_that("Interactions can be extracted", {
  expect_snapshot(
    extract_interactions(rifampicin)
  )
})

test_that("Compounds process can be extracted", {
  expect_snapshot(
    extract_processes(rifampicin)
  )
})

test_that("Adding and removing protocols works", {
  # Make a temporary copy of the rifampicin snapshot
  temp_snap <- Snapshot$new(rifampicin$source)

  # Get original protocol names
  original_protocols <- temp_snap$get_names("protocols")

  # Create a new protocol with required parameters
  test_protocol <- Protocol$new(
    name = "TestProtocol",
    type = "oral",
    interval = "single",
    dose = 100
  )

  # Add the protocol to the snapshot
  temp_snap$add_protocol(test_protocol)

  # Check that the protocol was added
  expect_true("TestProtocol" %in% temp_snap$get_names("protocols"))
  expect_equal(length(temp_snap$protocols), length(original_protocols) + 1)

  # Remove the protocol
  temp_snap$remove_protocol("TestProtocol")

  # Check that the protocol was removed
  expect_false("TestProtocol" %in% temp_snap$get_names("protocols"))
  expect_equal(length(temp_snap$protocols), length(original_protocols))
})

test_that("Adding and removing formulations works", {
  # Make a temporary copy of the rifampicin snapshot
  temp_snap <- Snapshot$new(rifampicin$source)

  # Get original formulation names
  original_formulations <- temp_snap$get_names("formulations")

  # Create a new formulation with required parameters
  suppressWarnings({
    test_formulation <- Formulation$new(
      name = "TestFormulation",
      type = "weibull"
    )
  })

  # Add the formulation to the snapshot
  temp_snap$add_formulation(test_formulation)

  # Check that the formulation was added
  expect_true("TestFormulation" %in% temp_snap$get_names("formulations"))
  expect_equal(
    length(temp_snap$formulations),
    length(original_formulations) + 1
  )

  # Remove the formulation
  temp_snap$remove_formulation("TestFormulation")

  # Check that the formulation was removed
  expect_false("TestFormulation" %in% temp_snap$get_names("formulations"))
  expect_equal(length(temp_snap$formulations), length(original_formulations))
})

test_that("Adding and removing simulations works", {
  # Make a temporary copy of the rifampicin snapshot
  temp_snap <- Snapshot$new(rifampicin$source)

  # Get original simulation names
  original_simulations <- temp_snap$simulations %||% list()

  # Create a simple simulation with Name field (not 'name')
  test_simulation <- list(
    Name = "TestSimulation"
  )

  # Add the simulation to the snapshot
  temp_snap$add_simulation(test_simulation)

  # Check that the simulation was added
  expect_equal(length(temp_snap$simulations), length(original_simulations) + 1)

  # Check that we can find our simulation by name
  sim_names <- sapply(temp_snap$simulations, function(x) x$Name)
  expect_true("TestSimulation" %in% sim_names)

  # Remove the simulation
  temp_snap$remove_simulation("TestSimulation")

  # Check that the simulation was removed
  expect_equal(length(temp_snap$simulations), length(original_simulations))

  # Check simulation is no longer in the names
  if (length(temp_snap$simulations) > 0) {
    final_sim_names <- sapply(temp_snap$simulations, function(x) x$Name)
    expect_false("TestSimulation" %in% final_sim_names)
  }
})

test_that("Adding and removing observed data works", {
  # Make a temporary copy of the rifampicin snapshot
  rif_snap <- Snapshot$new(rifampicin$source)

  # Get original observed data names
  original_obs_data <- rif_snap$get_names("observed_data")

  dts <- loadDataSetFromSnapshot(rif_snap$observed_data[[1]])

  # Remove the observed data
  remove_observed_data(rif_snap, original_obs_data[1])

  # Check that the simulation was removed
  expect_equal(length(rif_snap$observed_data), length(original_obs_data)-1)

  # Add the simulation to the snapshot using the dataset to snapshot functionality
  add_observed_data(rif_snap, dts)

  # Check that the simulation was added
  expect_equal(length(rif_snap$observed_data), length(original_obs_data))

  # Add the simulation to the snapshot from excel files
  xlsFilePath <- system.file(
    "extdata", "CompiledDataSet.xlsx",
    package = "ospsuite"
  )

  importerConfiguration <- ospsuite::createImporterConfigurationForFile(xlsFilePath)
  importerConfiguration$sheets <- "TestSheet_1"

  add_observed_data(rif_snap, xlsFilePath, importerConfiguration)

  expect_equal(length(rif_snap$observed_data), length(original_obs_data) + 4 )
})

test_that("Simulation structure can be examined", {
  # This test just examines what's in the simulations to help understand the structure
  # for future test development
  temp_snap <- Snapshot$new(rifampicin$source)

  # Skip if no simulations available
  simulations <- temp_snap$simulations
  if (length(simulations) == 0) {
    skip("No simulations available in the test snapshot")
  }

  # Check the structure of the existing simulations
  sim_attrs <- names(simulations[[1]])
  expect_true(length(sim_attrs) > 0)

  # Check that Name is one of the attributes (used in get_names)
  if (length(simulations) > 0) {
    expect_true("Name" %in% sim_attrs)
  }
})

test_that("Active bindings for compound data work", {
  # Make a temporary copy of the rifampicin snapshot
  temp_snap <- Snapshot$new(rifampicin$source)

  # Get original data
  original_compounds <- temp_snap$compounds

  # Test modification through active binding
  new_compounds <- original_compounds
  if (length(new_compounds) > 0) {
    # Add a test field to the first compound
    new_compounds[[1]]$TestField <- "test"

    # Set the modified compounds
    temp_snap$compounds <- new_compounds

    # Verify the change was applied
    expect_equal(temp_snap$compounds[[1]]$TestField, "test")

    # Restore original
    temp_snap$compounds <- original_compounds
  }
})

test_that("Snapshot data method properly collects all data", {
  # Make a copy of the snapshot
  temp_snap <- Snapshot$new(rifampicin$source)

  # Get the data
  snapshot_data <- temp_snap$data

  # Check that basic fields are present
  expected_fields <- c("Version", "Compounds")

  for (field in expected_fields) {
    expect_true(field %in% names(snapshot_data))
  }

  # Check that formulations data is properly transformed
  if (length(temp_snap$formulations) > 0) {
    # Formulations should be converted to data representation
    expect_equal(
      length(snapshot_data$Formulations),
      length(temp_snap$formulations)
    )
  }

  # Check that protocols data is properly transformed
  if (length(temp_snap$protocols) > 0) {
    # Protocols should be converted to data representation
    expect_equal(length(snapshot_data$Protocols), length(temp_snap$protocols))
  }
})

test_that("Multiple exports work with different file paths", {
  # Create two temporary files
  temp_file1 <- withr::local_tempfile(fileext = ".json")
  temp_file2 <- withr::local_tempfile(fileext = ".json")

  # Export to both files
  rifampicin_snap$export(temp_file1)
  rifampicin_snap$export(temp_file2)

  # Check both files exist
  expect_true(file.exists(temp_file1))
  expect_true(file.exists(temp_file2))

  # Check content is the same
  content1 <- jsonlite::read_json(temp_file1)
  content2 <- jsonlite::read_json(temp_file2)
  expect_equal(content1, content2)
})

test_that("Snapshot print_names method formats output correctly", {
  # Create a snapshot object
  temp_snap <- Snapshot$new(rifampicin$source)

  # Test normal print output with snapshot
  expect_snapshot(temp_snap)

  # Test with an empty field by creating a temporary empty field
  original_events <- temp_snap$events
  temp_snap$events <- list()

  # Check print with empty events field
  expect_snapshot(temp_snap)

  # Restore original events
  temp_snap$events <- original_events
})

test_that("Creating Snapshot from R list works", {
  # First create a snapshot from a known source
  sample_snapshot <- Snapshot$new(rifampicin$source)

  # Extract the source_data list
  sample_data <- sample_snapshot$source_data

  # Create a new snapshot directly from the list data
  expect_no_error({
    list_snapshot <- Snapshot$new(sample_data)
  })

  # Create a new snapshot and verify it has the same data as the original
  list_snapshot <- Snapshot$new(sample_data)

  # Check that key properties match
  expect_equal(list_snapshot$version, sample_snapshot$version)
  expect_equal(
    list_snapshot$get_names("compounds"),
    sample_snapshot$get_names("compounds")
  )
  expect_equal(
    list_snapshot$get_names("formulations"),
    sample_snapshot$get_names("formulations")
  )
  expect_equal(
    list_snapshot$get_names("protocols"),
    sample_snapshot$get_names("protocols")
  )

  # The source should be "R list" for the new snapshot
  expect_equal(list_snapshot$source, "R list")
})

test_that("Creating Snapshot from a minimal custom R list works", {
  # Create a minimal R list that has the required structure
  minimal_snapshot_data <- list(
    Version = 80,
    Compounds = list(),
    Individuals = list(),
    Populations = list(),
    Formulations = list(),
    Protocols = list(),
    ExpressionProfiles = list(),
    ObserverSets = list(),
    Events = list(),
    Simulations = list(),
    ObservedData = list()
  )

  # Create a snapshot from the minimal list
  expect_no_error({
    minimal_snapshot <- Snapshot$new(minimal_snapshot_data)
  })

  # Verify the snapshot was created correctly
  minimal_snapshot <- Snapshot$new(minimal_snapshot_data)
  expect_equal(minimal_snapshot$version, 80)
  expect_equal(minimal_snapshot$source, "R list")
  expect_equal(length(minimal_snapshot$compounds), 0)
  expect_equal(length(minimal_snapshot$formulations), 0)
  expect_equal(length(minimal_snapshot$protocols), 0)

  # The data method should work properly
  snapshot_data <- minimal_snapshot$data
  expect_equal(snapshot_data$Version, 80)

  # Test with only Version and Compounds
  version_compounds_data <- list(
    Version = 80,
    Compounds = list(
      list(
        Name = "TestCompound",
        Processes = list()
      )
    )
  )
  expect_no_error({
    vc_snapshot <- Snapshot$new(version_compounds_data)
  })

  # Verify the snapshot with only Version and Compounds
  vc_snapshot <- Snapshot$new(version_compounds_data)
  expect_equal(vc_snapshot$version, 80)
  expect_equal(vc_snapshot$get_names("compounds"), "TestCompound")
  expect_equal(length(vc_snapshot$formulations), 0) # Should initialize empty lists for missing fields
})

test_that("Creating Snapshot fails with invalid input type", {
  # Test with a numeric input
  expect_error(Snapshot$new(123), "Invalid input type")

  # Test with NULL
  expect_error(Snapshot$new(NULL), "Invalid input type")
})

test_that("get_names handles R6 objects with lowercase 'name' field", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Formulations = list(),
    Protocols = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Create R6 Protocol objects with lowercase 'name' field
  protocol1 <- Protocol$new(
    name = "TestProtocol1",
    type = "oral",
    interval = "single",
    dose = 100
  )
  protocol2 <- Protocol$new(
    name = "TestProtocol2",
    type = "oral",
    interval = "single",
    dose = 200
  )

  # Add protocols to the snapshot
  temp_snap$add_protocol(protocol1)
  temp_snap$add_protocol(protocol2)

  # Test get_names extracts lowercase 'name' field correctly
  protocol_names <- temp_snap$get_names("protocols")
  expect_equal(length(protocol_names), 2)
  expect_true("TestProtocol1" %in% protocol_names)
  expect_true("TestProtocol2" %in% protocol_names)
})

test_that("get_names handles R6 objects with uppercase 'Name' field via active binding", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Formulations = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Create R6 Formulation objects with active binding 'name'
  suppressWarnings({
    formulation1 <- Formulation$new(
      name = "TestFormulation1",
      type = "weibull"
    )
    formulation2 <- Formulation$new(
      name = "TestFormulation2",
      type = "weibull"
    )
  })

  # Add formulations to the snapshot
  temp_snap$add_formulation(formulation1)
  temp_snap$add_formulation(formulation2)

  # Test get_names extracts name correctly from active binding
  formulation_names <- temp_snap$get_names("formulations")
  expect_equal(length(formulation_names), 2)
  expect_true("TestFormulation1" %in% formulation_names)
  expect_true("TestFormulation2" %in% formulation_names)
})

test_that("get_names handles plain lists with uppercase 'Name' field", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Simulations = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Add plain list simulations with uppercase 'Name' field
  sim1 <- list(Name = "Simulation1")
  sim2 <- list(Name = "Simulation2")
  temp_snap$add_simulation(sim1)
  temp_snap$add_simulation(sim2)

  # Test get_names extracts uppercase 'Name' field from plain lists
  sim_names <- temp_snap$get_names("simulations")
  expect_equal(length(sim_names), 2)
  expect_true("Simulation1" %in% sim_names)
  expect_true("Simulation2" %in% sim_names)
})

test_that("get_names handles plain lists with lowercase 'name' field", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Events = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Manually add plain list events with lowercase 'name' field
  temp_snap$events <- list(
    list(name = "Event1", type = "test"),
    list(name = "Event2", type = "test")
  )

  # Test get_names extracts lowercase 'name' field from plain lists
  event_names <- temp_snap$get_names("events")
  expect_equal(length(event_names), 2)
  expect_true("Event1" %in% event_names)
  expect_true("Event2" %in% event_names)
})

test_that("get_names handles mixed types and objects without name fields", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Protocols = list(),
    Events = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Create a mix of R6 objects and plain lists
  protocol1 <- Protocol$new(
    name = "NamedProtocol",
    type = "oral",
    interval = "single",
    dose = 100
  )
  temp_snap$add_protocol(protocol1)

  # Manually set up a mixed events list with:
  # - Plain list with lowercase 'name'
  # - Plain list with uppercase 'Name'
  # - Object without name field
  # - R6 object (although unusual for events, testing the logic)
  temp_snap$events <- list(
    list(name = "Event1", type = "test"),
    list(Name = "Event2", type = "test"),
    list(type = "unnamed_event"),  # No name field
    protocol1  # R6 object with lowercase 'name'
  )

  # Test get_names filters out objects without name fields
  event_names <- temp_snap$get_names("events")
  expect_equal(length(event_names), 3)  # Should get 3 names, skipping the unnamed one
  expect_true("Event1" %in% event_names)
  expect_true("Event2" %in% event_names)
  expect_true("NamedProtocol" %in% event_names)
  expect_false(NA %in% event_names)  # NAs should be filtered out
})

test_that("get_names returns empty character vector for NULL or empty fields", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Test with NULL field
  temp_snap$protocols <- NULL
  expect_equal(temp_snap$get_names("protocols"), character(0))

  # Test with empty list
  temp_snap$protocols <- list()
  expect_equal(temp_snap$get_names("protocols"), character(0))
})

test_that("get_names returns empty when all objects lack name fields", {
  # Create a minimal snapshot
  minimal_data <- list(
    Version = 80,
    Compounds = list(),
    Events = list()
  )
  temp_snap <- Snapshot$new(minimal_data)

  # Add events without name fields
  temp_snap$events <- list(
    list(type = "test1"),
    list(type = "test2"),
    list(data = "test3")
  )

  # Test get_names returns empty when no names are found
  event_names <- temp_snap$get_names("events")
  expect_equal(event_names, character(0))
  expect_equal(length(event_names), 0)
})
