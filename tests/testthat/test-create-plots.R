test_that("Plotting simulation results work", {
  my_ddi <- get_test_ddi()

  # suppress log10 transformation warnings from ggplot2
  plots <- suppressWarnings(plot_ddi_results(my_ddi))

  expect_s3_class(plots[[1]][[1]], "ggplot")
})
