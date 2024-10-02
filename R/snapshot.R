#' R6 Class Representing a Snapshot
#'
#' @description
#' A snapshot is a JSON file that contains all the information about a model.
#' This class is used to import, access and manipulate the data from a snapshot.
Snapshot <- R6::R6Class(
  classname = "Snapshot",
  class = TRUE,
  public = list(
    #' @field source The source of the snapshot (local file, url, ...)
    source = NULL,
    #' @field data The data of the snapshot
    data = NULL,
    #' @description
    #' Create a Snapshot object.
    #' @param input character string that is wether
    #' - a compound name from the list of available compounds `list_compounds()`.
    #' - a URL to a compound building block.
    #' - a Path to a local file.
    #' @return A new `Snapshot` object.
    initialize = function(input) {
      self$source <- get_source(input)
      self$data <- private$read_json(self$source)
      invisible(self)
    },
    #' @description
    #' Pretty print the snapshot data.
    print = function() {
      compounds <- cli_ul()
      private$print_names("compounds")
      individuals <- cli_ul()
      private$print_names("individuals")
      populations <- cli_ul()
      private$print_names("populations")
      formulations <- cli_ul()
      private$print_names("formulations")
      protocols <- cli_ul()
      private$print_names("protocols")
      observerSets <- cli_ul()
      private$print_names("observer_sets")
      events <- cli_ul()
      private$print_names("events")
      simulations <- cli_ul()
      private$print_names("simulations")
      observedData <- cli_ul()
      private$print_names("observed_data")
      invisible(self)
    },
    #' @description
    #' Export a DDI simulation to a JSON file.
    #' @param path character string that is the path to the output file.
    export = function(path) {
      private$write_json(self$data, path)
    }
  ),
  private = list(
    #' description
    #' get_names the names of a field in the snapshot.
    get_names = function(field) {
      list_c(map(self[[field]], ~ .x$Name))
    },
    print_names = function(field){
      names <- self[[paste0(field, "Names")]]
      cli_text(snakecase::to_title_case(field), ":", if (length(names) == 0) {
        " None"
      })
      if (length(names) > 0) {
        cli_ul(names)
      }
    },
    read_json = function(source) {
      jsonlite::fromJSON(source,
        simplifyDataFrame = FALSE,
        simplifyVector = FALSE
      )
    },
    write_json = function(data, path) {
      jsonlite::write_json(data,
        path = path,
        pretty = TRUE,
        auto_unbox = TRUE,
        digits = NA
      )
    }
  ),
  active = list(
    #' @field compounds Access the compounds data from the snapshot.
    compounds = function() {
      self$data$Compounds
    },
    #' @field compoundsNames Names of the compounds in the snapshot.
    compoundsNames = function(){
      private$get_names("compounds")
    },
    #' @field individuals Access the individuals data from the snapshot.
    individuals = function(){
      self$data$Individuals
    },
    #' @field individualsNames Names of the individuals in the snapshot.
    individualsNames = function() {
      private$get_names("individuals")
    },
    #' @field populations Access the populations data from the snapshot.
    populations = function(){
      self$data$Populations
    },
    #' @field populationsNames Names of the populations in the snapshot.
    populationsNames = function() {
      private$get_names("populations")
    },
    #' @field formulations Access the formulations data from the snapshot.
    formulations = function(){
      self$data$Formulations
    },
    #' @field formulationsNames Names of the formulations in the snapshot.
    formulationsNames = function() {
      private$get_names("formulations")
    },
    #' @field protocols Access the protocols data from the snapshot.
    protocols = function(){
      self$data$Protocols
    },
    #' @field protocolsNames Names of the protocols in the snapshot.
    protocolsNames = function() {
      private$get_names("protocols")
    },
    #' @field expression_profiles Access the expression profiles data from the snapshot.
    expression_profiles = function(){
      self$data$ExpressionProfiles
    },
    #' @field expression_profilesNames Names of the expression profiles in the snapshot.
    expression_profilesNames = function() {
      private$get_names("expression_profiles")
    },
    #' @field observer_sets Access the observer sets data from the snapshot.
    observer_sets = function(){
      self$data$ObserverSets
    },
    #' @field observer_setsNames Names of the observer sets in the snapshot.
    observer_setsNames = function() {
      private$get_names("observer_sets")
    },
    #' @field events Access the events data from the snapshot.
    events = function(){
      self$data$Events
    },
    #' @field eventsNames Names of the events in the snapshot.
    eventsNames = function() {
      private$get_names("events")
    },
    #' @field simulations Access the simulations data from the snapshot.
    simulations = function(){
      self$data$Simulations
    },
    #' @field simulationsNames Names of the simulations in the snapshot.
    simulationsNames = function() {
      private$get_names("simulations")
    },
    #' @field observed_data Access the observed data from the snapshot.
    observed_data = function(){
      self$data$ObservedData
    },
    #' @field observed_dataNames Names of the observed data in the snapshot.
    observed_dataNames = function() {
      private$get_names("observed_data")
    }
  )
)

#' @title Get the source file path or url from the input.
#' @description
#' Get the source file path or url from the input.
#' @param input character string that is wether
#' - a compound name from the list of available compounds `list_compounds()`.
#' - a URL to a compound building block.
#' - a Path to a local file.
#' @return The source file path or url.
get_source <- function(input) {
  if (is_file_local(input)) {
    source <- normalizePath(input)
  } else if (is_file_url(input)) {
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
}
