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
