test_that("Compound can be initialized", {
  expect_no_error(
    suppressMessages({
      compound("Rifampicin")
    })
  )


  expect_warning(
    suppressMessages({
      compound("Digoxin")
    }), "UserDefined administration is not allowed"
  )

  expect_warning(
    suppressMessages({
      compound("Coproporphyrin I")
    }), "UserDefined administration is not allowed"
  )
})
