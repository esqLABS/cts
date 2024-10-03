test_that("fill_simulation_template", {
  expect_snapshot(
    fill_simulation_template(
      template_path = system.file("extdata", "generic_simulation_template.json", package = "cts"),
      victim = "rifampicin",
      perpetrator = "itraconazole",
      individual = "Male",
      victim_formulation = "Tablet", perpetrator_formulation = "Capsule",
      victim_protocol = "SingleDose", perpetrator_protocol = "SingleDose"
    )
  )
})


test_that("Interaction can be extracted", {
  expect_snapshot(
    extract_interactions(levo_itra_ddi)
  )
})


test_that("Compounds process can be extracted", {
  expect_snapshot(
    extract_compound_processes(levo_itra_ddi$compounds[[1]])
  )
})
