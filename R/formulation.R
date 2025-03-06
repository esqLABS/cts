formulation_types <- list(
  dissolved = list(human = "Dissolved", pksim = "Formulation_Dissolved"),
  weibull = list(human = "Weibull", pksim = "Formulation_Tablet_Weibull"),
  lint80 = list(human = " Lint80", pksim = "Formulation_Tablet_Lint80"),
  particle = list(human = "Particle", pksim = "Formulation_Particles"),
  table = list(human = "Table", pksim = "Formulation_Table"),
  zero = list(human = "ZeroOrder", pksim = "Formulation_ZeroOrder"),
  first = list(human = "FirstOrder", pksim = "Formulation_FirstOrder")
)

particle_size_dist_types = list(
  mono = list(human = "Monodisperse", pksim = 0),
  poly = list(human = "Polydisperse", pksim = 1)
)

particle_size_dists = list(
  normal = list(human = "Normal", pksim = 0),
  lognormal = list(human = "Log Normal", pksim = 1)
)

#' @noRd
Formulation <- R6::R6Class(
  "Formulation",
  active = list(
    #' @field type Type of Formulation
    type = function(value) {
      if (!missing(value)) {
        cli_abort(c("x" = "Formulation {.code type} cannot be changed, create a new one instead."))
      }

      return(private$.type)
    },
    #' @field name Name of formulation
    name = function(value) {
      if (missing(value)) {
        private$.name
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort(c("x" = "Supplied name is not valid."))
        } else {
          private$.name <- value
        }
      }
    },
    #' @field parameters list of parameters for the formulation
    parameters = function() {
      private$.parameters
    },
    #' @field dissolution_time dissolution time of the formulation (weibull, lint80)
    dissolution_time = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Dissolution time should be numeric value."))
        }
        private$.dissolution_time <- value
      }
      return(private$.dissolution_time)
    },
    #' @field dissolution_time_unit Time unit of the formulation dissolution time (weibull, lint80)
    dissolution_time_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Time")
        private$.dissolution_time_unit <- value
      }

      return(private$.dissolution_time_unit)
    },
    #' @field lag_time lag time of the formulation (weibull, lint80)
    lag_time = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Lag time should be numeric value."))
        }
        private$.lag_time <- value
      }
      return(private$.lag_time)
    },
    #' @field lag_time_unit Time unit of the formulation lag time (weibull, lint80)
    lag_time_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Time")
        private$.lag_time_unit <- value
      }

      return(private$.lag_time_unit)
    },
    #' @field dissolution_shape shape of the formulation dissolution (weibull)
    dissolution_shape = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Dissolution shape should be numeric value."))
        }
        private$.dissolution_shape <- value
      }
      return(private$.dissolution_shape)
    },
    #' @field suspension Boolean, whether to use the formulation as suspension (weibull, lint80)
    suspension = function(value) {
      if (!missing(value)) {
        if (!is.logical(value)) {
          cli::cli_abort(c("x" = "Suspension should be a boolean."))
        }
        private$.suspension <- value
      }
      return(private$.suspension)
    },
    #' @field thickness Thickness of the unstirred water layer (particle)
    thickness = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Thickness should be numeric value."))
        }
        private$.thickness <- value
      }
      return(private$.thickness)
    },
    #' @field thickness_unit Unit of the thickness of the water unstirred layer (particle)
    thickness_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Length")
        private$.thickness_unit <- value
      }

      return(private$.thickness_unit)
    },
    #' @field distribution_type Type of the particle formulation
    distribution_type = function(value) {
      if (!missing(value)) {
        cli_abort(c("x" = "Formulation {.code distribution_type} cannot be changed, create a new one instead."))
      }

      return(private$.distribution_type)
    },
    #' @field radius Average size of the particle radius (particle)
    radius = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Radius should be numeric value."))
        }
        private$.radius <- value
      }
      return(private$.radius)
    },
    #' @field radius_unit Unit of the average size of the particle radius (particle)
    radius_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Length")
        private$.radius_unit <- value
      }

      return(private$.radius_unit)
    },
    #' @field particle_size_distribution Distribution of the particle size (normal or lognormal)
    particle_size_distribution = function(value) {
      if (!missing(value)) {
        cli_abort(c("x" = "Formulation {.code particle_size_distribution} cannot be changed, create a new one instead."))
      }

      return(private$.particle_size_distribution)
    },
    #' @field radius_sd SD of the particle radius (particle poly normal)
    radius_sd = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Radius standard deviation should be numeric value."))
        }
        private$.radius_sd <- value
      }
      return(private$.radius_sd)
    },
    #' @field radius_sd_unit Unit of the SD of the particle radius (particle poly normal)
    radius_sd_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Length")
        private$.radius_sd_unit <- value
      }

      return(private$.radius_sd_unit)
    },
    #' @field radius_cv CV of the particle radius (particle poly lognormal)
    radius_cv = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Radius CV should be numeric value."))
        }
        private$.radius_cv <- value
      }
      return(private$.radius_cv)
    },
    #' @field radius_min Min of the particle radius (particle poly)
    radius_min = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Radius standard deviation should be numeric value."))
        }
        private$.radius_min <- value
      }
      return(private$.radius_min)
    },
    #' @field radius_min_unit Unit of the minimum of the particle radius (particle poly)
    radius_min_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Length")
        private$.radius_min_unit <- value
      }

      return(private$.radius_min_unit)
    },
    #' @field radius_max Max of the particle radius (particle poly)
    radius_max = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "Radius standard deviation should be numeric value."))
        }
        private$.radius_max <- value
      }
      return(private$.radius_max)
    },
    #' @field radius_max_unit Unit of the minimum of the particle radius (particle poly)
    radius_max_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Length")
        private$.radius_max_unit <- value
      }

      return(private$.radius_max_unit)
    },
    #' @field n_bins Number of bins (particle poly)
    n_bins = function(value) {
      if (!missing(value)) {
        if (!is.integer(value)) {
          cli::cli_abort(c("x" = "Number of bins should be an integer."))
        }
        private$.n_bins <- value
      }
      return(private$.n_bins)
    },
    #' @field end_time End time of dissolution (zero order)
    end_time = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "End time should be numeric value."))
        }
        private$.end_time <- value
      }
      return(private$.end_time)
    },
    #' @field end_time_unit Unit of dissolution end time (zero order)
    end_time_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Time")
        private$.end_time_unit <- value
      }

      return(private$.end_time_unit)
    },
    #' @field thalf Half-life of the drug release (first order)
    thalf = function(value) {
      if (!missing(value)) {
        if (!is.numeric(value)) {
          cli::cli_abort(c("x" = "thalf should be numeric value."))
        }
        private$.thalf <- value
      }
      return(private$.thalf)
    },
    #' @field thalf_unit Unit of release half-life (first order)
    thalf_unit = function(value) {
      if (!missing(value)) {
        ospsuite::validateUnit(value, "Time")
        private$.thalf_unit <- value
      }

      return(private$.thalf_unit)
    },

    #' @field data A dynamic representation of the formulation
    data = function() {
      data <- list(
        Name = self$name,
        FormulationType = formulation_types[[self$type]]$pksim,
        Parameters = self$parameters()
      )
      # if no parameter remove field
      if (length(data$Parameters) == 0) {
        data <- purrr::discard_at(data, "Parameters")
      }

      return(data)
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class Formulation
    #' @param type Type of the formulation
    #' @param name Name of the formulation
    #' @param ... additional parameters that depends on the `type` of formulation:
    #' @return A new `Formulation` object.
    initialize = function(type, name, ...) {
      self$name <- name

      # check validity of types
      rlang::arg_match(
        type,
        values = names(formulation_types),
        error_arg = "type"
      )
      private$.type <- type

      additional_args <- list(...)
      if (!is.null(additional_args$distribution_type)) {
        if (!(additional_args$distribution_type %in% names(particle_size_dist_types))) {
          cli::cli_abort(c("x" = "Invalid {.var distribution_type} provided."))
        }
        private$.distribution_type <- additional_args$distribution_type
      }
      if (!is.null(additional_args$particle_size_distribution)) {
        if (!(additional_args$particle_size_distribution %in% names(particle_size_dists))) {
          cli::cli_abort(c("x" = "Invalid {.var particle_size_distribution} provided."))
        }
        private$.particle_size_distribution <- additional_args$particle_size_distribution
      }

      private$.dissolution_time <- additional_args$dissolution_time
      private$.dissolution_time_unit <- additional_args$dissolution_time_unit
      private$.lag_time <- additional_args$lag_time
      private$.lag_time_unit <- additional_args$lag_time_unit
      private$.dissolution_shape <- additional_args$dissolution_shape
      private$.suspension <- additional_args$suspension
      private$.thickness <- additional_args$thickness
      private$.thickness_unit <- additional_args$thickness_unit
      private$.radius <- additional_args$radius
      private$.radius_unit <- additional_args$radius_unit
      private$.particle_size_distribution <- additional_args$particle_size_distribution
      private$.radius_sd <- additional_args$radius_sd
      private$.radius_sd_unit <- additional_args$radius_sd_unit
      private$.radius_cv <- additional_args$radius_cv
      private$.radius_min <- additional_args$radius_min
      private$.radius_min_unit <- additional_args$radius_min_unit
      private$.radius_max <- additional_args$radius_max
      private$.radius_max_unit <- additional_args$radius_max_unit
      private$.n_bins <- additional_args$n_bins
      private$.end_time <- additional_args$end_time
      private$.end_time_unit <- additional_args$end_time_unit
      private$.thalf <- additional_args$thalf
      private$.thalf_unit <- additional_args$thalf_unit
      private$.tableX <- additional_args$tableX
      private$.tableY <- additional_args$tableY

      if (self$type %in% c("weibull", "lint80")) {
        if (is.null(private$.dissolution_time)) {
          cli::cli_warn(c("!" = "No {.code dissolution_time} provided, using default value of 240 min."))
          private$.dissolution_time <- 240
          private$.dissolution_time_unit <- "min"
        }
        if (is.null(private$.dissolution_time_unit)) {
          cli::cli_warn(c("!" = "No {.code dissolution_time_unit} provided, using default unit of 'min'."))
          private$.dissolution_time_unit <- "min"
        }
        if (is.null(private$.lag_time)) {
          cli::cli_warn(c("!" = "No {.code lag_time} provided, using default value of 0 min."))
          private$.lag_time <- 0
          private$.lag_time_unit <- "min"
        }
        if (is.null(private$.lag_time_unit)) {
          cli::cli_warn(c("!" = "No {.code lag_time_unit} provided, using default unit of 'min'."))
          private$.lag_time_unit <- "min"
        }
        if (is.null(private$.suspension)) {
          cli::cli_warn(c("!" = "No {.code suspension} provided, using default of 'TRUE'."))
          private$.suspension <- TRUE
        }

        if (self$type == "weibull" && is.null(private$.dissolution_shape)) {
          cli::cli_warn(c("!" = "No {.code dissolution_shape} provided, using default value of 0.92."))
          private$.dissolution_shape <- 0.92
        }
      }

      if (self$type == "particle") {
        if (is.null(private$.thickness)) {
          cli::cli_warn(c("!" = "No {.code thickness} provided, using default value of 30 µm."))
          private$.thickness <- 30
          private$.thickness_unit <- "µm"
        }
        if (is.null(private$.thickness_unit)) {
          cli::cli_warn(c("!" = "No {.code thickness_unit} provided, using default unit of µm."))
          private$.thickness_unit <- "µm"
        }

        if (is.null(private$.distribution_type)) {
          cli::cli_warn(c("!" = "No {.code distribution_type} provided, using default of 'mono'."))
          private$.distribution_type <- "mono"
        }

        if (is.null(private$.radius)) {
          cli::cli_warn(c("!" = "No {.code radius} provided, using default value of 10 µm."))
          private$.radius <- 10
          private$.radius_unit <- "µm"
        }
        if (is.null(private$.radius_unit)) {
          cli::cli_warn(c("!" = "No {.code radius_unit} provided, using default unit of µm."))
          private$.radius_unit <- "µm"
        }

        if (private$.distribution_type == "poly") {
          if (is.null(private$.particle_size_distribution)) {
            cli::cli_warn(c("!" = "No {.code particle_size_distribution} provided, using default of 'normal'."))
            private$.particle_size_distribution <- "normal"
          }

          if (is.null(private$.radius_min)) {
            cli::cli_warn(c("!" = "No {.code radius_min} provided, using default value of 1 µm."))
            private$.radius_min <- 1
            private$.radius_min_unit <- "µm"
          }
          if (is.null(private$.radius_min_unit)) {
            cli::cli_warn(c("!" = "No {.code radius_min_unit} provided, using default unit of µm."))
            private$.radius_min_unit <- "µm"
          }
          if (is.null(private$.radius_max)) {
            cli::cli_warn(c("!" = "No {.code radius_max} provided, using default value of 19 µm."))
            private$.radius_max <- 19
            private$.radius_max_unit <- "µm"
          }
          if (is.null(private$.radius_max_unit)) {
            cli::cli_warn(c("!" = "No {.code radius_max_unit} provided, using default unit of µm."))
            private$.radius_max_unit <- "µm"
          }
          if (is.null(private$.n_bins)) {
            cli::cli_warn(c("!" = "No {.code n_bins} provided, using default value of 3."))
            private$.n_bins <- 3
          }

          if (private$.particle_size_distribution == "normal") {
            if (is.null(private$.radius_sd)) {
              cli::cli_warn(c("!" = "No {.code radius_sd} provided, using default value of 3 µm."))
              private$.radius_sd <- 3
              private$.radius_sd_unit <- "µm"
            }
            if (is.null(private$.radius_sd_unit)) {
              cli::cli_warn(c("!" = "No {.code radius_sd_unit} provided, using default unit of µm."))
              private$.radius_sd_unit <- "µm"
            }
          } else {
            if (is.null(private$.radius_cv)) {
              cli::cli_warn(c("!" = "No {.code radius_cv} provided, using default value of 1.5."))
              private$.radius_cv <- 1.5
            }
          }
        }
      }

      if (self$type == "zero") {
        if (is.null(private$.end_time)) {
          cli::cli_warn(c("!" = "No {.code end_time} provided, using default unit of 60 min."))
          private$.end_time <- 60
          private$.end_time_unit <- "min"
        }
        if (is.null(private$.end_time_unit)) {
          cli::cli_warn(c("!" = "No {.code end_time_unit} provided, using default unit of min."))
          private$.end_time_unit <- "min"
        }
      }

      if (self$type == "first") {
        if (is.null(private$.thalf)) {
          cli::cli_warn(c("!" = "No {.code thalf} provided, using default unit of 0.01 min."))
          private$.thalf <- 0.01
          private$.thalf_unit <- "min"
        }
        if (is.null(private$.thalf_unit)) {
          cli::cli_warn(c("!" = "No {.code thalf_unit} provided, using default unit of min."))
          private$.thalf_unit <- "min"
        }
      }

      if (self$type == "table") {
        if (is.null(private$.tableX) || is.null(private$.tableY)) {
          cli::cli_abort(c("x" = "No {.code tableX} or {.code tableY} provided. For table formulation, provide release time profile."))
        }
        if (length(private$.tableX) != length(private$.tableY)) {
          cli::cli_abort(c("x" = "{.code tableX} and {.code tableY} should have the same length."))
        }
        if (is.null(private$.suspension)) {
          cli::cli_warn(c("x" = "No {.code suspension} provided, using default of 'TRUE'."))
          private$.suspension <- TRUE
        }
      }
      invisible(self)
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      cli::cli_text(self$name)
      cli::cli_li(paste("Type:", formulation_types[[self$type]]$human))

      for (param in private$.parameters()) {
        if (param$Name == "Type of particle size distribution") {
          cli::cli_li(
            paste(
              paste0(param$Name, ":"),
              purrr::keep(particle_size_dist_types, ~ .x$pksim == param$Value)[[1]]$human
            )
          )
        } else if (param$Name == "Particle size distribution") {
          cli::cli_li(
            paste(
              paste0(param$Name, ":"),
              purrr::keep(particle_size_dists, ~ .x$pksim == param$Value)[[1]]$human
            )
          )
        } else if (self$type == "table" && param$Name == "Fraction (dose)") {
          cli::cli_li("Release profile:")
          cli::cli_ul()
          print(
            data.frame("Time [h]" = private$.tableX, "Fraction (dose)" = private$.tableY,
                       check.names = FALSE),
            row.names = FALSE
          )
        } else {
          cli::cli_li(paste(paste0(param$Name, ":"), param$Value, param$Unit))
        }
      }
      invisible(self)
    }
  ),
  private = list(
    .name = NULL,
    .type = NULL,
    .dissolution_time = NULL,
    .dissolution_time_unit = NULL,
    .lag_time = NULL,
    .lag_time_unit  = NULL,
    .dissolution_shape = NULL,
    .suspension = NULL,
    .thickness = NULL,
    .thickness_unit = NULL,
    .distribution_type = NULL,
    .radius = NULL,
    .radius_unit = NULL,
    .particle_size_distribution = NULL,
    .radius_sd = NULL,
    .radius_sd_unit = NULL,
    .radius_cv = NULL,
    .radius_min = NULL,
    .radius_min_unit = NULL,
    .radius_max = NULL,
    .radius_max_unit = NULL,
    .n_bins = NULL,
    .end_time = NULL,
    .end_time_unit = NULL,
    .thalf = NULL,
    .thalf_unit = NULL,
    .tableX = NULL,
    .tableY = NULL,
    .parameters = function() {
      param_list <- list()
      if (self$type %in% c("weibull", "lint80")) {
        param_list <- list(
          list(
            Name = paste0("Dissolution time (", ifelse(self$type == "weibull", "50%", "80%"), " dissolved)"),
            Value = private$.dissolution_time,
            Unit = private$.dissolution_time_unit
          ),
          list(
            Name = "Lag time",
            Value = private$.lag_time,
            Unit = private$.lag_time_unit
          )
        )

        if (self$type == "weibull") {
          param_list <- c(param_list, list(
            list(
              Name = "Dissolution shape",
              Value = private$.dissolution_shape,
              Unit = ""
            )
          ))
        }

        param_list <- c(param_list, list(
          list(
            Name = "Use as suspension",
            Value = as.numeric(private$.suspension)
          )
        ))
      }

      if (self$type == "particle") {
        param_list <- list(
          list(
            Name = "Thickness (unstirred water layer)",
            Value = private$.thickness,
            Unit =  private$.thickness_unit
          ),
          list(
            Name = "Type of particle size distribution",
            Value = particle_size_dist_types[[private$.distribution_type]]$pksim
          )
        )

        param_list <- c(param_list, list(
          list(
            Name = paste0("Particle radius (", ifelse(private$.distribution_type == "mono" || private$.particle_size_distribution == "lognormal", "", "geo"), "mean)"),
            Value = private$.radius,
            Unit = private$.radius_unit
          )
        ))

        if (private$.distribution_type == "poly") {
          param_list <- c(param_list, list(
            list(
              Name = "Particle size distribution",
              Value = particle_size_dists[[private$.particle_size_distribution]]$pksim
            )
          ))

          if (private$.particle_size_distribution == "normal") {
            param_list <- c(param_list, list(
              list(
                Name = "Particle radius (SD)",
                Value = private$.radius_sd,
                Unit = private$.radius_sd_unit
              )
            ))
          } else {
            param_list <- c(param_list, list(
              list(
                Name = "Coefficient of variation",
                Value = private$.radius_cv
              )
            ))
          }

          param_list <- c(param_list, list(
            list(
              Name = "Particle radius (min)",
              Value = private$.radius_min,
              Unit = private$.radius_min_unit
            ),
            list(
              Name = "Particle radius (max)",
              Value = private$.radius_max,
              Unit = private$.radius_max_unit
            ),
            list(
              Name = "Number of bins",
              Value = private$.n_bins
            )
          ))
        }
      }

      if (self$type == "zero") {
        param_list <- list(
          list(
            Name = paste0("End time"),
            Value = private$.end_time,
            Unit = private$.end_time_unit
          )
        )
      }

      if (self$type == "first") {
        param_list <- list(
          list(
            Name = "t1/2",
            Value = private$.thalf,
            Unit = private$.thalf_unit
          )
        )
      }

      if (self$type == "table") {
        param_list <- list(
          list(
            Name = "Use as suspension",
            Value = as.numeric(private$.suspension)
          )
        )
        param_list <- c(param_list, list(
          list(
            Name = "Fraction (dose)",
            Value = private$.tableY[1],
            TableFormula = list(
              Name = "Fraction (dose)",
              XName = "Time",
              XDimension = "Time",
              XUnit = "h",
              YName = "Fraction (dose)",
              YDimension = "Dimensionless",
              UseDerivedValues = TRUE,
              Points = list(
                lapply(seq_along(private$.tableX), \(i) {
                  list(
                    X = private$.tableX[i],
                    Y = private$.tableY[i],
                    RestartSolver = FALSE
                  )
                })
              )
            )
          )
        ))
      }
      return(param_list)
    }
  )
)

