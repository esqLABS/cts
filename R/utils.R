#'
#' @importFrom curl has_internet
check_internet <- function(){
  if (!curl::has_internet()) {
    cli_alert_error("You need an internet connection to download the building
                    blocks data. Please check your connection and try again.")
  }
}
