# for_single_sim

    Code
      suppressWarnings(my_ddi$get_pk_analysis())
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
      suppressWarnings(pretty_pk(my_ddi))
    Message
      
      -- Generic DDI simulation ------------------------------------------------------
      
      -- IndividualId --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
      * C_max: 0 µmol/l
      * C_max_norm: 0 mg/l
      * C_max_tD1_tD2: 0 µmol/l
      * C_max_tD1_tD2_norm: 0 mg/l
      * C_max_tDLast_tEnd: 0 µmol/l
      * C_max_tDLast_tEnd_norm: 0 mg/l
      * t_max: 0 h
      * t_max_tD1_tD2: 0 h
      * t_max_tDLast_tEnd: 0 h
      * C_tEnd: 0 µmol/l
      * C_trough_tD2: 0 µmol/l
      * C_trough_tDLast: 0 µmol/l
      * AUC_tEnd: 0 µmol*min/l
      * AUC_tEnd_norm: 0 µg*min/l
      * AUC_tD1_tD2: 0 µmol*min/l
      * AUC_tD1_tD2_norm: 0 µg*min/l
      * AUC_tDLast_minus_1_tDLast: 0 µmol*min/l
      * AUC_tDLast_minus_1_tDLast_norm: 0 µg*min/l
      * AUC_inf_tD1: 0 µmol*min/l
      * AUC_inf_tD1_norm: 0 µg*min/l
      * AUC_inf_tDLast: 0 µmol*min/l
      * AUC_inf_tDLast_norm: 0 µg*min/l
      * MRT: 0 h
      * Thalf: 0 h
      * Thalf_tDLast_tEnd: 0 h
      
      -- Levonorgestrel 1 --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
      * C_max: 4.41e-05 µmol/l
      * C_max_norm: 250 mg/l
      * C_max_tD1_tD2: 3.41e-05 µmol/l
      * C_max_tD1_tD2_norm: 4.26e+03 mg/l
      * C_max_tDLast_tEnd: 4.41e-05 µmol/l
      * C_max_tDLast_tEnd_norm: 5.51e+03 mg/l
      * t_max: 505 h
      * t_max_tD1_tD2: 1.25 h
      * t_max_tDLast_tEnd: 505 h
      * C_tEnd: 5.04e-06 µmol/l
      * C_trough_tD2: 4.56e-06 µmol/l
      * C_trough_tDLast: 9.87e-06 µmol/l
      * AUC_tEnd: 0.54 µmol*min/l
      * AUC_tEnd_norm: 3.07e+09 µg*min/l
      * AUC_tD1_tD2: 0.0144 µmol*min/l
      * AUC_tD1_tD2_norm: 1.8e+09 µg*min/l
      * AUC_tDLast_minus_1_tDLast: 0.0252 µmol*min/l
      * AUC_tDLast_minus_1_tDLast_norm: 3.15e+09 µg*min/l
      * AUC_inf_tD1: 0.0225 µmol*min/l
      * AUC_inf_tD1_norm: 2.81e+09 µg*min/l
      * AUC_inf_tDLast: 0.0465 µmol*min/l
      * AUC_inf_tDLast_norm: 5.81e+09 µg*min/l
      * MRT: 24.9 h
      * Thalf: 20.6 h
      * Thalf_tDLast_tEnd: 25.3 h
      
      -- Itraconazole --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
      * C_max: 0.0597 µmol/l
      * C_max_norm: 1.15e+03 mg/l
      * C_max_tD1_tD2: 0.0255 µmol/l
      * C_max_tD1_tD2_norm: 1.08e+04 mg/l
      * C_max_tDLast_tEnd: 0.0597 µmol/l
      * C_max_tDLast_tEnd_norm: 2.53e+04 mg/l
      * t_max: 508 h
      * t_max_tD1_tD2: 4.5 h
      * t_max_tDLast_tEnd: 508 h
      * C_tEnd: 0.02 µmol/l
      * C_trough_tD2: 0.0159 µmol/l
      * C_trough_tDLast: 0.0364 µmol/l
      * AUC_tEnd: 1.46e+03 µmol*min/l
      * AUC_tEnd_norm: 2.81e+10 µg*min/l
      * AUC_tD1_tD2: 29.4 µmol*min/l
      * AUC_tD1_tD2_norm: 1.24e+10 µg*min/l
      * AUC_tDLast_minus_1_tDLast: 69.7 µmol*min/l
      * AUC_tDLast_minus_1_tDLast_norm: 2.95e+10 µg*min/l
      * AUC_inf_tD1: 60.8 µmol*min/l
      * AUC_inf_tD1_norm: 2.58e+10 µg*min/l
      * AUC_inf_tDLast: 161 µmol*min/l
      * AUC_inf_tDLast_norm: 6.83e+10 µg*min/l
      * MRT: 35.2 h
      * Thalf: 22.9 h
      * Thalf_tDLast_tEnd: 30.3 h