#' @title Create a formulation
#' @description
#' Create a formulation
#' @param name Name of the formulation to create
#' @param type Type of the formulation to create
#' @param ... additional parameters that depends on the `type` of formulation:
#' - for weibull formulation:
#'  - dissolution_time: Time to achieve 80% dissolution (default 240)
#'  - dissolution_time_unit: Time unit for dissolution_time (default min)
#'  - lag_time: lag time before dissolution starts (default 0)
#'  - lag_time_unit: Time unit for lag_time (default min)
#'  - dissolution_shape: dissolution shape parameter (default 0.92)
#'  - suspension: Boolean, whether to use as suspension (default True)
#' - for lint80 formulation:
#'  - dissolution_time: Time to achieve 80% dissolution (default 240)
#'  - dissolution_time_unit: Time unit for dissolution_time (default min)
#'  - lag_time: lag time before dissolution starts (default 0)
#'  - lag_time_unit: Time unit for lag_time (default min)
#'  - suspension: Boolean, whether to use as suspension (default True)
#' - for particle formulation:
#'  - thickness: Thickness of unstirred water layer (default 30)
#'  - thickness_unit: Unit for thickness of unstirred water layer (default µm)
#'  - distribution_type: Type of distribution, either "mono" or "poly" (default "mono")
#'  - radius: Particle distribution radius, mean or geomean depending on distribution (default 10)
#'  - radius_unit: Unit for particle distribution radius (default µm)#'
#'  - for polydisperse formulation:
#'   - particle_size_distribution: either 'normal' (default) or 'lognormal'.
#'   - radius_sd: radius standard deviation for polydisperse normal only (default 3)
#'   - radius_sd_unit: Unit of radius_sd for polydisperse normal only (default µm)
#'   - radius_cv: radius coefficient of variation for polydisperse log-normal only (default 1.5)
#'   - radius_min: minimum particle radius for polydispersed only (default 1)
#'   - radius_min_unit: unit of the minimum particle radius for polydispersed only (default µm)
#'   - radius_max: maximum particle radius for polydispersed only (default 19)
#'   - radius_max_unit: unit of the maximum particle radius for polydispersed only (default µm)
#'   - n_bins: number of bins for polydispersed only (default 3)
#' - for table formulation:
#'  - tableX: Vector of time points for the release profile in hours
#'  - tableY: Vector of fraction of dose at each time point
#'  - suspension: Boolean, whether to use as suspension (default True)
#' - for zero order formulation:
#'  - end_time: Time of administration end (default 60)
#'  - end_time_unit: Unit for time of administration end (default min)
#' - for first order formulation:
#'  - thalf: Half-life of the drug release process (default 0.01)
#'  - thalf_unit: Unit of half-life of the drug release process (default min)
#' @return A new `Formulation` object.
#' @export
#' @examples
#' # Create a dissolved formulation (simplest type)
#' dissolved_form <- create_formulation(
#'   name = "Immediate release solution",
#'   type = "dissolved"
#' )
#'
#' # Create a Weibull tablet formulation
#' weibull_form <- create_formulation(
#'   name = "Standard tablet",
#'   type = "weibull",
#'   dissolution_time = 180,
#'   dissolution_time_unit = "min",
#'   dissolution_shape = 0.85
#' )
#'
#' # Create a particle formulation with monodisperse distribution
#' particle_form <- create_formulation(
#'   name = "Suspension",
#'   type = "particle",
#'   thickness = 25,
#'   thickness_unit = "µm",
#'   radius = 5,
#'   radius_unit = "µm"
#' )
#'
#' # Create a table-based formulation with custom release profile
#' table_form <- create_formulation(
#'   name = "Custom release profile",
#'   type = "table",
#'   tableX = c(0, 0.5, 1, 2, 4, 8),
#'   tableY = c(0, 0.1, 0.3, 0.6, 0.9, 1.0)
#' )
create_formulation <- function(name, type, ...) {
  formulation <- Formulation$new(
    name = name,
    type = type,
    ...
  )
  return(formulation)
}

