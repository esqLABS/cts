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
      UniqueQuantityPath = stringr::str_replace(
        QuantityPath,
        paste0("\\|(", compound_pattern, ")\\|"),
        "|"
      )
    ) %>%
    dplyr::mutate(
      df,
      Compound = purrr::map_chr(
        QuantityPath,
        ~ {
          match <- compound_names[stringr::str_detect(
            .x,
            stringr::regex(compound_names, ignore_case = TRUE)
          )]
          if (length(match) > 0) match[1] else NA_character_
        }
      )
    ) %>%
    dplyr::select(-dplyr::any_of(c("IndividualId", "QuantityPath")))

  df %>%
    dplyr::rename(QuantityPath = UniqueQuantityPath) %>%
    tidyr::pivot_wider(
      names_from = Compound,
      values_from = Value,
      values_fn = list
    ) %>%
    dplyr::relocate(QuantityPath)
}

translate_end_time_unit <- function(end_time_unit) {
  switch(
    end_time_unit,
    "s" = 1,
    "min" = 60,
    "ks" = 1000,
    "h" = 3600,
    "day(s)" = 86400,
    "week(s)" = 604800,
    "month(s)" = 2628000,
    "year(s)" = 31536000
  )
}

#' Convert a DataSet object to an observed data building block
#'
#' @param dataset A DataSet object
#'
#' @return A json representation of the DataSet object
#'
#' @keywords internal
dataSetToSnapshot <- function(dataset) {
  isDS <- ospsuite.utils::isOfType(dataset, "DataSet")

  if (!isDS) {
    cli::cli_abort(message = "Invalid `dataset` argument. Must be a (list of) `DataSet` object(s) from `{ospsuite}`")
  }

  data <- list(
    Name = dataset$name,
    ExtendedProperties = unname(purrr::map2(dataset$metaData, names(dataset$metaData), \(x1, x2){list(Name = x2, Value = x1)})),
    Columns = list(
      list(
        Name = dataset$yDimension,
        DataInfo = list(
          Origin = "Observation",
          AuxiliaryType = "Undefined",
          MolWeight = dataset$molWeight
        ),
        Values = as.list(dataset$yValues),
        Dimension = dataset$yDimension,
        Unit = dataset$yUnit
      )
    ),
    BaseGrid = list(
      Name = dataset$xDimension,
      DataInfo = list(
        Origin = "BaseGrid",
        AuxiliaryType = "Undefined"
      ),
      Values = as.list(dataset$xValues),
      Dimension = dataset$xDimension,
      Unit = dataset$xUnit
    )
  )

  if (!is.null(dataset$LLOQ)) {
    data$Columns[[1]]$DataInfo$LLOQ <- dataset$LLOQ
  }

  if (!is.null(dataset$yErrorType)) {
    data$Columns[[1]]$RelatedColumns = list(
      list(
        Name = dataset$yErrorType,
        DataInfo = list(
          Origin = "ObservationAuxiliary",
          AuxiliaryType = dataset$yErrorType,
          MolWeight = dataset$molWeight
        ),
        Values = as.list(dataset$yErrorValues),
        Dimension = dataset$yDimension,
        Unit = dataset$yErrorUnit
      )
    )
  }

  return(data)
}


#' Load DataSet from OSP snapshot observed data
#'
#' @description
#' Creates a DataSet object (from ospsuite package) from observed data in a snapshot or ddi.
#' This function converts snapshot observed data format to the standardized DataSet format
#' used throughout the OSP ecosystem.
#'
#' @param observed_data_structure Raw observed data structure from a snapshot JSON
#' @return A DataSet object from the ospsuite package
#' @keywords internal
loadDataSetFromSnapshot <- function(observed_data_structure) {
  # need to convert json as loaded slightly differently in osp.snapshots
  observed_data_snap <- jsonlite::fromJSON(
    jsonlite::toJSON(observed_data_structure, digits = NA, auto_unbox = TRUE),
    simplifyVector = TRUE,
    simplifyDataFrame = FALSE
  )

  dts <- osp.snapshots::loadDataSetFromSnapshot(observed_data_snap)

  return(dts)
}
