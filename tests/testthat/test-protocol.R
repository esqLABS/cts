test_that("protocol can be initialized", {
  expect_no_message(Protocol$new(name = "Test protocol", type = "ivb", interval = "single", dose = 300))
})
