#' List released OSP compounds models
#' @description reads the model library reference json file
#'
#' @return a named list with url to the compounds models
#'
#' @noRd
#' @keywords internal
get_osp_model_library <- function() {
  check_internet()

  # If the data is not already cached in `the` package environment, download it
  if (is.null(the$ model_library_data)) {
    cli_process_start(msg = "Listing Compounds Building Blocks available in {cli::style_hyperlink(text = 'OSP repositories', url = model_library_url)}")
    model_library_data_raw <- jsonlite::fromJSON(model_library_url, simplifyDataFrame = FALSE)$Templates
    the$model_library_data <-
      purrr::map(model_library_data_raw, ~ .x$Url) %>%
      purrr::set_names(purrr::map_vec(model_library_data_raw, ~ .x$Name))
  }

  return(the$model_library_data)
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
  compounds_names <- names(get_osp_model_library())

  args <- list(...)
  if (!isFALSE(args$display)) {
    cli_ul(compounds_names)
  }

  invisible(compounds_names)
}
