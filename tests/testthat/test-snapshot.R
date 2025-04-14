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
  test_formulation <- Formulation$new(
    name = "TestFormulation",
    type = "weibull"
  )

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
