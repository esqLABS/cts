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
#' Transforms PK analysis data by removing molecules names from `QuantityPath`,
#' identifying molecules, and pivoting to a wide format with columns for each
#' molecule.
#'
#' @param df A data frame or tibble containing PK analysis data returned by
#' `ospsuite::calculatePKAnalyses`.
#' @param molecule_names A character vector of molecules names.
#'
#' @return A tibble with individual columns for each molecule.
#'
#' @keywords internal
pivot_pk_analysis <- function(df, molecule_names) {
  molecule_pattern <- paste(molecule_names, collapse = "|")

  df <- df %>%
    dplyr::mutate(
      UniqueQuantityPath = stringr::str_replace(
        QuantityPath,
        paste0("\\|(", molecule_pattern, ")\\|"),
        "|"
      ),
      Molecule = stringr::str_extract(
        QuantityPath,
        paste0("\\|(", molecule_pattern, ")\\|"),
        1
      )
    ) %>%
    dplyr::arrange("IndividualId") %>%
    dplyr::select(-"QuantityPath")


  df <- df %>%
    dplyr::rename(QuantityPath = UniqueQuantityPath)

  # for pop sim
  if (length(unique(df$IndividualId)) > 1 ) {
    df <- df %>%
      dplyr::group_by(QuantityPath, Parameter, Unit, Molecule) %>%
      dplyr::summarize_at(.vars = c("Value", "IndividualId"), .funs = list) %>%
      dplyr::ungroup()
  }
  # if all value in columns are length one remove the list

  df<- df %>% tidyr::pivot_wider(
      names_from = Molecule,
      values_from = Value
    ) %>%
    dplyr::relocate(QuantityPath)

  return(df)
}

