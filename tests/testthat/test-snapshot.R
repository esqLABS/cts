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
      compound("https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json")
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
