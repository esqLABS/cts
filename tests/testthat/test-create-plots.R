test_that("Plotting simulation results work", {
  my_ddi <- get_test_ddi()

  # suppress log10 transformation warnings from ggplot2
  plots <- suppressWarnings(plot_ddi_results(my_ddi))

  expect_s3_class(plots[[1]][[1]], "ggplot")
})

test_that("Plotting population simulation results work.", {
  ddi <- levo_itra_ddi$clone()
  sim_to_remove <- ddi$get_names("simulations")
  remove_simulation(ddi, sim_to_remove)

  my_sim <- create_simulation(
    simulation_name = "Test",
    victim = "Levonorgestrel 1",
    perpetrators = "Itraconazole",
    population = "Women"
  )
  set_compound_protocol(my_sim, compound = "Levonorgestrel 1", protocol = "LNG_150 ug_21 Days", formulation = list(list(Key = "Formulation", Name = "Microlut")))
  set_compound_protocol(my_sim, compound = "Itraconazole", protocol = "ITZ 100mg 21 days", formulation = list(list(Key = "Formulation", Name = "IR Dissolved")))

  my_sim$output_selections <- list("Organism|PeripheralVenousBlood|Levonorgestrel 1|Plasma (Peripheral Venous Blood)")

  suppressWarnings(add_simulation(ddi, my_sim))

  # suppress log10 transformation warnings from ggplot2
  plots <- suppressWarnings(plot_ddi_results(ddi))

  expect_s3_class(plots[[1]][[1]], "ggplot")
})