formulation_from_data <- function(formulation_data) {
  name <- formulation_data$Name

  type <- names(purrr::keep(formulation_types, ~ .x$pksim == formulation_data$FormulationType))

  # if (type != "table") {
    disso_time <- purrr::keep(formulation_data$Parameters, ~ .x$Name %in% paste0("Dissolution time (", c(50,80), "% dissolved)"))
    disso_time_value <- purrr::pluck(disso_time, 1, "Value")
    disso_time_unit <- purrr::pluck(disso_time, 1, "Unit")

    lag_time <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Lag time")
    lag_time_value <- purrr::pluck(lag_time, 1, "Value")
    lag_time_unit <- purrr::pluck(lag_time, 1, "Unit")

    disso_shape <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Dissolution shape")
    disso_shape_value <- purrr::pluck(disso_shape, 1, "Value")

    suspension <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Use as suspension")
    suspension_value <- as.logical(purrr::pluck(suspension, 1, "Value"))

    thickness <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Thickness (unstirred water layer)")
    thickness_value <- purrr::pluck(thickness, 1, "Value")
    thickness_unit <- purrr::pluck(thickness, 1, "Unit")

    distrib_type <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Type of particle size distribution")
    distrib_type_value <- purrr::pluck(distrib_type, 1, "Value")

    distrib <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Particle size distribution")
    distrib_value <- purrr::pluck(distrib, 1, "Value")

    radius <- purrr::keep(formulation_data$Parameters, ~ .x$Name %in% paste0("Particle radius (", c("","geo"), "mean)"))
    radius_value <- purrr::pluck(radius, 1, "Value")
    radius_unit <- purrr::pluck(radius, 1, "Unit")

    radius_cv <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Coefficient of variation")
    radius_cv_value <- purrr::pluck(radius, 1, "Value")

    radius_sd <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Particle radius (SD)")
    radius_sd_value <- purrr::pluck(radius_sd, 1, "Value")
    radius_sd_unit <- purrr::pluck(radius_sd, 1, "Unit")

    radius_min <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Particle radius (min)")
    radius_min_value <- purrr::pluck(radius_min, 1, "Value")
    radius_min_unit <- purrr::pluck(radius_min, 1, "Unit")

    radius_max <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Particle radius (max)")
    radius_max_value <- purrr::pluck(radius_max, 1, "Value")
    radius_max_unit <- purrr::pluck(radius_max, 1, "Unit")

    n_bins <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Number of bins")
    n_bins_value <- purrr::pluck(n_bins, 1, "Value")

    end_time <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "End time")
    end_time_value <- purrr::pluck(end_time, 1, "Value")
    end_time_unit <- purrr::pluck(end_time, 1, "Unit")

    thalf <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "t1/2")
    thalf_value <- purrr::pluck(thalf, 1, "Value")
    thalf_unit <- purrr::pluck(thalf, 1, "Unit")

    table <- purrr::keep(formulation_data$Parameters, ~ .x$Name == "Fraction (dose)")
    tablePoints <- purrr::pluck(table, 1, "TableFormula", "Points")
    tableXValues <- purrr::list_c(purrr::map(tablePoints, ~ .x$X))
    tableYValues <- purrr::list_c(purrr::map(tablePoints, ~ .x$Y))

    return(
      Formulation$new(
        name = name,
        type = type,
        dissolution_time = disso_time_value,
        dissolution_time_unit = disso_time_unit,
        lag_time = lag_time_value,
        lag_time_unit = lag_time_unit,
        dissolution_shape = disso_shape_value,
        suspension = suspension_value,
        thickness = thickness_value,
        thickness_unit = thickness_unit,
        distribution_type = if (!is.null(distrib_type_value)) { names(keep(particle_size_dist_types, ~ .x$pksim == distrib_type_value))} else { NULL },
        particle_size_distribution = if (!is.null(distrib_value)) { names(keep(particle_size_dists, ~ .x$pksim == distrib_value))} else { NULL },
        radius = radius_value,
        radius_unit = radius_unit,
        radius_cv = radius_cv_value,
        radius_sd = radius_sd_value,
        radius_sd_unit = radius_sd_unit,
        radius_min = radius_min_value,
        radius_min_unit = radius_min_unit,
        radius_max = radius_max_value,
        radius_max_unit = radius_max_unit,
        n_bins = n_bins_value,
        end_time = end_time_value,
        end_time_unit = end_time_unit,
        thalf = thalf_value,
        thalf_unit = thalf_unit,
        tableX = tableXValues,
        tableY = tableYValues
      )
    )
  # } else {
  #   return(formulation_data)
  # }
}

