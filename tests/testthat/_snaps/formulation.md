# Dissolved formulation can be created

    Code
      create_formulation(name = "Solution", type = "dissolved")
    Message
      Solution
      * Type: Dissolved

# Weibull formulation can be created

    Code
      create_formulation(name = "Weibull", type = "weibull")
    Condition
      Warning:
      No `dissolution_time` provided, using default value of 240 min.
      Warning:
      No `lag_time` provided, using default value of 0 min.
      Warning:
      No `suspension` provided, using default of 'TRUE'.
      Warning:
      No `dissolution_shape` provided, using default value of 0.92.
    Message
      Weibull
      * Type: Weibull
      * Dissolution time (50% dissolved) : 240 min
      * Lag time : 0 min
      * Dissolution shape : 0.92
      * Use as suspension : 1

# Lint80 formulation can be created

    Code
      create_formulation(name = "Lint", type = "lint80")
    Condition
      Warning:
      No `dissolution_time` provided, using default value of 240 min.
      Warning:
      No `lag_time` provided, using default value of 0 min.
      Warning:
      No `suspension` provided, using default of 'TRUE'.
    Message
      Lint
      * Type: Lint80
      * Dissolution time (80% dissolved) : 240 min
      * Lag time : 0 min
      * Use as suspension : 1

# Particle monodisperse formulation can be created

    Code
      create_formulation(name = "ParticleMono", type = "particle")
    Condition
      Warning:
      No `thickness` provided, using default value of 30 µm.
      Warning:
      No `distribution_type` provided, using default of 'mono'.
      Warning:
      No `radius` provided, using default value of 10 µm.
    Message
      ParticleMono
      * Type: Particle
      * Thickness (unstirred water layer) : 30 µm
      * Type of particle size distribution : Monodisperse
      * Particle radius (mean) : 10 µm

# Particle polydisperse normal formulation can be created

    Code
      create_formulation(name = "ParticlePolyNormal", type = "particle",
        distribution_type = "poly")
    Condition
      Warning:
      No `thickness` provided, using default value of 30 µm.
      Warning:
      No `radius` provided, using default value of 10 µm.
      Warning:
      No `particle_size_distribution` provided, using default of 'normal'.
      Warning:
      No `radius_min` provided, using default value of 1 µm.
      Warning:
      No `radius_max` provided, using default value of 19 µm.
      Warning:
      No `n_bins` provided, using default value of 3.
      Warning:
      No `radius_sd` provided, using default value of 3 µm.
    Message
      ParticlePolyNormal
      * Type: Particle
      * Thickness (unstirred water layer) : 30 µm
      * Type of particle size distribution : Polydisperse
      * Particle radius (geomean) : 10 µm
      * Particle size distribution : Normal
      * Particle radius (SD) : 3 µm
      * Particle radius (min) : 1 µm
      * Particle radius (max) : 19 µm
      * Number of bins : 3

# Particle polydisperse lognormal formulation can be created

    Code
      create_formulation(name = "ParticlePolyLogNormal", type = "particle",
        distribution_type = "poly", particle_size_distribution = "lognormal")
    Condition
      Warning:
      No `thickness` provided, using default value of 30 µm.
      Warning:
      No `radius` provided, using default value of 10 µm.
      Warning:
      No `radius_min` provided, using default value of 1 µm.
      Warning:
      No `radius_max` provided, using default value of 19 µm.
      Warning:
      No `n_bins` provided, using default value of 3.
      Warning:
      No `radius_cv` provided, using default value of 1.5.
    Message
      ParticlePolyLogNormal
      * Type: Particle
      * Thickness (unstirred water layer) : 30 µm
      * Type of particle size distribution : Polydisperse
      * Particle radius (mean) : 10 µm
      * Particle size distribution : Log Normal
      * Coefficient of variation : 1.5
      * Particle radius (min) : 1 µm
      * Particle radius (max) : 19 µm
      * Number of bins : 3

# Zero order formulation can be created

    Code
      create_formulation(name = "ZeroOrder", type = "zero")
    Message
      ZeroOrder
      * Type: ZeroOrder
      * End time :

# First order formulation can be created

    Code
      create_formulation(name = "FirstOrder", type = "first")
    Message
      FirstOrder
      * Type: FirstOrder
      * t1/2 :

