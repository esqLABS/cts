#'
#' @importFrom curl has_internet
check_internet <- function() {
  if (!curl::has_internet()) {
    cli_abort(c(
      "x" = "No internect connection",
      "i" = "You need an internet connection to download the building
                    blocks data.",
      ">" = "Please check your connection and try again."
    ))
  }
}

is_url <- function(x, error_call = caller_env()) {
  # detect url
  if (grepl("^((http|ftp)s?|sftp)://", x)) {
    # test the url
    ans <- try(
      {
        suppressWarnings(
          download.file(x, destfile = tempfile(), quiet = T)
        )
      },
      silent = TRUE
    )

    if (inherits(ans, "try-error")) {
      cli_abort(
        message = c(
          x = "Invalid URL",
          i = "Please provide a valid URL."
        ),
        call = error_call
      )
    } else {
      return(TRUE)
    }
  } else {
    return(FALSE)
  }
}

is_file <- function(x) {
  all(file.exists(x) & !dir.exists(x))
}
