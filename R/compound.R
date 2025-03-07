#' Create a compound building block
#'
#' @param input character string that is wether
#' - a compound name from the list of available compounds `list_compounds()`.
#' - a URL to a compound building block.
#' - a Path to a local file.
#'
#' @return a compound building block as a list
#' @export
#'
#' @examples
#' compound("Rifampicin")
#' compound("https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json")
#' \dontrun{
#' compound("Rifampicin-Model.json")
#' #' }
compound <- function(input) {
  Compound$new(input)
}

#' R6 Class Representing a Compound Snapshot
#'
#' @description
#' A snapshot is a JSON file that contains all the information about a model.
#' This class is used to import, access and manipulate the data from a compound snapshot.
Compound <- R6::R6Class(
  classname = "Compound",
  class = TRUE,
  inherit = Snapshot,
  public = list(),
  private = list(),
  active = list()
)
