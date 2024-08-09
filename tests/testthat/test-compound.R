test_that("Creating Compound from name works", {
  suppressMessages({
    expect_true(is.list(compound("Rifampicin")))
  })
})

test_that("Creating Compound from file works", {
  suppressMessages({
    expect_true(is.list(compound(test_path("data/Rifampicin-Model.json"))))
  })
})

test_that("Creating Compound from url works", {
  suppressMessages({
    expect_true(is.list(compound("https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json")))
  })
})

test_that("Providing wrong input type fails with explicit error",{
  # Wrong molecule name
  expect_error(compound("Midasolam"))

  # Faulty URL
  expect_error(compound("https://bad_url.com/data.json"))

  # Bad file path
  expect_error(compound(test_path("data/Rifampicine-Model.json")))
})
