# for_single_sim

    Code
      my_ddi$get_pk_analysis()
    Output
      $`Generic DDI simulation`
      # A tibble: 25 x 4
         QuantityPath                        Parameter `Levonorgestrel 1` Itraconazole
         <chr>                               <chr>     <chr>              <chr>       
       1 Organism|PeripheralVenousBlood|Pla~ C_max [µ~ 4.41e-05           0.0597      
       2 Organism|PeripheralVenousBlood|Pla~ C_max_no~ 250                1.15e+03    
       3 Organism|PeripheralVenousBlood|Pla~ C_max_tD~ 3.41e-05           0.0255      
       4 Organism|PeripheralVenousBlood|Pla~ C_max_tD~ 4.26e+03           1.08e+04    
       5 Organism|PeripheralVenousBlood|Pla~ C_max_tD~ 4.41e-05           0.0597      
       6 Organism|PeripheralVenousBlood|Pla~ C_max_tD~ 5.51e+03           2.53e+04    
       7 Organism|PeripheralVenousBlood|Pla~ t_max [h] 505                508         
       8 Organism|PeripheralVenousBlood|Pla~ t_max_tD~ 1.25               4.5         
       9 Organism|PeripheralVenousBlood|Pla~ t_max_tD~ 505                508         
      10 Organism|PeripheralVenousBlood|Pla~ C_tEnd [~ 5.04e-06           0.02        
      # i 15 more rows
      

---

    Code
      pretty_pk(my_ddi, molecule_name = "Levonorgestrel 1", pk_parameter = c("C_max",
        "C_tEnd"))
    Message
      
      -- Generic DDI simulation ------------------------------------------------------
      
      -- Levonorgestrel 1 --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
      * C_max: 4.41e-05 µmol/l
      * C_tEnd: 5.04e-06 µmol/l

---

    Code
      compare_pk(my_ddi)
    Message
      
      -- IndividualId --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
    Output
                                       Parameter Generic DDI simulation
                                  C_max [µmol/l]                      0
                               C_max_norm [mg/l]                      0
                          C_max_tD1_tD2 [µmol/l]                      0
                       C_max_tD1_tD2_norm [mg/l]                      0
                      C_max_tDLast_tEnd [µmol/l]                      0
                   C_max_tDLast_tEnd_norm [mg/l]                      0
                                       t_max [h]                      0
                               t_max_tD1_tD2 [h]                      0
                           t_max_tDLast_tEnd [h]                      0
                                 C_tEnd [µmol/l]                      0
                           C_trough_tD2 [µmol/l]                      0
                        C_trough_tDLast [µmol/l]                      0
                           AUC_tEnd [µmol*min/l]                      0
                        AUC_tEnd_norm [µg*min/l]                      0
                        AUC_tD1_tD2 [µmol*min/l]                      0
                     AUC_tD1_tD2_norm [µg*min/l]                      0
          AUC_tDLast_minus_1_tDLast [µmol*min/l]                      0
       AUC_tDLast_minus_1_tDLast_norm [µg*min/l]                      0
                        AUC_inf_tD1 [µmol*min/l]                      0
                     AUC_inf_tD1_norm [µg*min/l]                      0
                     AUC_inf_tDLast [µmol*min/l]                      0
                  AUC_inf_tDLast_norm [µg*min/l]                      0
                                         MRT [h]                      0
                                       Thalf [h]                      0
                           Thalf_tDLast_tEnd [h]                      0
    Message
      
      -- Levonorgestrel 1 --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
    Output
                                       Parameter Generic DDI simulation
                                  C_max [µmol/l]               4.41e-05
                               C_max_norm [mg/l]                    250
                          C_max_tD1_tD2 [µmol/l]               3.41e-05
                       C_max_tD1_tD2_norm [mg/l]               4.26e+03
                      C_max_tDLast_tEnd [µmol/l]               4.41e-05
                   C_max_tDLast_tEnd_norm [mg/l]               5.51e+03
                                       t_max [h]                    505
                               t_max_tD1_tD2 [h]                   1.25
                           t_max_tDLast_tEnd [h]                    505
                                 C_tEnd [µmol/l]               5.04e-06
                           C_trough_tD2 [µmol/l]               4.56e-06
                        C_trough_tDLast [µmol/l]               9.87e-06
                           AUC_tEnd [µmol*min/l]                   0.54
                        AUC_tEnd_norm [µg*min/l]               3.07e+09
                        AUC_tD1_tD2 [µmol*min/l]                 0.0144
                     AUC_tD1_tD2_norm [µg*min/l]                1.8e+09
          AUC_tDLast_minus_1_tDLast [µmol*min/l]                 0.0252
       AUC_tDLast_minus_1_tDLast_norm [µg*min/l]               3.15e+09
                        AUC_inf_tD1 [µmol*min/l]                 0.0225
                     AUC_inf_tD1_norm [µg*min/l]               2.81e+09
                     AUC_inf_tDLast [µmol*min/l]                 0.0465
                  AUC_inf_tDLast_norm [µg*min/l]               5.81e+09
                                         MRT [h]                   24.9
                                       Thalf [h]                   20.6
                           Thalf_tDLast_tEnd [h]                   25.3
    Message
      
      -- Itraconazole --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
    Output
                                       Parameter Generic DDI simulation
                                  C_max [µmol/l]                 0.0597
                               C_max_norm [mg/l]               1.15e+03
                          C_max_tD1_tD2 [µmol/l]                 0.0255
                       C_max_tD1_tD2_norm [mg/l]               1.08e+04
                      C_max_tDLast_tEnd [µmol/l]                 0.0597
                   C_max_tDLast_tEnd_norm [mg/l]               2.53e+04
                                       t_max [h]                    508
                               t_max_tD1_tD2 [h]                    4.5
                           t_max_tDLast_tEnd [h]                    508
                                 C_tEnd [µmol/l]                   0.02
                           C_trough_tD2 [µmol/l]                 0.0159
                        C_trough_tDLast [µmol/l]                 0.0364
                           AUC_tEnd [µmol*min/l]               1.46e+03
                        AUC_tEnd_norm [µg*min/l]               2.81e+10
                        AUC_tD1_tD2 [µmol*min/l]                   29.4
                     AUC_tD1_tD2_norm [µg*min/l]               1.24e+10
          AUC_tDLast_minus_1_tDLast [µmol*min/l]                   69.7
       AUC_tDLast_minus_1_tDLast_norm [µg*min/l]               2.95e+10
                        AUC_inf_tD1 [µmol*min/l]                   60.8
                     AUC_inf_tD1_norm [µg*min/l]               2.58e+10
                     AUC_inf_tDLast [µmol*min/l]                    161
                  AUC_inf_tDLast_norm [µg*min/l]               6.83e+10
                                         MRT [h]                   35.2
                                       Thalf [h]                   22.9
                           Thalf_tDLast_tEnd [h]                   30.3

# for pop simulation

    Code
      lng$get_pk_analysis(aggregation = "median", digits = 5)
    Message
      i DDI simulations results were not found. Running them.
      i Running simulations from 1 snapshot
      v Simulations completed
      
    Output
      $`Bayer Study 19604 - control Day 1`
      # A tibble: 56 x 9
         QuantityPath          Parameter Levonorgestrel 1-ALB~1 Levonorgestrel 1-CYP~2
         <chr>                 <chr>     <chr>                  <chr>                 
       1 Organism|Total fract~ "AUC_inf~ 15.337 (14.093 – 20.5~ 0 (0 – 0)             
       2 Organism|Total fract~ "AUC_inf~ NA (NA – NA)           NA (NA – NA)          
       3 Organism|Total fract~ "AUC_tEn~ 13.334 (11.666 – 16.1~ 1849.9 (1674.8 – 1985~
       4 Organism|Total fract~ "AUC_tEn~ NA (NA – NA)           NA (NA – NA)          
       5 Organism|Total fract~ "CL [ml/~ 0 (0 – 0)              NA (NA – NA)          
       6 Organism|Total fract~ "C_max [~ 0.033258 (0.032697 – ~ 0.52511 (0.49419 – 0.~
       7 Organism|Total fract~ "C_max_n~ NA (NA – NA)           NA (NA – NA)          
       8 Organism|Total fract~ "C_tEnd ~ 0.0008211 (0.00080927~ 0.52511 (0.49419 – 0.~
       9 Organism|Total fract~ "Fractio~ 0.22199 (0.17629 – 0.~ NA (NA – NA)          
      10 Organism|Total fract~ "MRT [h]" 45.1 (38.296 – 48.671) NA (NA – NA)          
      # i 46 more rows
      # i abbreviated names: 1: `Levonorgestrel 1-ALB-Bayer report Complex`,
      #   2: `Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite`
      # i 5 more variables:
      #   `Levonorgestrel 1-SHBG-Qi-Gui & Humpel 1990 Complex` <chr>, ALB <chr>,
      #   ATP1A2 <chr>, SHBG <chr>, `Levonorgestrel 1` <chr>
      
      $`LNG 0.09 mg IV - Bayer Study A229`
      # A tibble: 28 x 4
         QuantityPath              Parameter Levonorgestrel 1-CYP~1 `Levonorgestrel 1`
         <chr>                     <chr>     <chr>                  <chr>             
       1 Organism|Liver|Intracell~ "AUC_inf~ 0 (0 – 0)              ""                
       2 Organism|Liver|Intracell~ "AUC_inf~ NA (NA – NA)           ""                
       3 Organism|Liver|Intracell~ "AUC_tEn~ 1561.8 (1532.6 – 1634~ ""                
       4 Organism|Liver|Intracell~ "AUC_tEn~ NA (NA – NA)           ""                
       5 Organism|Liver|Intracell~ "CL [ml/~ NA (NA – NA)           ""                
       6 Organism|Liver|Intracell~ "C_max [~ 0.49562 (0.49061 – 0.~ ""                
       7 Organism|Liver|Intracell~ "C_max_n~ NA (NA – NA)           ""                
       8 Organism|Liver|Intracell~ "C_tEnd ~ 0.49562 (0.49061 – 0.~ ""                
       9 Organism|Liver|Intracell~ "Fractio~ NA (NA – NA)           ""                
      10 Organism|Liver|Intracell~ "MRT [h]" NA (NA – NA)           ""                
      # i 18 more rows
      # i abbreviated name:
      #   1: `Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite`
      

---

    Code
      pretty_pk(lng, molecule_name = "Levonorgestrel 1", pk_parameter = c("AUC_tEnd",
        "C_tEnd"))
    Message
      
      -- LNG 0.09 mg IV - Bayer Study A229 -------------------------------------------
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_tEnd: 4.42 +/- 0.614 µmol*min/l
      * C_tEnd: 0.000268 +/- 9.23e-05 µmol/l
      
      -- Bayer Study 19604 - control Day 1 -------------------------------------------
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
      * AUC_tEnd: 0.00412 +/- 0.00158 µmol*min/l
      * C_tEnd: 3.5e-07 +/- 1.8e-07 µmol/l
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_tEnd: 1 +/- 0.477 µmol*min/l
      * C_tEnd: 8.59e-05 +/- 5.3e-05 µmol/l

---

    Code
      compare_pk(lng)
    Message
      
      -- IndividualId --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           1 +/- 1
        AUC_inf_norm [µg*min/l]                           1 +/- 1
          AUC_tEnd [µmol*min/l]                           1 +/- 1
       AUC_tEnd_norm [µg*min/l]                           1 +/- 1
                 CL [ml/min/kg]                           1 +/- 1
                 C_max [µmol/l]                           1 +/- 1
              C_max_norm [mg/l]                           1 +/- 1
                C_tEnd [µmol/l]                           1 +/- 1
          FractionAucLastToInf                            1 +/- 1
                        MRT [h]                           1 +/- 1
                      Thalf [h]                           1 +/- 1
                     Vd [ml/kg]                           1 +/- 1
                    Vss [ml/kg]                           1 +/- 1
                      t_max [h]                           1 +/- 1
    Message
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           1 +/- 1
        AUC_inf_norm [µg*min/l]                           1 +/- 1
          AUC_tEnd [µmol*min/l]                           1 +/- 1
       AUC_tEnd_norm [µg*min/l]                           1 +/- 1
                 CL [ml/min/kg]                           1 +/- 1
                 C_max [µmol/l]                           1 +/- 1
              C_max_norm [mg/l]                           1 +/- 1
                C_tEnd [µmol/l]                           1 +/- 1
          FractionAucLastToInf                            1 +/- 1
                        MRT [h]                           1 +/- 1
                      Thalf [h]                           1 +/- 1
                     Vd [ml/kg]                           1 +/- 1
                    Vss [ml/kg]                           1 +/- 1
                      t_max [h]                           1 +/- 1
    Message
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           1 +/- 1
        AUC_inf_norm [µg*min/l]                           1 +/- 1
          AUC_tEnd [µmol*min/l]                           1 +/- 1
       AUC_tEnd_norm [µg*min/l]                           1 +/- 1
                 CL [ml/min/kg]                           1 +/- 1
                 C_max [µmol/l]                           1 +/- 1
              C_max_norm [mg/l]                           1 +/- 1
                C_tEnd [µmol/l]                           1 +/- 1
          FractionAucLastToInf                            1 +/- 1
                        MRT [h]                           1 +/- 1
                      Thalf [h]                           1 +/- 1
                     Vd [ml/kg]                           1 +/- 1
                    Vss [ml/kg]                           1 +/- 1
                      t_max [h]                           1 +/- 1
    Message
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           1 +/- 1
        AUC_inf_norm [µg*min/l]                           1 +/- 1
          AUC_tEnd [µmol*min/l]                           1 +/- 1
       AUC_tEnd_norm [µg*min/l]                           1 +/- 1
                 CL [ml/min/kg]                           1 +/- 1
                 C_max [µmol/l]                           1 +/- 1
              C_max_norm [mg/l]                           1 +/- 1
                C_tEnd [µmol/l]                           1 +/- 1
          FractionAucLastToInf                            1 +/- 1
                        MRT [h]                           1 +/- 1
                      Thalf [h]                           1 +/- 1
                     Vd [ml/kg]                           1 +/- 1
                    Vss [ml/kg]                           1 +/- 1
                      t_max [h]                           1 +/- 1
       LNG 0.09 mg IV - Bayer Study A229
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
                                 1 +/- 1
    Message
      
      -- Organism|Liver|Intracellular|Fraction of dose-Levonorgestrel 1-Liver-Intracellular 
    Output
                      Parameter LNG 0.09 mg IV - Bayer Study A229
           AUC_inf [µmol*min/l]                           1 +/- 1
        AUC_inf_norm [µg*min/l]                           1 +/- 1
          AUC_tEnd [µmol*min/l]                           1 +/- 1
       AUC_tEnd_norm [µg*min/l]                           1 +/- 1
                 CL [ml/min/kg]                           1 +/- 1
                 C_max [µmol/l]                           1 +/- 1
              C_max_norm [mg/l]                           1 +/- 1
                C_tEnd [µmol/l]                           1 +/- 1
          FractionAucLastToInf                            1 +/- 1
                        MRT [h]                           1 +/- 1
                      Thalf [h]                           1 +/- 1
                     Vd [ml/kg]                           1 +/- 1
                    Vss [ml/kg]                           1 +/- 1
                      t_max [h]                           1 +/- 1
    Message
      
      -- Levonorgestrel 1-ALB-Bayer report Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                       18 +/- 6.86
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                     14.1 +/- 4.58
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                           0 +/- 0
                 C_max [µmol/l]                0.0377 +/- 0.00861
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]              0.00114 +/- 0.000572
          FractionAucLastToInf                   0.205 +/- 0.0671
                        MRT [h]                     42.9 +/- 10.5
                      Thalf [h]                     37.5 +/- 7.49
                     Vd [ml/kg]                           0 +/- 0
                    Vss [ml/kg]                           0 +/- 0
                      t_max [h]                    1.13 +/- 0.115
    Message
      
      -- Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           0 +/- 0
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                  1.82e+03 +/- 312
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                         NA +/- NA
                 C_max [µmol/l]                  0.528 +/- 0.0664
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]                  0.528 +/- 0.0664
          FractionAucLastToInf                          NA +/- NA
                        MRT [h]                         NA +/- NA
                      Thalf [h]                     -232 +/- 73.2
                     Vd [ml/kg]                         NA +/- NA
                    Vss [ml/kg]                         NA +/- NA
                      t_max [h]                          72 +/- 0
    Message
      
      -- Organism|Liver|Intracellular|Fraction of dose-Levonorgestrel 1-Liver-Intracellular 
    Output
                      Parameter LNG 0.09 mg IV - Bayer Study A229
           AUC_inf [µmol*min/l]                           0 +/- 0
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                  1.59e+03 +/- 105
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                         NA +/- NA
                 C_max [µmol/l]                  0.497 +/- 0.0118
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]                  0.497 +/- 0.0118
          FractionAucLastToInf                          NA +/- NA
                        MRT [h]                         NA +/- NA
                      Thalf [h]                     -223 +/- 83.4
                     Vd [ml/kg]                         NA +/- NA
                    Vss [ml/kg]                         NA +/- NA
                      t_max [h]                          72 +/- 0
    Message
      
      -- Levonorgestrel 1-SHBG-Qi-Gui & Humpel 1990 Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                     19.3 +/- 11.2
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                       15 +/- 7.76
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                           0 +/- 0
                 C_max [µmol/l]                  0.0377 +/- 0.016
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]              0.00125 +/- 0.000871
          FractionAucLastToInf                   0.206 +/- 0.0676
                        MRT [h]                     43.3 +/- 10.6
                      Thalf [h]                      37.5 +/- 7.5
                     Vd [ml/kg]                           0 +/- 0
                    Vss [ml/kg]                           0 +/- 0
                      t_max [h]                    1.27 +/- 0.115
    Message
      
      -- ALB --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                         NA +/- NA
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                  3.02e+06 +/- 0.3
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                           0 +/- 0
                 C_max [µmol/l]                         700 +/- 0
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]                  700 +/- 3.46e-05
          FractionAucLastToInf                          NA +/- NA
                        MRT [h]                         NA +/- NA
                      Thalf [h]                         NA +/- NA
                     Vd [ml/kg]                         NA +/- NA
                    Vss [ml/kg]                         NA +/- NA
                      t_max [h]                           0 +/- 0
    Message
      
      -- ATP1A2 --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                         NA +/- NA
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                           0 +/- 0
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                         NA +/- NA
                 C_max [µmol/l]                           0 +/- 0
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]                           0 +/- 0
          FractionAucLastToInf                          NA +/- NA
                        MRT [h]                         NA +/- NA
                      Thalf [h]                         NA +/- NA
                     Vd [ml/kg]                         NA +/- NA
                    Vss [ml/kg]                         NA +/- NA
                      t_max [h]                           0 +/- 0
    Message
      
      -- SHBG --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                           0 +/- 0
        AUC_inf_norm [µg*min/l]                         NA +/- NA
          AUC_tEnd [µmol*min/l]                      259 +/- 50.3
       AUC_tEnd_norm [µg*min/l]                         NA +/- NA
                 CL [ml/min/kg]                         NA +/- NA
                 C_max [µmol/l]                 0.0601 +/- 0.0117
              C_max_norm [mg/l]                         NA +/- NA
                C_tEnd [µmol/l]                 0.0601 +/- 0.0117
          FractionAucLastToInf                          NA +/- NA
                        MRT [h]                         NA +/- NA
                      Thalf [h]            -6.12e+04 +/- 2.55e+04
                     Vd [ml/kg]                         NA +/- NA
                    Vss [ml/kg]                         NA +/- NA
                      t_max [h]                           0 +/- 0
    Message
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                0.0053 +/- 0.00228
        AUC_inf_norm [µg*min/l]             4.03e+09 +/- 1.73e+09
          AUC_tEnd [µmol*min/l]               0.00412 +/- 0.00158
       AUC_tEnd_norm [µg*min/l]              3.13e+09 +/- 1.2e+09
                 CL [ml/min/kg]                       278 +/- 109
                 C_max [µmol/l]             9.22e-06 +/- 3.53e-06
              C_max_norm [mg/l]             7.01e+03 +/- 2.68e+03
                C_tEnd [µmol/l]               3.5e-07 +/- 1.8e-07
          FractionAucLastToInf                   0.215 +/- 0.0679
                        MRT [h]                       45 +/- 10.5
                      Thalf [h]                     37.5 +/- 7.49
                     Vd [ml/kg]             8.92e+05 +/- 3.88e+05
                    Vss [ml/kg]             7.41e+05 +/- 3.32e+05
                      t_max [h]                    1.27 +/- 0.115
    Message
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                    1.29 +/- 0.685
        AUC_inf_norm [µg*min/l]             9.84e+11 +/- 5.21e+11
          AUC_tEnd [µmol*min/l]                       1 +/- 0.477
       AUC_tEnd_norm [µg*min/l]             7.62e+11 +/- 3.63e+11
                 CL [ml/min/kg]                    1.21 +/- 0.565
                 C_max [µmol/l]               0.00222 +/- 0.00107
              C_max_norm [mg/l]             1.69e+06 +/- 8.11e+05
                C_tEnd [µmol/l]              8.59e-05 +/- 5.3e-05
          FractionAucLastToInf                    0.215 +/- 0.068
                        MRT [h]                     45.1 +/- 10.5
                      Thalf [h]                      37.5 +/- 7.5
                     Vd [ml/kg]                3.87e+03 +/- 2e+03
                    Vss [ml/kg]              3.21e+03 +/- 1.7e+03
                      t_max [h]                    1.27 +/- 0.115
       LNG 0.09 mg IV - Bayer Study A229
                          5.09 +/- 0.629
                   1.06e+12 +/- 1.31e+11
                          4.42 +/- 0.614
                    9.2e+11 +/- 1.28e+11
                         0.953 +/- 0.116
                      0.0262 +/- 0.00338
                   5.46e+06 +/- 7.04e+05
                   0.000268 +/- 9.23e-05
                        0.131 +/- 0.0748
                           32.6 +/- 11.1
                           27.4 +/- 7.43
                        2.25e+03 +/- 612
                        1.85e+03 +/- 631
                              0.08 +/- 0

