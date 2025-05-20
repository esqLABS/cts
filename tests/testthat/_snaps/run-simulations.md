# ddi generic simulation can be run

    Code
      dplyr::glimpse(get_test_ddi_results()[[1]])
    Output
      Rows: 13,254
      Columns: 9
      $ IndividualId     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
      $ Time             <dbl> 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 15, 15, 30, 30, 30,~
      $ paths            <chr> "Organism|PeripheralVenousBlood|Levonorgestrel 1|Plas~
      $ simulationValues <dbl> 0.000000e+00, 0.000000e+00, 0.000000e+00, 0.000000e+0~
      $ TimeDimension    <chr> "Time", "Time", "Time", "Time", "Time", "Time", "Time~
      $ TimeUnit         <chr> "min", "min", "min", "min", "min", "min", "min", "min~
      $ dimension        <chr> "Concentration (molar)", "Concentration (molar)", "Co~
      $ unit             <chr> "µmol/l", "µmol/l", "µmol/l", "µmol/l", "", "", "µmol~
      $ molWeight        <dbl> 312.440, 705.633, 312.440, 705.633, 312.440, 705.633,~

# Run added simulations works

    Code
      dplyr::glimpse(results[[1]])
    Output
      Rows: 291
      Columns: 9
      $ IndividualId     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
      $ Time             <dbl> 0, 0, 0, 15, 15, 15, 30, 30, 30, 45, 45, 45, 60, 60, ~
      $ paths            <chr> "Organism|PeripheralVenousBlood|Levonorgestrel 1|Plas~
      $ simulationValues <dbl> 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.100364e-0~
      $ TimeDimension    <chr> "Time", "Time", "Time", "Time", "Time", "Time", "Time~
      $ TimeUnit         <chr> "min", "min", "min", "min", "min", "min", "min", "min~
      $ dimension        <chr> "Concentration (molar)", "Concentration (molar)", "Fr~
      $ unit             <chr> "µmol/l", "µmol/l", "", "µmol/l", "µmol/l", "", "µmol~
      $ molWeight        <dbl> 312.44, 312.44, 312.44, 312.44, 312.44, 312.44, 312.4~

---

    Code
      dplyr::glimpse(results[[2]])
    Output
      Rows: 582
      Columns: 9
      $ IndividualId     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
      $ Time             <dbl> 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 15, 15, 30, 30, 30,~
      $ paths            <chr> "Organism|PeripheralVenousBlood|Levonorgestrel 1|Plas~
      $ simulationValues <dbl> 0.000000e+00, 0.000000e+00, 0.000000e+00, 0.000000e+0~
      $ TimeDimension    <chr> "Time", "Time", "Time", "Time", "Time", "Time", "Time~
      $ TimeUnit         <chr> "min", "min", "min", "min", "min", "min", "min", "min~
      $ dimension        <chr> "Concentration (molar)", "Concentration (molar)", "Co~
      $ unit             <chr> "µmol/l", "µmol/l", "µmol/l", "µmol/l", "", "", "µmol~
      $ molWeight        <dbl> 312.440, 705.633, 312.440, 705.633, 312.440, 705.633,~

