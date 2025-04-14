# Advanced protocol are corectly printed

    Code
      add_administration(add_schema(create_advanced_protocol(name = "Test protocol"),
      schema_name = "my Schema", start_time = 2, start_time_unit = "h", rep_nb = 5,
      time_btw_rep = 10, time_btw_rep_unit = "min"), administration = create_protocol(
        name = "Test protocol", type = "ivb", interval = "single", dose = 300),
      schema_name = "my Schema")

# Protocol can be printed

    Code
      protocol
    Output
      Test Protocol
      * Application Type: Oral
      * Dosing Interval: Once each 24 hours
      * Dose: 500 mg
      * End Time: 24 h
      * Volume of water/body weight: 3.5 ml/kg

# Protocol with formulation key can be printed

    Code
      print(protocol, advanced = TRUE)
    Output
      * Application Type: Oral
      * FormulationKey: TestFormulation
      * Dose: 500 mg
      * End Time: 24 h
      * Volume of water/body weight: 3.5 ml/kg

