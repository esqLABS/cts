#' Create a coumpound building block
#'
#' @param input character string that is wether
#' - a compound name from the list of available compounds `list_compounds()`.
#' - a URL to a compound building block.
#' - a Path to a local file.
#'
#'
#' @return a compound building block as a list
#' @export
#'
#' @examples
#' \dontrun{
#' compound("Rifampicin")
#' compound("Rifampicin-Model.json")
#' compound("https://raw.githubusercontent.com/Open-Systems-Pharmacology/Alfentanil-Model/v2.2/Alfentanil-Model.json")
#' }
compound <- function(input) {
  Compound$new(input)
}


Compound <- R6::R6Class(
  classname = "Compound",
  class = TRUE,
  inherit = Snapshot,
  public = list(),
  private = list(),
  active = list()
  )
