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
      * Levonorgestrel 1
      Perpetrator compounds:
      * Itraconazole
      * Hydroxy-Itraconazole
      * Keto-Itraconazole
      * N-desalkyl-Itraconazole