---

    Code
      compare_pk(lng, reference_simulation = "Bayer Study 19604 - control Day 1")
    Message
      
      -- Reference simulation: Bayer Study 19604 - control Day 1 ---------------------
      
      -- IndividualId --
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                            Parameter LNG 0.09 mg IV - Bayer Study A229
           AUC_inf_ratio [µmol*min/l]                                 1
        AUC_inf_norm_ratio [µg*min/l]                                 1
          AUC_tEnd_ratio [µmol*min/l]                                 1
       AUC_tEnd_norm_ratio [µg*min/l]                                 1
                 CL_ratio [ml/min/kg]                                 1
                 C_max_ratio [µmol/l]                                 1
              C_max_norm_ratio [mg/l]                                 1
                C_tEnd_ratio [µmol/l]                                 1
          FractionAucLastToInf_ratio                                  1
                        MRT_ratio [h]                                 1
                      Thalf_ratio [h]                                 1
                     Vd_ratio [ml/kg]                                 1
                    Vss_ratio [ml/kg]                                 1
                      t_max_ratio [h]                                 1
    Message
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                            Parameter LNG 0.09 mg IV - Bayer Study A229
           AUC_inf_ratio [µmol*min/l]                              3.93
        AUC_inf_norm_ratio [µg*min/l]                              1.08
          AUC_tEnd_ratio [µmol*min/l]                              4.41
       AUC_tEnd_norm_ratio [µg*min/l]                              1.21
                 CL_ratio [ml/min/kg]                             0.788
                 C_max_ratio [µmol/l]                              11.8
              C_max_norm_ratio [mg/l]                              3.23
                C_tEnd_ratio [µmol/l]                              3.12
          FractionAucLastToInf_ratio                              0.609
                        MRT_ratio [h]                             0.723
                      Thalf_ratio [h]                             0.732
                     Vd_ratio [ml/kg]                             0.582
                    Vss_ratio [ml/kg]                             0.576
                      t_max_ratio [h]                            0.0632

