# create_ddi prints the correct status message

    Code
      capture_messages(suppressWarnings(ddi <- create_ddi(rifampicin, c(midazolam,
        midazolam))))
    Output
      [1] "Victim compound:\n"         "* Rifampicin\n"            
      [3] "Perpetrator compound(s):\n" "* Midazolam\n"             
      [5] "* Midazolam\n"             

