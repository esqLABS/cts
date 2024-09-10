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

  } else if (input %in% list_compounds(display = FALSE)) {

    check_internet()

    source <- get_osp_model_library()[[input]]

    cli_process_start(msg = "Downloading {input} Building Block Data")

  } else {

    cli_abort(message = c(x = "Invalid input type.", i = "Please provide a valid compound name, URL or path to a local file."))

  }

  snapshot <- jsonlite::fromJSON(source, flatten = TRUE)

  return(snapshot)
}
