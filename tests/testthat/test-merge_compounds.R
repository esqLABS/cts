test_that("Merge compounds works", {
  rifampicin <- compound("Rifampicin")
  midazolam <- compound("Midazolam")

  merge_compounds(rifampicin, midazolam)
})
