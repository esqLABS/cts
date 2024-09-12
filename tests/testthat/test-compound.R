test_that("Compound can be initialized", {
  expect_no_error(
    suppressMessages({
      compound("Rifampicin")
    })
  )
})
