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
      values_from = Value
    ) %>%
    dplyr::relocate(QuantityPath)
}

#' Pretty print PK Analysis Data
#'
#' Print PK analysis data to a pretty table
#'
#' @param snapshot A snapshot or ddi object for which to make a pretty table of PK result
#' @param simulation_name Optional for which simulation(s) to print the pk analysis result in pretty format
#' @param compound_name Optional for which molecule(s) to print the pk analysis result in pretty format
#' @param pk_parameter Optional for which PK parameters to print the pk analysis result in pretty format
pretty_pk <- function(snapshot, simulation_name = NULL, compound_name = NULL, pk_parameter = NULL) {
  pkresult <- snapshot$pk_analysis_results

  if (is.null(simulation_name)) {
    simulation_name <- snapshot$get_names("simulations")
  }
  if (is.null(compound_name)) {
    compound_name <- snapshot$get_names("compounds")
  }

  for (sim_name in simulation_name) {
    if (is.null(pk_parameter)) {
      pk_parameter <- unique(unlist(pkresult[[sim_name]]$Parameter))
    }

    cat(
      cli::cli_format_method({
        if (sim_name %in% names(pkresult)) {
          cli::cli_h1(sim_name)

          for (cpd_name in compound_name) {
            if(cpd_name %in% colnames(pkresult[[sim_name]])) {
              cli::cli_h2(cpd_name)
              quantity <- unique(unlist(pkresult[[sim_name]] %>% dplyr::filter(!is.na(cpd_name)) %>% dplyr::select("QuantityPath")))

              for (qp in quantity) {
                # cli::cli_ul(id = "qp_ul")
                cli::cli_h3(id = "qp_ul", qp)

                pk_subset <- pkresult[[sim_name]] %>% dplyr::filter(QuantityPath == qp, Parameter %in% pk_parameter)

                tmp <- c()
                for (i in seq_len(nrow(pk_subset))) {
                  # print(i)
                  tmp <- c(tmp, sprintf("%s: %g %s", pk_subset[i,"Parameter"], pk_subset[i,cpd_name], pk_subset[i,"Unit"]))
                  # cli::cli_li(id = "pk_par", i)
                }
                cli::cli_ul(id = "pk_par", tmp)

                cli::cli_end(id = "pk_par")
              }
              cli::cli_end(id = "qp_ul")
            }
          }
        }

    }),
    sep = "\n"
    )
  }
}

#' Make a comparison table across simulations of the PK parameters
#'
#' Make a comparison table across simulations of the PK parameters
#'
#' @param snapshot A snapshot or ddi object for which to make a comparison
#' table of PK result.
#' @param simulation_name Optional. Simulation(s) for which to print the pk
#' analysis result.
#' @param reference_simulation_name  Optional. Reference simulation name against which
#' the other simulation(s) will be compared to.
#' @param compound_name Optional. Molecule(s) for which to print the pk
#' analysis result.
#' @param pk_parameter Optional. PK parameter(s) for which to print the pk
#' analysis result.
#' @param digits Number of significant digit to print.
compare_pk <- function(
    snapshot,
    simulation_name = NULL,
    reference_simulation_name = NULL,
    compound_name = NULL,
    pk_parameter = NULL,
    digits = 3
  ) {
  pkresult <- snapshot$pk_analysis_results

  # Create a single table for all simulations
  pkresult <- purrr::map2(pkresult, names(pkresult), \(pk, sim_name) {pk$Simulation <- sim_name; return(pk)})

  pkresult <- dplyr::bind_rows(pkresult)

  # get simulations and filter
  if (is.null(simulation_name)) {
    simulation_name <- unique(pkresult$Simulation)
  } else {
    simulation_name <- intersect(unique(pkresult$Simulation), simulation_name)
  }
  pkresult <- pkresult %>% dplyr::filter(Simulation %in% c(simulation_name, reference_simulation_name))

  # get compounds and filter
  if (is.null(compound_name)) {
    compound_name <- intersect(snapshot$get_names("compounds"), colnames(pkresult))
  } else {
    compound_name <- intersect(snapshot$get_names("compounds"), compound_name)
    compound_name <- intersect(colnames(pkresult), compound_name)
  }
  pkresult <- pkresult %>%
    dplyr::select(any_of(c("QuantityPath", "Parameter", "Unit", "Simulation", compound_name)))

  # get pk_parameter and filter
  if (is.null(pk_parameter)) {
    pk_parameter <- unique(pkresult$Parameter)
  } else {
    pk_parameter <- intersect(unique(pkresult$Parameter), pk_parameter)
  }
  pkresult <- pkresult %>% dplyr::filter(Parameter %in% pk_parameter)

  quantities <- unique(pkresult$QuantityPath)

  # pretty print by compound and quantity
  # make table with results for all simulations as columns
  # if reference simulation is given calculate ratio relative to that simulation
  if(!is.null(reference_simulation_name) && is.character(reference_simulation_name) && length(reference_simulation_name) == 1) {
    cli::cli_h1(paste0("Reference simulation: ", reference_simulation_name))
  }
  cat(
    cli::cli_format({
      for (compound  in compound_name) {
        cli::cli_h2(compound)
        for (quantity in quantities) {
          cli::cli_h3(quantity)
          pk_subset <- pkresult %>%
            dplyr::filter(QuantityPath == quantity) %>%
            dplyr::select(any_of(c(compound, "Simulation", "Parameter", "Unit"))) %>%
            dplyr::filter(!is.na(compound), Parameter %in% pk_parameter)
          pk_subset <- tidyr::pivot_wider(data = pk_subset, names_from = Simulation, values_from = compound)

          pk_subset$Parameter <- paste0(pk_subset$Parameter, " [", pk_subset$Unit, "]")
          pk_subset <- pk_subset %>% dplyr::select(-"Unit")

          if (!is.null(reference_simulation_name) && is.character(reference_simulation_name) && length(reference_simulation_name) == 1 && reference_simulation_name %in% colnames(pk_subset)) {
            pk_subset <- pk_subset %>% dplyr::mutate_at(dplyr::vars(dplyr::any_of(simulation_name)), ~ .x / get(reference_simulation_name))
            pk_subset <- pk_subset %>% dplyr::select(-reference_simulation_name)
          }
          pk_subset <- pk_subset %>% dplyr::mutate_if(is.numeric, .funs = ~ sprintf(paste0("%", digits, "g"), .x))
          print.data.frame(pk_subset, row.names = FALSE)
        }
      }
    })
  )
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