#' Pretty print PK Analysis Data
#'
#' Print PK analysis data to a pretty table
#'
#' @param snapshot A snapshot or ddi object for which to make a pretty table of PK result
#' @param simulation_name Optional for which simulation(s) to print the pk analysis result in pretty format
#' @param molecule_name Optional for which molecule(s) to print the pk analysis result in pretty format
#' @param pk_parameter Optional for which PK parameters to print the pk analysis result in pretty format
#' @param aggregation character string either mean or median for the type of aggregation
#' @param digits number of significant digits to show
#' @export
pretty_pk <- function(snapshot, simulation_name = NULL, molecule_name = NULL, pk_parameter = NULL, aggregation = "mean", digits = 3) {
  ospsuite.utils::validateIsOfType(snapshot, "Snapshot")
  pkresult <- snapshot$pk_analysis_results

  if (is.null(simulation_name)) {
    simulation_name <- snapshot$get_names("simulations")
  }

  if (is.null(molecule_name)) {
    molecule_name <- unique(unlist(sapply(pkresult, \(pk) {pk %>% dplyr::select(-c("QuantityPath", "Parameter", "Unit")) %>% names()})))
  }

  for (sim_name in simulation_name) {
    if (is.null(pk_parameter)) {
      pk_parameter <- unique(unlist(pkresult[[sim_name]]$Parameter))
    }

    if (sim_name %in% names(pkresult)) {
      cli::cli_h1(sim_name)

      for (cpd_name in molecule_name) {
        if(cpd_name %in% colnames(pkresult[[sim_name]])) {
          cli::cli_h2(cpd_name)
          quantity <- unique(unlist(pkresult[[sim_name]] %>% dplyr::filter(!is.na(cpd_name)) %>% dplyr::select("QuantityPath")))

          for (qp in quantity) {
            pk_subset <- pkresult[[sim_name]] %>% dplyr::filter(QuantityPath == qp, Parameter %in% pk_parameter)

            tmp <- c()
            for (i in seq_len(nrow(pk_subset))) {
              values <- (pk_subset %>%  dplyr::pull(cpd_name))[[i]]
              param <- pk_subset[[i,"Parameter"]]
              unit <- pk_subset[[i,"Unit"]]

              if(is.na(unit)) {
                unit <- ""
              }

              if (is.null(values)) {
                next()
              } else if (length(values) > 1) {
                if (aggregation == "mean") {
                  tmp <- c(tmp, sprintf(paste0("%s: %.", digits, "g +/- %.", digits,"g %s"), param, mean(values), sd(values), unit))
                } else if (aggregation == "median") {
                  q <- quantile(values, probs = c(0.5, 0.25, 0.75), na.rm = TRUE);
                  tmp <- c(tmp, sprintf(paste0("%s: %.", digits, "g (%.", digits,"g \u2013 %.", digits, "g) %s"), param, q[1], q[2], q[3], unit))
                }
              } else {
                tmp <- c(tmp, sprintf(paste0("%s: %.", digits, "g %s"), param, values, unit))
              }
            }
            if (length(tmp) > 0) {
              cli::cli_h3(id = "qp_ul", qp)
              cli::cli_ul(id = "pk_par", tmp)
            }
          }
        }
      }
    }
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
#' @param molecule_name Optional. Molecule(s) for which to print the pk
#' analysis result.
#' @param pk_parameter Optional. PK parameter(s) for which to print the pk
#' analysis result.
#' @param aggregation character string either mean or median for the type of aggregation
#' @param digits number of significant digits to show
#' @export
compare_pk <- function(
    snapshot,
    simulation_name = NULL,
    reference_simulation_name = NULL,
    molecule_name = NULL,
    pk_parameter = NULL,
    aggregation = "mean",
    digits = 3
  ) {
  ospsuite.utils::validateIsOfType(snapshot, "Snapshot")
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
  pk_molecules_names <- pkresult %>% dplyr::select(-c("Simulation", "QuantityPath", "Parameter", "Unit")) %>% names()
  if (is.null(molecule_name)) {
    molecule_name <- pk_molecules_names
  } else {
    molecule_name <- intersect(pk_molecules_names, molecule_name)
  }

  pkresult <- pkresult %>%
    dplyr::select(any_of(c("QuantityPath", "Parameter", "Unit", "Simulation", molecule_name)))

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

  res <- list()
  for (compound  in molecule_name) {
    for (quantity in quantities) {
      pk_subset <- pkresult %>%
        dplyr::filter(QuantityPath == quantity) %>%
        dplyr::select(any_of(c(compound, "Simulation", "Parameter", "Unit"))) %>%
        dplyr::filter(!is.na(compound), Parameter %in% pk_parameter)
      pk_subset <- tidyr::pivot_wider(data = pk_subset, names_from = Simulation, values_from = compound)

      pk_subset <- pk_subset %>%
        dplyr::select_if(.predicate = \(x){any(!is.null(unlist(x)))})

      if(ncol(pk_subset) > 2) {
        if (is.null(reference_simulation_name)){
          if (aggregation == "mean") {
            pk_subset <- pk_subset %>% dplyr::mutate_if(is.list, .funs = \(x) {
              sapply( x, \(y) {
                if(length(y) > 1) {
                  y <- sprintf(paste0("%.", digits, "g +/- %.",digits ,"g"), mean(y), sd(y))
                } else if (length(y) == 1){
                  y <- sprintf(paste0("%.", digits, "g"), y)
                } else {
                  y <- ""
                }
              })
            })
          } else if (aggregation == "median") {
            pk_subset <- pk_subset %>% dplyr::mutate_if(is.list, .funs = \(x) {
              sapply( x, \(y) {
                if(length(y) > 1) {
                  q <- quantile(y, probs = c(0.5, 0.25, 0.75), na.rm = TRUE);
                  y <- sprintf(paste0("%.", digits, "g (%.",digits ,"g \u2013 %.", digits, "g)"), q[1], q[2], q[3])
                } else if (length(y) == 1) {
                  y <- sprintf(paste0("%.", digits, "g"), y)
                } else {
                  y <- ""
                }
              })
            })
          }
        } else {
          valid_ref <- is.character(reference_simulation_name)
          valid_ref <- valid_ref && length(reference_simulation_name) == 1
          valid_ref <- valid_ref && reference_simulation_name %in% colnames(pk_subset)

          # if only ref sim skip
          if (ncol(pk_subset) == 3) {
            res[[compound]][[quantity]] <- NULL
            next()
          }

          if (aggregation == "mean") {
            pk_subset <- pk_subset %>%
              dplyr::mutate_if(is.list, .funs = \(x) {
                sapply(x, mean)
              })
          } else if (aggregation == "median") {
            pk_subset <- pk_subset %>%
              dplyr::mutate_if(is.list, .funs = \(x) {
                sapply(x, median)
              })
          }

          sim_to_compare <- simulation_name[simulation_name != reference_simulation_name]
          pk_subset <- pk_subset %>%
            dplyr::mutate_at(dplyr::vars(dplyr::any_of(sim_to_compare)), ~ .x / get(reference_simulation_name))

          pk_subset <- pk_subset %>% dplyr::mutate_if(is.numeric, .funs = \(x) {
            sprintf(paste0("%.", digits, "g"), x)
          })
          pk_subset <- pk_subset %>% dplyr::select(-reference_simulation_name)

          # add ratio to param name
          pk_subset$Parameter <- paste0(pk_subset$Parameter, "_ratio")
        }

        pk_subset <- pk_subset %>%  dplyr::mutate_if(is.numeric, .funs = \(x) {sprintf(paste0("%.", digits, "g"), x)})

        # add unit to param column
        pk_subset$Unit[!is.na(pk_subset$Unit)] <- paste0("[", pk_subset$Unit[!is.na(pk_subset$Unit)], "]")
        pk_subset$Unit[is.na(pk_subset$Unit)] <- ""
        pk_subset$Parameter <- paste(pk_subset$Parameter, pk_subset$Unit)

        pk_subset <- pk_subset %>% dplyr::select(-"Unit")

        res[[compound]][[quantity]] <- pk_subset

      }
    }
  }

  for (compound in names(res)) {
    cli::cli_h2(compound)

    for (quantity in names(res[[compound]])) {
      cli::cli_h3(quantity)
      print.data.frame(res[[compound]][[quantity]], row.names = FALSE)
    }
  }
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
