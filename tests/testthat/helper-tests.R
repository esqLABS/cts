try(
  {
    # Snapshots
    rifampicin_snap <- Snapshot$new(test_path("data/Rifampicin-Model.json"))

    # Compounds
    rifampicin <- compound(test_path("data/Rifampicin-Model.json"))
    midazolam <- compound(test_path("data/Midazolam-Model.json"))
    levonorgestrel <- compound(test_path("data/Levonorgestrel-Model.json"))
    itraconazole <- compound(test_path("data/Itraconazole-Model.json"))
    itraconazole80 <- compound(test_path("data/Itraconazole-Model-80.json"))

    # DDI
    ## imported
    levo_itra_ddi <- import_ddi(test_path(
      "data/Levonorgestrel-Itraconazole-DDI.json"
    ))
  },
  silent = TRUE
)


get_test_ddi <- function() {
  if (is.null(the$.test_ddi)) {
    the$.test_ddi <- suppressWarnings(create_ddi(levonorgestrel, itraconazole))
    the$.test_ddi_results <- run_ddi(the$.test_ddi)
  }

  return(the$.test_ddi$clone())
}

get_test_ddi_results <- function() {
  if (is.null(the$.test_ddi_results)){
    get_test_ddi()
  }

  return(the$.test_ddi_results)
}
