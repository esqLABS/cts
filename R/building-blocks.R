#' List official building blocks templates
#' @description reads the building blocks template json file from url
#' @param url optional character string with a url to the building blocks template json file
#'
#' @return a named list with url to the building blocks templates
#'
#' @noRd
#' @keywords internal
get_buildingblocks_data <- function(url = buildingblocks_url) {
  check_internet()

  # If the data is not already cached in `the` package environment, download it
  if (is.null(the$buildingblocks_data)) {
    cli_process_start(msg = "Listing Compounds Building Blocks from OSP repositories")
    buildingblocks_data_raw <- jsonlite::fromJSON(url, simplifyDataFrame = FALSE)$Templates
    the$buildingblocks_data <-
      purrr::map(buildingblocks_data_raw, ~ .x$Url) %>%
      purrr::set_names(purrr::map_vec(buildingblocks_data_raw, ~ .x$Name))
  }

  return(the$buildingblocks_data)
}

#' Available Compound Building Blocks
#' @description List all available official compound building blocks on OSPsuite
#'
#' @return a list of the available compound building blocks
#'
#' @export
#' @examples
#' list_compounds()
list_compounds <- function(...) {
  compounds_names <- names(get_buildingblocks_data())

  args <- list(...)
  if (!isFALSE(args$display)) {
    cli_ul(compounds_names)
  }

  invisible(compounds_names)
}
