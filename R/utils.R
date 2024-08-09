#'
#' @importFrom curl has_internet
check_internet <- function() {
  if (!curl::has_internet()) {
    cli_alert_error("You need an internet connection to download the building
                    blocks data. Please check your connection and try again.")
  }
}

is_url <- function(x) {
  grepl("^((http|ftp)s?|sftp)://", x)
}

is_file <- function(x) {
  all(file.exists(x) & !dir.exists(x))
}