---

    Code
      suppressWarnings(compare_pk(my_ddi, molecule_name = "Levonorgestrel 1",
        pk_parameter = c("AUC_tEnd", "C_tEnd")))
    Message
      
      -- Levonorgestrel 1 --
      
      -- Organism|PeripheralVenousBlood|Plasma (Peripheral Venous Blood) 
    Output
                   Parameter Generic DDI simulation
             C_tEnd [µmol/l]               5.04e-06
       AUC_tEnd [µmol*min/l]                   0.54

---

    Code
      suppressWarnings(compare_pk(my_ddi, aggregation = "median"))
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
      suppressWarnings(lng$get_pk_analysis(aggregation = "median", digits = 5))
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
      suppressWarnings(lng$get_pk_analysis(aggregation = "mean", digits = 5))
    Output
      $`Bayer Study 19604 - control Day 1`
      # A tibble: 56 x 9
         QuantityPath          Parameter Levonorgestrel 1-ALB~1 Levonorgestrel 1-CYP~2
         <chr>                 <chr>     <chr>                  <chr>                 
       1 Organism|Total fract~ "AUC_inf~ 17.991 +/- 6.8647      0 +/- 0               
       2 Organism|Total fract~ "AUC_inf~ NA +/- NA              NA +/- NA             
       3 Organism|Total fract~ "AUC_tEn~ 14.126 +/- 4.5769      1823.7 +/- 311.78     
       4 Organism|Total fract~ "AUC_tEn~ NA +/- NA              NA +/- NA             
       5 Organism|Total fract~ "CL [ml/~ 0 +/- 0                NA +/- NA             
       6 Organism|Total fract~ "C_max [~ 0.037658 +/- 0.0086116 0.52814 +/- 0.066435  
       7 Organism|Total fract~ "C_max_n~ NA +/- NA              NA +/- NA             
       8 Organism|Total fract~ "C_tEnd ~ 0.0011394 +/- 0.000572 0.52814 +/- 0.066435  
       9 Organism|Total fract~ "Fractio~ 0.20464 +/- 0.067082   NA +/- NA             
      10 Organism|Total fract~ "MRT [h]" 42.945 +/- 10.542      NA +/- NA             
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
       1 Organism|Liver|Intracell~ "AUC_inf~ 0 +/- 0                ""                
       2 Organism|Liver|Intracell~ "AUC_inf~ NA +/- NA              ""                
       3 Organism|Liver|Intracell~ "AUC_tEn~ 1590.7 +/- 104.82      ""                
       4 Organism|Liver|Intracell~ "AUC_tEn~ NA +/- NA              ""                
       5 Organism|Liver|Intracell~ "CL [ml/~ NA +/- NA              ""                
       6 Organism|Liver|Intracell~ "C_max [~ 0.4968 +/- 0.011828    ""                
       7 Organism|Liver|Intracell~ "C_max_n~ NA +/- NA              ""                
       8 Organism|Liver|Intracell~ "C_tEnd ~ 0.4968 +/- 0.011828    ""                
       9 Organism|Liver|Intracell~ "Fractio~ NA +/- NA              ""                
      10 Organism|Liver|Intracell~ "MRT [h]" NA +/- NA              ""                
      # i 18 more rows
      # i abbreviated name:
      #   1: `Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite`
      

