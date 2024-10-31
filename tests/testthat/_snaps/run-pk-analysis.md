# run_pk_analysis works

    Code
      run_pk_analysis(my_ddi)
    Output
      $`Generic DDI simulation`
      # A tibble: 31 x 5
         QuantityPath                  Parameter Unit  `Levonorgestrel 1` Itraconazole
         <chr>                         <chr>     <chr>              <dbl>        <dbl>
       1 Organism|PeripheralVenousBlo~ C_max     µmol~           6.16e- 5     6.88e- 2
       2 Organism|PeripheralVenousBlo~ C_max_no~ mg/l            4.28e+ 3     5.02e+ 2
       3 Organism|PeripheralVenousBlo~ t_max     h               1.25e+ 0     5.08e+ 2
       4 Organism|PeripheralVenousBlo~ C_tEnd    µmol~           1.61e-11     4.22e- 2
       5 Organism|PeripheralVenousBlo~ AUC_tEnd  µmol~           4.42e- 2     1.64e+ 3
       6 Organism|PeripheralVenousBlo~ AUC_tEnd~ µg*m~           3.07e+ 9     1.20e+10
       7 Organism|PeripheralVenousBlo~ AUC_inf   µmol~           4.42e- 2    NA       
       8 Organism|PeripheralVenousBlo~ AUC_inf_~ µg*m~           3.07e+ 9    NA       
       9 Organism|PeripheralVenousBlo~ MRT       h               3.06e+ 1     3.51e+ 1
      10 Organism|PeripheralVenousBlo~ Thalf     h               2.59e+ 1     2.27e+ 1
      # i 21 more rows
      

---

    Code
      my_ddi$pk_analysis_raw
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
      

