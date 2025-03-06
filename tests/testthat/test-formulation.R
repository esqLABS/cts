test_that("Formulation can be initialized", {
  expect_no_message(Formulation$new(name = "Test formulation", type = "dissolved"))
})

test_that("Dissolved formulation can be created", {
  expect_snapshot(create_formulation(name = "Solution", type = "dissolved"))
})

test_that("Weibull formulation can be created", {
  expect_snapshot(create_formulation(name = "Weibull", typFe = "weibull"))
})

test_that("Lint80 formulation can be created", {
  expect_snapshot(create_formulation(name = "Lint", type = "lint80"))
})

test_that("Particle monodisperse formulation can be created", {
  expect_snapshot(create_formulation(name = "ParticleMono", type = "particle"))
})

test_that("Particle polydisperse normal formulation can be created", {
  expect_snapshot(create_formulation(name = "ParticlePolyNormal", type = "particle", distribution_type = "poly"))
})

test_that("Particle polydisperse lognormal formulation can be created", {
  expect_snapshot(create_formulation(name = "ParticlePolyLogNormal", type = "particle", distribution_type = "poly", particle_size_distribution = "lognormal"))
})

test_that("Table formulation can be created", {
  expect_snapshot(create_formulation(name = "Table", type = "table", tableX = c(0,1,5,10), tableY = c(0,0.2,0.8,1)))
})

test_that("Zero order formulation can be created", {
  expect_snapshot(create_formulation(name = "ZeroOrder", type = "zero"))
})

test_that("First order formulation can be created", {
  expect_snapshot(create_formulation(name = "FirstOrder", type = "first"))
})
