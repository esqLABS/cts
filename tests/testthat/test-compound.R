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
