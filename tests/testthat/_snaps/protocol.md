# Advanced protocol are corectly printed

    Code
      add_administration(add_schema(create_advanced_protocol(name = "Test protocol"),
      schema_name = "my Schema", start_time = 2, start_time_unit = "h", rep_nb = 5,
      time_btw_rep = 10, time_btw_rep_unit = "min"), administration = create_protocol(
        name = "Test protocol", type = "ivb", interval = "single", dose = 300),
      schema_name = "my Schema")

