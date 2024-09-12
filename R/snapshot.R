Snapshot <- R6::R6Class(
  classname = "Snapshot",
  class = TRUE,
  public = list(
    source = NULL,
    data = NULL,
    initialize = function(input) {
      self$source <- private$get_source(input)
      self$data <- jsonlite::fromJSON(self$source, simplifyDataFrame = FALSE, simplifyVector = FALSE)
      invisible(self)
    },
    print = function() {
      compounds <- cli_ul()
      self$compoundsNames()
      individuals <- cli_ul()
      self$individualsNames()
      populations <- cli_ul()
      self$populationsNames()
      formulations <- cli_ul()
      self$formulationsNames()
      protocols <- cli_ul()
      self$protocolsNames()
      observerSets <- cli_ul()
      self$observerSetsNames()
      events <- cli_ul()
      self$eventsNames()
      simulations <- cli_ul()
      self$simulationsNames()
      observedData <- cli_ul()
      self$observedDataNames()



      invisible(self)
    },
    compoundsNames = function() {
      private$get_names("compounds")
    },
    individualsNames = function() {
      private$get_names("individuals")
    },
    populationsNames = function() {
      private$get_names("populations")
    },
    formulationsNames = function() {
      private$get_names("formulations")
    },
    protocolsNames = function() {
      private$get_names("protocols")
    },
    # Expression profiles do not have names
    # expressionProfileNames = function() {
    #   private$get_names("expression_profiles")
    # }
    observerSetsNames = function() {
      private$get_names("observer_sets")
    },
    eventsNames = function() {
      private$get_names("events")
    },
    simulationsNames = function() {
      private$get_names("simulations")
    },
    observedDataNames = function() {
      private$get_names("observed_data")
    }
  ),
  private = list(
    get_source = function(input) {
      if (is_file(input)) {
        source <- input
      } else if (is_url(input)) {
        check_internet()

        source <- input
      } else if (input %in% list_compounds(display = FALSE)) {
        check_internet()

        source <- get_osp_model_library()[[input]]

        cli_process_start(msg = "Downloading {input} Building Block Data")
      } else {
        cli_abort(message = c(x = "Invalid input type.", i = "Please provide a valid compound name, URL or path to a local file."))
      }
      return(source)
    },
    get_names = function(field) {
      names <- map(self[[field]], ~ .x$Name) %>% list_c()

        cli_text(snakecase::to_title_case(field), ":", if (length(names) == 0) {" None"})
        if (length(names) > 0) {
          cli_ul(names)
        }

      invisible(names)
    }
  ),
  active = list(
    compounds = function() {
      self$data$Compounds
    },
    individuals = function() {
      self$data$Individuals
    },
    populations = function() {
      self$data$Populations
    },
    formulations = function() {
      self$data$Formulations
    },
    protocols = function() {
      self$data$Protocols
    },
    expression_profiles = function() {
      self$data$ExpressionProfiles
    },
    observer_sets = function() {
      self$data$ObserverSets
    },
    events = function() {
      self$data$Events
    },
    simulations = function() {
      self$data$Simulations
    },
    observed_data = function() {
      self$data$ObservedData
    }
  )
)
