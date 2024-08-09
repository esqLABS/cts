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
  if (is_file(input)) {
    source <- input
  } else if (is_url(input)) {
    check_internet()

    source <- input
  } else {
    rlang::arg_match(input, list_compounds(display = FALSE))

    source <- get_buildingblocks_data()[[input]]

    check_internet()

    cli_process_start("Downloading Compound Building Block")
  }

  snapshot <- jsonlite::fromJSON(source, simplifyDataFrame = FALSE)


  return(snapshot)
}