---

    Code
      suppressWarnings(pretty_pk(lng, aggregation = "median"))
    Message
      
      -- LNG 0.09 mg IV - Bayer Study A229 -------------------------------------------
      
      -- IndividualId --
      
      -- Organism|Liver|Intracellular|Fraction of dose-Levonorgestrel 1-Liver-Intracellular 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite --
      
      -- Organism|Liver|Intracellular|Fraction of dose-Levonorgestrel 1-Liver-Intracellular 
      * AUC_inf: 0 (0 – 0) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 1.56e+03 (1.53e+03 – 1.63e+03) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: NA (NA – NA) ml/min/kg
      * C_max: 0.496 (0.491 – 0.502) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0.496 (0.491 – 0.502) µmol/l
      * FractionAucLastToInf: NA (NA – NA)
      * MRT: NA (NA – NA) h
      * Thalf: -217 (-263 – -180) h
      * Vd: NA (NA – NA) ml/kg
      * Vss: NA (NA – NA) ml/kg
      * t_max: 72 (72 – 72) h
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_inf: 5.01 (4.76 – 5.38) µmol*min/l
      * AUC_inf_norm: 1.04e+12 (9.91e+11 – 1.12e+12) µg*min/l
      * AUC_tEnd: 4.2 (4.07 – 4.65) µmol*min/l
      * AUC_tEnd_norm: 8.74e+11 (8.47e+11 – 9.69e+11) µg*min/l
      * CL: 0.958 (0.896 – 1.01) ml/min/kg
      * C_max: 0.0256 (0.0244 – 0.0278) µmol/l
      * C_max_norm: 5.34e+06 (5.09e+06 – 5.78e+06) mg/l
      * C_tEnd: 0.000291 (0.000229 – 0.000319) µmol/l
      * FractionAucLastToInf: 0.112 (0.0899 – 0.163)
      * MRT: 29.8 (26.4 – 37.3) h
      * Thalf: 25.6 (23.4 – 30.6) h
      * Vd: 1.95e+03 (1.9e+03 – 2.45e+03) ml/kg
      * Vss: 1.49e+03 (1.48e+03 – 2.04e+03) ml/kg
      * t_max: 0.08 (0.08 – 0.08) h
      
      -- Bayer Study 19604 - control Day 1 -------------------------------------------
      
      -- IndividualId --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_inf: 1 (0.5 – 1.5) µmol*min/l
      * AUC_inf_norm: 1 (0.5 – 1.5) µg*min/l
      * AUC_tEnd: 1 (0.5 – 1.5) µmol*min/l
      * AUC_tEnd_norm: 1 (0.5 – 1.5) µg*min/l
      * CL: 1 (0.5 – 1.5) ml/min/kg
      * C_max: 1 (0.5 – 1.5) µmol/l
      * C_max_norm: 1 (0.5 – 1.5) mg/l
      * C_tEnd: 1 (0.5 – 1.5) µmol/l
      * FractionAucLastToInf: 1 (0.5 – 1.5)
      * MRT: 1 (0.5 – 1.5) h
      * Thalf: 1 (0.5 – 1.5) h
      * Vd: 1 (0.5 – 1.5) ml/kg
      * Vss: 1 (0.5 – 1.5) ml/kg
      * t_max: 1 (0.5 – 1.5) h
      
      -- Levonorgestrel 1-ALB-Bayer report Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
      * AUC_inf: 15.3 (14.1 – 20.6) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 13.3 (11.7 – 16.2) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: 0 (0 – 0) ml/min/kg
      * C_max: 0.0333 (0.0327 – 0.0404) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0.000821 (0.000809 – 0.00131) µmol/l
      * FractionAucLastToInf: 0.222 (0.176 – 0.242)
      * MRT: 45.1 (38.3 – 48.7) h
      * Thalf: 40.1 (34.6 – 41.7) h
      * Vd: 0 (0 – 0) ml/kg
      * Vss: 0 (0 – 0) ml/kg
      * t_max: 1.2 (1.1 – 1.2) h
      
      -- Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
      * AUC_inf: 0 (0 – 0) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 1.85e+03 (1.67e+03 – 1.99e+03) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: NA (NA – NA) ml/min/kg
      * C_max: 0.525 (0.494 – 0.561) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0.525 (0.494 – 0.561) µmol/l
      * FractionAucLastToInf: NA (NA – NA)
      * MRT: NA (NA – NA) h
      * Thalf: -231 (-268 – -195) h
      * Vd: NA (NA – NA) ml/kg
      * Vss: NA (NA – NA) ml/kg
      * t_max: 72 (72 – 72) h
      
      -- Levonorgestrel 1-SHBG-Qi-Gui & Humpel 1990 Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
      * AUC_inf: 14.9 (12.9 – 23.5) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 12.9 (10.7 – 18.3) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: 0 (0 – 0) ml/min/kg
      * C_max: 0.0301 (0.0285 – 0.043) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0.000781 (0.000743 – 0.00152) µmol/l
      * FractionAucLastToInf: 0.224 (0.178 – 0.244)
      * MRT: 45.5 (38.6 – 49.1) h
      * Thalf: 40.2 (34.6 – 41.7) h
      * Vd: 0 (0 – 0) ml/kg
      * Vss: 0 (0 – 0) ml/kg
      * t_max: 1.2 (1.2 – 1.3) h
      
      -- ALB --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
      * AUC_inf: NA (NA – NA) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 3.02e+06 (3.02e+06 – 3.02e+06) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: -0 (-0 – -0) ml/min/kg
      * C_max: 700 (700 – 700) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 700 (700 – 700) µmol/l
      * FractionAucLastToInf: NA (NA – NA)
      * MRT: NA (NA – NA) h
      * Thalf: NA (NA – NA) h
      * Vd: NA (NA – NA) ml/kg
      * Vss: NA (NA – NA) ml/kg
      * t_max: 0 (0 – 0) h
      
      -- ATP1A2 --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
      * AUC_inf: NA (NA – NA) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 0 (0 – 0) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: NA (NA – NA) ml/min/kg
      * C_max: 0 (0 – 0) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0 (0 – 0) µmol/l
      * FractionAucLastToInf: NA (NA – NA)
      * MRT: NA (NA – NA) h
      * Thalf: NA (NA – NA) h
      * Vd: NA (NA – NA) ml/kg
      * Vss: NA (NA – NA) ml/kg
      * t_max: 0 (0 – 0) h
      
      -- SHBG --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
      * AUC_inf: 0 (0 – 0) µmol*min/l
      * AUC_inf_norm: NA (NA – NA) µg*min/l
      * AUC_tEnd: 246 (232 – 281) µmol*min/l
      * AUC_tEnd_norm: NA (NA – NA) µg*min/l
      * CL: NA (NA – NA) ml/min/kg
      * C_max: 0.0571 (0.0537 – 0.0651) µmol/l
      * C_max_norm: NA (NA – NA) mg/l
      * C_tEnd: 0.0571 (0.0536 – 0.065) µmol/l
      * FractionAucLastToInf: NA (NA – NA)
      * MRT: NA (NA – NA) h
      * Thalf: -5.59e+04 (-7.24e+04 – -4.74e+04) h
      * Vd: NA (NA – NA) ml/kg
      * Vss: NA (NA – NA) ml/kg
      * t_max: 0 (0 – 0) h
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
      * AUC_inf: 0.00466 (0.00404 – 0.00625) µmol*min/l
      * AUC_inf_norm: 3.54e+09 (3.07e+09 – 4.75e+09) µg*min/l
      * AUC_tEnd: 0.00401 (0.00331 – 0.00488) µmol*min/l
      * AUC_tEnd_norm: 3.05e+09 (2.51e+09 – 3.71e+09) µg*min/l
      * CL: 282 (225 – 334) ml/min/kg
      * C_max: 8.1e-06 (7.24e-06 – 1.06e-05) µmol/l
      * C_max_norm: 6.16e+03 (5.51e+03 – 8.08e+03) mg/l
      * C_tEnd: 2.56e-07 (2.46e-07 – 4.07e-07) µmol/l
      * FractionAucLastToInf: 0.24 (0.189 – 0.253)
      * MRT: 48.6 (40.9 – 50.9) h
      * Thalf: 40.1 (34.6 – 41.7) h
      * Vd: 7.1e+05 (6.69e+05 – 1.02e+06) ml/kg
      * Vss: 5.62e+05 (5.49e+05 – 8.43e+05) ml/kg
      * t_max: 1.2 (1.2 – 1.3) h
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
      * AUC_inf: 1.08 (0.911 – 1.57) µmol*min/l
      * AUC_inf_norm: 8.2e+11 (6.93e+11 – 1.19e+12) µg*min/l
      * AUC_tEnd: 0.929 (0.747 – 1.22) µmol*min/l
      * AUC_tEnd_norm: 7.06e+11 (5.68e+11 – 9.28e+11) µg*min/l
      * CL: 1.22 (0.929 – 1.49) ml/min/kg
      * C_max: 0.00186 (0.00162 – 0.00264) µmol/l
      * C_max_norm: 1.42e+06 (1.23e+06 – 2.01e+06) mg/l
      * C_tEnd: 5.93e-05 (5.54e-05 – 0.000103) µmol/l
      * FractionAucLastToInf: 0.24 (0.189 – 0.254)
      * MRT: 48.7 (40.9 – 51) h
      * Thalf: 40.2 (34.6 – 41.7) h
      * Vd: 3.07e+03 (2.73e+03 – 4.61e+03) ml/kg
      * Vss: 2.43e+03 (2.24e+03 – 3.8e+03) ml/kg
      * t_max: 1.2 (1.2 – 1.3) h

