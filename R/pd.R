#' Calculate Pearl index for a DDI object
#'
#' @param ddi ddi snapshot object
#' @param simulations simulations names for which to calculate pearl index
#' @param Kd Dissociation constant to use for the considered progestin
#' (only Kd for DRSP and LNG are known). If given the value superseed the default
#' values for LNG and DRSP.
#' @param tau Drug specific tau (transducer function) estimate as a measure of
#' intrinsic efficacy
#' @description
#' This function calculate PEARL Index for the ddi victim (i.e. progestin) based on
#' the simulation average concentration at the end of the simulation defined as
#' $1/2 (C_{max} + C_{through})$ for the last dosing of the simulation.
#' This should only be used for simulations meaningful repeated administration.
#'
#' @return a list of PEARL index value for each required simulation.
#' @export
pearlIndex <- function(ddi, simulations = NULL, Kd = NULL, tau = NULL) {
  progestin <- ddi$victim

  # make a clone of snapshot input to update all simulations with progestin blood concentration
  snapshotModified <- ddi$clone()

  # subset wanted simulations if given
  if (!is.null(simulations)) {
    snapshotModified$simulations <- snapshotModified$simulations[snapshotModified$get_names("simulations") %in% simulations]
  }
  # calculate PK analysis with PVB as output for the progestin
  snapshotModified$simulations <- purrr::map(
    snapshotModified$simulations,
    \(x) {
      x$OutputSelections <- list(glue::glue("Organism|PeripheralVenousBlood|{progestin}|Plasma (Peripheral Venous Blood)"))
      return(x)
    }
  )
  pkAnalysisRes <- run_pk_analysis(snapshotModified)

  # set Kd and tau values for DRSP and LNG if not given
  if (progestin == "Drospirenone") {
    tau <- tau %||% 2.602
    Kd <-  Kd %||% 2.949
  } else if (progestin == "Levonorgestrel 1") {
    tau <- tau %||% 3.046
    Kd <-  Kd  %||% 3.556
  } else if (is.null(Kd) || is.null(tau)) {
    cli::cli_abort(glue::glue("Kd and tau must be given."))
  }

  Cavg <- purrr::map(
    pkAnalysisRes,
    \(x) {
      x %>%
        dplyr::select(Parameter, Unit, dplyr::all_of(progestin)) %>%
        tidyr::pivot_wider(names_from = Parameter, values_from = dplyr::all_of(progestin)) %>%
        dplyr::mutate(Value = 0.5 * (C_max_tDLast_tEnd + C_trough_tDLast)) %>%
        dplyr::select(Value, Unit) %>%
        dplyr::filter(!is.na(Value))
    }
  )

  resPD <- purrr::map(
    Cavg,
    \(x) {
      calculatePD(
        Cavg = log10(ospsuite::toUnit(quantityOrDimension = "Concentration (molar)", values = x$Value, sourceUnit = x$Unit, targetUnit = "pmol/L")),
        BL = 85,
        Imax = 1,
        Kd = Kd,
        tau = tau,
        hill = 9.653
      )
    }
  )

  return(resPD)
}

#' Calculate ovulation rate for a DDI object
#'
#' @param ddi ddi snapshot object
#' @param simulations simulations names for which to calculate pearl index
#' @param Kd Dissociation constant to use for the considered progestin
#' (only Kd for DRSP and LNG are known). If given the value superseed the default
#' values for LNG and DRSP.
#' @param tau Drug specific tau (transducer function) estimate as a measure of
#' intrinsic efficacy
#' @description
#' This function calculate Ovulation Rate for the ddi victim (i.e. progestin) based on
#' the simulation average concentration at the end of the simulation defined as
#' $1/2 (C_{max} + C_{through})$ for the last dosing of the simulation.
#' This should only be used for simulations meaningful repeated administration.
#'
#' @return a list of ovulation rate for each required simulation.
#' @export
ovulationRate <- function(ddi, simulations = NULL, Kd = NULL, tau = NULL) {
  progestin <- ddi$victim

  # make a clone of snapshot input to update all simulation with progestin blood concentration
  snapshotModified <- ddi$clone()

  # subset wanted simulations if given
  if (!is.null(simulations)) {
    snapshotModified$simulations <- snapshotModified$simulations[snapshotModified$get_names("simulations") %in% simulations]
  }
  # calculate PK analysis with PVB as output for the progestin
  snapshotModified$simulations <- purrr::map(
    snapshotModified$simulations,
    \(x) {
      x$OutputSelections <- list(glue::glue("Organism|PeripheralVenousBlood|{progestin}|Plasma (Peripheral Venous Blood)"))
      return(x)
    }
  )
  pkAnalysisRes <- run_pk_analysis(snapshotModified)

  # set Kd and tau values for DRSP and LNG if not given
  if (progestin == "Drospirenone") {
    tau <- tau %||% 2.602
    Kd <-  Kd %||% 2.949
  } else if (progestin == "Levonorgestrel 1") {
    tau <- tau %||% 3.046
    Kd <-  Kd  %||% 3.556
  } else if (is.null(Kd) || is.null(tau)) {
    cli::cli_abort(glue::glue("Kd and tau must be given."))
  }

  Cavg <- purrr::map(
    pkAnalysisRes,
    \(x) {
      x %>%
        dplyr::select(Parameter, Unit, dplyr::all_of(progestin)) %>%
        tidyr::pivot_wider(names_from = Parameter, values_from = dplyr::all_of(progestin)) %>%
        dplyr::mutate(Value = 0.5 * (C_max_tDLast_tEnd + C_trough_tDLast)) %>%
        dplyr::select(Value, Unit) %>%
        dplyr::filter(!is.na(Value))
    }
  )

  resPD <- purrr::map(
    Cavg,
    \(x) {
      calculatePD(
        Cavg = log10(ospsuite::toUnit(quantityOrDimension = "Concentration (molar)", values = x$Value, sourceUnit = x$Unit, targetUnit = "pmol/L")),
        BL = 100,
        Imax = 1,
        Kd = Kd,
        tau = tau,
        hill = 25.462
      )
    }
  )
  return(resPD)
}

#' PD function used for Pearl index and ovulation rate
#'
#' @param Cavg Average concentration
#' @param BL Baseline value for the PD function (i.e. max reachable without progestin)
#' @param Imax Maximum inhibition
#' @param Kd Dissociation constant to use for the considered progestin.
#' @param tau Drug specific tau (transducer function) estimate as a measure of
#' intrinsic efficacy
#' @param hill Hill coefficient used for the PD function
#' @return The value of the PD function
calculatePD <- function(Cavg, BL, Imax, Kd, tau, hill) {
  # Cavg and Kd must be in log10(pmol/l)
  res <- BL * ( 1 - (Imax * tau ^ hill * Cavg ^ hill) / ((Kd + Cavg) ^ hill + (tau ^ hill * Cavg ^ hill)))
  return(res)
}