#' Add a formulation to a snapshot
#'
#' @param snapshot a snapshot object.
#' @param formulation a formulation object created with `create_formulation()`.
#'
#' @return the updated snapshot with new formulation
#' @export
#' @examples
#' # Create a formulation
#' tablet_form <- create_formulation(
#'   name = "Extended release tablet",
#'   type = "weibull",
#'   dissolution_time = 360,
#'   dissolution_shape = 0.75
#' )
#'
#' # Add formulation to snapshot
#' snapshot <- add_formulation(snapshot, tablet_form)
add_formulation <- function(snapshot, formulation) {
  snapshot$add_formulation(formulation)
  invisible(snapshot)
}

#' Remove a formulation from a snapshot
#'
#' @param snapshot a snapshot object.
#' @param formualtion_name a character vector of protocol name(s) to remove
#'
#' @return the updated snapshot without the specified formulations
#' @export
#' @examples
#' # Remove a single formulation
#' snapshot <- remove_formulation(snapshot, "Extended release tablet")
#'
#' # Remove multiple formulations
#' snapshot <- remove_formulation(
#'   snapshot, 
#'   c("Immediate release solution", "Standard tablet")
#' )
remove_formulation <- function(snapshot, formulation_name) {
  snapshot$remove_formulation(formulation_name)
  invisible(snapshot)
}