---

    Code
      suppressWarnings(pretty_pk(lng, aggregation = "mean", molecule_name = "Levonorgestrel 1",
        pk_parameter = c("AUC_tEnd", "C_tEnd")))
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
      suppressWarnings(compare_pk(lng, aggregation = "median", simulation_name = "Bayer Study 19604 - control Day 1"))
    Message
      
      -- IndividualId --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                     1 (0.5 – 1.5)
        AUC_inf_norm [µg*min/l]                     1 (0.5 – 1.5)
          AUC_tEnd [µmol*min/l]                     1 (0.5 – 1.5)
       AUC_tEnd_norm [µg*min/l]                     1 (0.5 – 1.5)
                 CL [ml/min/kg]                     1 (0.5 – 1.5)
                 C_max [µmol/l]                     1 (0.5 – 1.5)
              C_max_norm [mg/l]                     1 (0.5 – 1.5)
                C_tEnd [µmol/l]                     1 (0.5 – 1.5)
          FractionAucLastToInf                      1 (0.5 – 1.5)
                        MRT [h]                     1 (0.5 – 1.5)
                      Thalf [h]                     1 (0.5 – 1.5)
                     Vd [ml/kg]                     1 (0.5 – 1.5)
                    Vss [ml/kg]                     1 (0.5 – 1.5)
                      t_max [h]                     1 (0.5 – 1.5)
    Message
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                     1 (0.5 – 1.5)
        AUC_inf_norm [µg*min/l]                     1 (0.5 – 1.5)
          AUC_tEnd [µmol*min/l]                     1 (0.5 – 1.5)
       AUC_tEnd_norm [µg*min/l]                     1 (0.5 – 1.5)
                 CL [ml/min/kg]                     1 (0.5 – 1.5)
                 C_max [µmol/l]                     1 (0.5 – 1.5)
              C_max_norm [mg/l]                     1 (0.5 – 1.5)
                C_tEnd [µmol/l]                     1 (0.5 – 1.5)
          FractionAucLastToInf                      1 (0.5 – 1.5)
                        MRT [h]                     1 (0.5 – 1.5)
                      Thalf [h]                     1 (0.5 – 1.5)
                     Vd [ml/kg]                     1 (0.5 – 1.5)
                    Vss [ml/kg]                     1 (0.5 – 1.5)
                      t_max [h]                     1 (0.5 – 1.5)
    Message
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                     1 (0.5 – 1.5)
        AUC_inf_norm [µg*min/l]                     1 (0.5 – 1.5)
          AUC_tEnd [µmol*min/l]                     1 (0.5 – 1.5)
       AUC_tEnd_norm [µg*min/l]                     1 (0.5 – 1.5)
                 CL [ml/min/kg]                     1 (0.5 – 1.5)
                 C_max [µmol/l]                     1 (0.5 – 1.5)
              C_max_norm [mg/l]                     1 (0.5 – 1.5)
                C_tEnd [µmol/l]                     1 (0.5 – 1.5)
          FractionAucLastToInf                      1 (0.5 – 1.5)
                        MRT [h]                     1 (0.5 – 1.5)
                      Thalf [h]                     1 (0.5 – 1.5)
                     Vd [ml/kg]                     1 (0.5 – 1.5)
                    Vss [ml/kg]                     1 (0.5 – 1.5)
                      t_max [h]                     1 (0.5 – 1.5)
    Message
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                     1 (0.5 – 1.5)
        AUC_inf_norm [µg*min/l]                     1 (0.5 – 1.5)
          AUC_tEnd [µmol*min/l]                     1 (0.5 – 1.5)
       AUC_tEnd_norm [µg*min/l]                     1 (0.5 – 1.5)
                 CL [ml/min/kg]                     1 (0.5 – 1.5)
                 C_max [µmol/l]                     1 (0.5 – 1.5)
              C_max_norm [mg/l]                     1 (0.5 – 1.5)
                C_tEnd [µmol/l]                     1 (0.5 – 1.5)
          FractionAucLastToInf                      1 (0.5 – 1.5)
                        MRT [h]                     1 (0.5 – 1.5)
                      Thalf [h]                     1 (0.5 – 1.5)
                     Vd [ml/kg]                     1 (0.5 – 1.5)
                    Vss [ml/kg]                     1 (0.5 – 1.5)
                      t_max [h]                     1 (0.5 – 1.5)
    Message
      
      -- Levonorgestrel 1-ALB-Bayer report Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                15.3 (14.1 – 20.6)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]                13.3 (11.7 – 16.2)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                         0 (0 – 0)
                 C_max [µmol/l]          0.0333 (0.0327 – 0.0404)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]     0.000821 (0.000809 – 0.00131)
          FractionAucLastToInf              0.222 (0.176 – 0.242)
                        MRT [h]                45.1 (38.3 – 48.7)
                      Thalf [h]                40.1 (34.6 – 41.7)
                     Vd [ml/kg]                         0 (0 – 0)
                    Vss [ml/kg]                         0 (0 – 0)
                      t_max [h]                   1.2 (1.1 – 1.2)
    Message
      
      -- Levonorgestrel 1-CYP3A4-Parameter Identification Metabolite --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                         0 (0 – 0)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]    1.85e+03 (1.67e+03 – 1.99e+03)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                      NA (NA – NA)
                 C_max [µmol/l]             0.525 (0.494 – 0.561)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]             0.525 (0.494 – 0.561)
          FractionAucLastToInf                       NA (NA – NA)
                        MRT [h]                      NA (NA – NA)
                      Thalf [h]                -231 (-268 – -195)
                     Vd [ml/kg]                      NA (NA – NA)
                    Vss [ml/kg]                      NA (NA – NA)
                      t_max [h]                      72 (72 – 72)
    Message
      
      -- Levonorgestrel 1-SHBG-Qi-Gui & Humpel 1990 Complex --
      
      -- Organism|Total fraction of dose-Levonorgestrel 1 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                14.9 (12.9 – 23.5)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]                12.9 (10.7 – 18.3)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                         0 (0 – 0)
                 C_max [µmol/l]           0.0301 (0.0285 – 0.043)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]     0.000781 (0.000743 – 0.00152)
          FractionAucLastToInf              0.224 (0.178 – 0.244)
                        MRT [h]                45.5 (38.6 – 49.1)
                      Thalf [h]                40.2 (34.6 – 41.7)
                     Vd [ml/kg]                         0 (0 – 0)
                    Vss [ml/kg]                         0 (0 – 0)
                      t_max [h]                   1.2 (1.2 – 1.3)
    Message
      
      -- ALB --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                      NA (NA – NA)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]    3.02e+06 (3.02e+06 – 3.02e+06)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                      -0 (-0 – -0)
                 C_max [µmol/l]                   700 (700 – 700)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]                   700 (700 – 700)
          FractionAucLastToInf                       NA (NA – NA)
                        MRT [h]                      NA (NA – NA)
                      Thalf [h]                      NA (NA – NA)
                     Vd [ml/kg]                      NA (NA – NA)
                    Vss [ml/kg]                      NA (NA – NA)
                      t_max [h]                         0 (0 – 0)
    Message
      
      -- ATP1A2 --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                      NA (NA – NA)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]                         0 (0 – 0)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                      NA (NA – NA)
                 C_max [µmol/l]                         0 (0 – 0)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]                         0 (0 – 0)
          FractionAucLastToInf                       NA (NA – NA)
                        MRT [h]                      NA (NA – NA)
                      Thalf [h]                      NA (NA – NA)
                     Vd [ml/kg]                      NA (NA – NA)
                    Vss [ml/kg]                      NA (NA – NA)
                      t_max [h]                         0 (0 – 0)
    Message
      
      -- SHBG --
      
      -- Organism|VenousBlood|Plasma|Concentration in container 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]                         0 (0 – 0)
        AUC_inf_norm [µg*min/l]                      NA (NA – NA)
          AUC_tEnd [µmol*min/l]                   246 (232 – 281)
       AUC_tEnd_norm [µg*min/l]                      NA (NA – NA)
                 CL [ml/min/kg]                      NA (NA – NA)
                 C_max [µmol/l]          0.0571 (0.0537 – 0.0651)
              C_max_norm [mg/l]                      NA (NA – NA)
                C_tEnd [µmol/l]           0.0571 (0.0536 – 0.065)
          FractionAucLastToInf                       NA (NA – NA)
                        MRT [h]                      NA (NA – NA)
                      Thalf [h] -5.59e+04 (-7.24e+04 – -4.74e+04)
                     Vd [ml/kg]                      NA (NA – NA)
                    Vss [ml/kg]                      NA (NA – NA)
                      t_max [h]                         0 (0 – 0)
    Message
      
      -- Levonorgestrel 1 --
      
      -- Organism|VenousBlood|Plasma|Plasma Unbound 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]       0.00466 (0.00404 – 0.00625)
        AUC_inf_norm [µg*min/l]    3.54e+09 (3.07e+09 – 4.75e+09)
          AUC_tEnd [µmol*min/l]       0.00401 (0.00331 – 0.00488)
       AUC_tEnd_norm [µg*min/l]    3.05e+09 (2.51e+09 – 3.71e+09)
                 CL [ml/min/kg]                   282 (225 – 334)
                 C_max [µmol/l]     8.1e-06 (7.24e-06 – 1.06e-05)
              C_max_norm [mg/l]    6.16e+03 (5.51e+03 – 8.08e+03)
                C_tEnd [µmol/l]    2.56e-07 (2.46e-07 – 4.07e-07)
          FractionAucLastToInf               0.24 (0.189 – 0.253)
                        MRT [h]                48.6 (40.9 – 50.9)
                      Thalf [h]                40.1 (34.6 – 41.7)
                     Vd [ml/kg]     7.1e+05 (6.69e+05 – 1.02e+06)
                    Vss [ml/kg]    5.62e+05 (5.49e+05 – 8.43e+05)
                      t_max [h]                   1.2 (1.2 – 1.3)
    Message
      
      -- Organism|VenousBlood|Plasma|Sum_LNG_species 
    Output
                      Parameter Bayer Study 19604 - control Day 1
           AUC_inf [µmol*min/l]               1.08 (0.911 – 1.57)
        AUC_inf_norm [µg*min/l]     8.2e+11 (6.93e+11 – 1.19e+12)
          AUC_tEnd [µmol*min/l]              0.929 (0.747 – 1.22)
       AUC_tEnd_norm [µg*min/l]    7.06e+11 (5.68e+11 – 9.28e+11)
                 CL [ml/min/kg]               1.22 (0.929 – 1.49)
                 C_max [µmol/l]       0.00186 (0.00162 – 0.00264)
              C_max_norm [mg/l]    1.42e+06 (1.23e+06 – 2.01e+06)
                C_tEnd [µmol/l]    5.93e-05 (5.54e-05 – 0.000103)
          FractionAucLastToInf               0.24 (0.189 – 0.254)
                        MRT [h]                  48.7 (40.9 – 51)
                      Thalf [h]                40.2 (34.6 – 41.7)
                     Vd [ml/kg]    3.07e+03 (2.73e+03 – 4.61e+03)
                    Vss [ml/kg]     2.43e+03 (2.24e+03 – 3.8e+03)
                      t_max [h]                   1.2 (1.2 – 1.3)

---

    Code
      suppressWarnings(compare_pk(lng, aggregation = "median",
        reference_simulation_name = "Bayer Study 19604 - control Day 1"))
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
           AUC_inf_ratio [µmol*min/l]                              4.65
        AUC_inf_norm_ratio [µg*min/l]                              1.27
          AUC_tEnd_ratio [µmol*min/l]                              4.52
       AUC_tEnd_norm_ratio [µg*min/l]                              1.24
                 CL_ratio [ml/min/kg]                             0.785
                 C_max_ratio [µmol/l]                              13.8
              C_max_norm_ratio [mg/l]                              3.77
                C_tEnd_ratio [µmol/l]                              4.91
          FractionAucLastToInf_ratio                              0.467
                        MRT_ratio [h]                             0.612
                      Thalf_ratio [h]                             0.638
                     Vd_ratio [ml/kg]                             0.636
                    Vss_ratio [ml/kg]                             0.614
                      t_max_ratio [h]                            0.0667

---

    Code
      suppressWarnings(compare_pk(lng, aggregation = "mean",
        reference_simulation_name = "Bayer Study 19604 - control Day 1"))
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

