test_that("Formulation can be initialized", {
  expect_no_message(Formulation$new(name = "Test formulation", type = "dissolved"))
})

test_that("Dissolved formulation can be created", {
  expect_snapshot(create_formulation(name = "Solution", type = "dissolved"))
})

test_that("Weibull formulation can be created", {
  expect_snapshot(create_formulation(name = "Weibull", type = "weibull"))
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
  expect_snapshot(create_formulation(name = "FirstOrder", type = "first",
  thalf = "0.01",
  thalf_unit = "min"))
})

test_that("Formulation can be added to a snapshot", {
  # Create a snapshot
  snapshot <- midazolam$clone()
  
  # Create formulations
  f1 <- create_formulation("Immediate release solution", "dissolved")
  f2 <- create_formulation(
    name = "Standard tablet", 
    type = "weibull",
    dissolution_time = 180,
    dissolution_time_unit = "min",
    lag_time = 0,
    lag_time_unit = "min",
    dissolution_shape = 0.85,
    suspension = TRUE
  )
  
  inital_formulations_n <- length(snapshot$formulations)
  # Add formulations to snapshot
  snapshot <- add_formulation(snapshot, f1)
  snapshot <- add_formulation(snapshot, f2)
  
  # Check that formulations were added
  expect_true("Immediate release solution" %in% snapshot$get_names("formulations"))
  expect_true("Standard tablet" %in% snapshot$get_names("formulations"))
  expect_equal(length(snapshot$formulations), inital_formulations_n+2)
})

test_that("Formulation can be removed from a snapshot", {
  # Create a snapshot
  snapshot <- midazolam$clone()
  
  # Create and add formulations
  f1 <- create_formulation("Immediate release solution", "dissolved")
  f2 <- create_formulation(
    name = "Standard tablet", 
    type = "weibull",
    dissolution_time = 180,
    dissolution_time_unit = "min",
    lag_time = 0,
    lag_time_unit = "min",
    dissolution_shape = 0.85,
    suspension = TRUE
  )
  f3 <- create_formulation(
    name = "Extended release tablet", 
    type = "weibull",
    dissolution_time = 360,
    dissolution_time_unit = "min",
    lag_time = 0,
    lag_time_unit = "min",
    dissolution_shape = 0.85,
    suspension = TRUE
  )
  
  snapshot <- add_formulation(snapshot, f1)
  snapshot <- add_formulation(snapshot, f2)
  snapshot <- add_formulation(snapshot, f3)

  inital_formulations_n <- length(snapshot$formulations)

  # Remove a single formulation
  snapshot <- remove_formulation(snapshot, "Immediate release solution")
  expect_false("Immediate release solution" %in% snapshot$get_names("formulations"))
  expect_true("Standard tablet" %in% snapshot$get_names("formulations"))
  expect_true("Extended release tablet" %in% snapshot$get_names("formulations"))
  expect_equal(length(snapshot$formulations), inital_formulations_n - 1)
  
  # Remove multiple formulations
  snapshot <- remove_formulation(snapshot, c("Standard tablet", "Extended release tablet"))
  expect_false("Standard tablet" %in% snapshot$get_names("formulations"))
  expect_false("Extended release tablet" %in% snapshot$get_names("formulations"))
  expect_equal(length(snapshot$formulations), inital_formulations_n - 3)
})