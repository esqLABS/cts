test_that("Plotting simulation results work", {
  my_ddi <- get_test_ddi()

  # suppress log10 transformation warnings from ggplot2
  plots <- suppressWarnings(plot_ddi_results(my_ddi))

  suppressWarnings(
    vdiffr::expect_doppelganger(
      "default lng itr ddi simulation",
      plots[[1]][[1]]
    )
  )
})
