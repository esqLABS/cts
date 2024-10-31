#' Check whether the user has an internet connection
#'
#' @return TRUE if the user has an internet connection
#'
#' @importFrom curl has_internet
#' @keywords internal
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

#' Check if the input is a URL to a file
#'
#' @param x string, the input to check
#'
#' @return TRUE if the input is a URL
#'
#' @keywords internal
is_file_url <- function(x, error_call = caller_env()) {
  # detect url
  if (grepl("^((http|ftp)s?|sftp)://", x)) {
    # test the url
    ans <- try(
      {
        suppressWarnings(
          utils::download.file(x, destfile = tempfile(), quiet = T)
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

#' Check if the input is a file
#'
#' @param x string, the input to check
#'
#' @return TRUE if the input is a file
#'
#' @keywords internal
is_file_local <- function(x) {
  all(file.exists(x) & !dir.exists(x))
}

#' Convert an object or vector to a list
#'
#' If the input is already a list, it returns the input unchanged. If the input
#' is a vector, it converts the vector to a list where each element of the vector
#' becomes an element of the list. For all other types, it wraps the input in a
#' list.
#'
#' @param x Any R object or vector.
#' @return A list containing `x`, a list of the elements of `x` if `x` is a
#' vector, or `x` itself if it's already a list.
#'
#' @keywords internal
to_list <- function(x) {
  if (is.list(x)) {
    return(x)
  } else if (is.vector(x)) {
    return(as.list(x))
  }
  return(list(x))
}

#' Add .json suffix to file path(s)
#'
#' This function checks if the provided file path(s) already have the ".json"
#' suffix. If not, it appends the ".json" suffix. The function is vectorized.
#'
#' @param path A character vector of file paths.
#' @return A character vector with the ".json" suffix added where necessary.
#'

with_json_suffix <- function(path) {
  purrr::modify_if(path, ~ !grepl("\\.json$", .x), ~ paste0(.x, ".json"))
}

#' Format PK Analysis Data
#'
#' Transforms PK analysis data by removing compound names from `QuantityPath`,
#' identifying compounds, and pivoting to a wide format with columns for each
#' compound.
#'
#' @param df A data frame or tibble containing PK analysis data returned by
#' `ospsuite::calculatePKAnalyses`.
#' @param compound_names A character vector of compound names.
#'
#' @return A tibble with individual columns for each compound.
#'
#' @keywords internal
pivot_pk_analysis <- function(df, compound_names) {
  compound_pattern <- paste(compound_names, collapse = "|")

  df <- df %>%
    dplyr::mutate(
      UniqueQuantityPath = stringr::str_remove(
        QuantityPath, paste0("\\|?(", compound_pattern, ")\\|?")
      )
    ) %>%
    dplyr::mutate(df,
      Compound = purrr::map_chr(QuantityPath, ~ {
        match <- compound_names[stringr::str_detect(
          .x, stringr::regex(compound_names, ignore_case = TRUE)
        )]
        if (length(match) > 0) match[1] else NA_character_
      })
    ) %>%
    dplyr::select(-dplyr::any_of(c("IndividualId", "QuantityPath")))

  df %>%
    dplyr::rename(QuantityPath = UniqueQuantityPath) %>%
    tidyr::pivot_wider(
      names_from = Compound,
      values_from = Value
    ) %>%
    dplyr::relocate(QuantityPath)
}
