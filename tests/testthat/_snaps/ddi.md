# create_ddi prints the correct status message

    Code
      capture_messages(suppressWarnings(ddi <- create_ddi(rifampicin, c(midazolam,
        midazolam))))
    Output
      character(0)

# print ddi object works

    Code
      levo_itra_ddi
    Message
      DDI simulation created with the following compounds:
      Victim compound:
      * Itraconazole
      Perpetrator compounds:
      * Hydroxy-Itraconazole
      * Keto-Itraconazole
      * N-desalkyl-Itraconazole
      * Levonorgestrel 1

