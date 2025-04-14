# create_ddi prints the correct status message

    Code
      capture_messages(suppressWarnings(ddi <- create_ddi(rifampicin, midazolam,
        midazolam)))
    Output
      character(0)

# print ddi object works

    Code
      levo_itra_ddi
    Output
      DDI project containing:
      Victim compound:
      * Levonorgestrel 1
      Perpetrator compounds:
      * Itraconazole
      * Hydroxy-Itraconazole
      * Keto-Itraconazole
      * N-desalkyl-Itraconazole
      Simulations:
      * LNG 0.09 mg IV - Bayer Study A229
      * IV
      * Bayer Study 19604 - control Day 1
      * LNG 0.09 mg PO (Microlut) - Bayer Study A53768
      * LNG 0.03 mg PO single dose - Bayer Study A53768
      * LNG 0.27 mg PO single dose - Bayer Study A53768
      * LNG 0.03 mg PO multiple doses - Bayer Study A53768
      * LNG 0.75 mg population
      * Natavio et al 2019 - Class I and II BMI
      * Praditpan et al 2017 - Normal BMI
      * Praditpan et al 2017 - Class I and II BMI
      * Natavio et al 2019 - Normal BMI
      * LNG 0.09 mg IV - Bayer Study A229 fmCYP3A4
      * DDI_LNG150ug_21days
      * DDI_LNG150ug_21days_Obe
      * LNG 0.03 mg standard
      * LNG 0.03 mg 40% less
      * LNG 0.03 mg 40% more

