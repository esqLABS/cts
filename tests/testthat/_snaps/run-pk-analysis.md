# run pk analysis works

    Code
      run_pk_analysis(my_ddi)
    Output
      $`Generic DDI simulation`
      # A tibble: 39 x 5
         IndividualId QuantityPath                            Parameter    Value Unit 
                <int> <chr>                                   <chr>        <dbl> <chr>
       1            0 Organism|PeripheralVenousBlood|Levonor~ C_max     6.16e- 5 µmol~
       2            0 Organism|PeripheralVenousBlood|Levonor~ C_max_no~ 4.28e+ 3 mg/l 
       3            0 Organism|PeripheralVenousBlood|Levonor~ t_max     1.25e+ 0 h    
       4            0 Organism|PeripheralVenousBlood|Levonor~ C_tEnd    1.61e-11 µmol~
       5            0 Organism|PeripheralVenousBlood|Levonor~ AUC_tEnd  4.42e- 2 µmol~
       6            0 Organism|PeripheralVenousBlood|Levonor~ AUC_tEnd~ 3.07e+ 9 µg*m~
       7            0 Organism|PeripheralVenousBlood|Levonor~ AUC_inf   4.42e- 2 µmol~
       8            0 Organism|PeripheralVenousBlood|Levonor~ AUC_inf_~ 3.07e+ 9 µg*m~
       9            0 Organism|PeripheralVenousBlood|Levonor~ MRT       3.06e+ 1 h    
      10            0 Organism|PeripheralVenousBlood|Levonor~ Thalf     2.59e+ 1 h    
      # i 29 more rows
      

