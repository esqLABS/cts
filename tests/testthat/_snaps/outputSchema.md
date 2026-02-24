# OutputSchema print method works.

    Code
      SnapshotOutputSchema$new()
    Output
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h

# `set_interval` can clear and add intervals to the schema.

    Code
      output_schema
    Output
      Output schema:
      * Interval 1
        * Start time: 0 month(s)
        * End time: 6 month(s)
        * Resolution: 30 pts/month(s)

# `add_interval` works

    Code
      output_schema
    Output
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      * Interval 2
        * Start time: 0 min
        * End time: 70 min
        * Resolution: 2 pts/min

