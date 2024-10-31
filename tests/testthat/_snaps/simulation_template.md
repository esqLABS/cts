# fill_simulation_template

    Code
      fill_simulation_template(template_path = system.file("extdata",
        "generic_simulation_template.json", package = "cts"), max_protocol_duration = 24 *
        60 * 60, victim = "rifampicin", perpetrator = "itraconazole", individual = "Male",
      victim_formulation = "Tablet", perpetrator_formulation = "Capsule",
      victim_protocol = "SingleDose", perpetrator_protocol = "SingleDose")
    Output
      $Simulations
      $Simulations[[1]]
      $Simulations[[1]]$Name
      [1] "Generic DDI simulation"
      
      $Simulations[[1]]$Model
      [1] "4Comp"
      
      $Simulations[[1]]$Solver
      named list()
      
      $Simulations[[1]]$OutputSchema
      $Simulations[[1]]$OutputSchema[[1]]
      $Simulations[[1]]$OutputSchema[[1]]$Parameters
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[1]]
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[1]]$Value
      [1] 0
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[2]]
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[2]]$Name
      [1] "End time"
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[2]]$Value
      [1] 86400
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[2]]$Unit
      [1] "s"
      
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[3]]
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[3]]$Name
      [1] "Resolution"
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[3]]$Value
      [1] 4
      
      $Simulations[[1]]$OutputSchema[[1]]$Parameters[[3]]$Unit
      [1] "pts/h"
      
      
      
      
      
      $Simulations[[1]]$Parameters
      list()
      
      $Simulations[[1]]$OutputSelections
      [1] "Organism|PeripheralVenousBlood|rifampicin|Plasma (Peripheral Venous Blood)"  
      [2] "Organism|PeripheralVenousBlood|itraconazole|Plasma (Peripheral Venous Blood)"
      
      $Simulations[[1]]$Individual
      [1] "Male"
      
      $Simulations[[1]]$Compounds
      $Simulations[[1]]$Compounds[[1]]
      $Simulations[[1]]$Compounds[[1]]$Name
      [1] "rifampicin"
      
      $Simulations[[1]]$Compounds[[1]]$CalculationMethods
      list()
      
      $Simulations[[1]]$Compounds[[1]]$Alternatives
      list()
      
      $Simulations[[1]]$Compounds[[1]]$Processes
      list()
      
      $Simulations[[1]]$Compounds[[1]]$Protocol
      $Simulations[[1]]$Compounds[[1]]$Protocol$Name
      [1] "SingleDose"
      
      $Simulations[[1]]$Compounds[[1]]$Protocol$Formulations
      $Simulations[[1]]$Compounds[[1]]$Protocol$Formulations[[1]]
      $Simulations[[1]]$Compounds[[1]]$Protocol$Formulations[[1]]$Name
      [1] "Tablet"
      
      $Simulations[[1]]$Compounds[[1]]$Protocol$Formulations[[1]]$Key
      [1] "Formulation"
      
      
      
      
      
      $Simulations[[1]]$Compounds[[2]]
      $Simulations[[1]]$Compounds[[2]]$Name
      [1] "itraconazole"
      
      $Simulations[[1]]$Compounds[[2]]$CalculationMethods
      list()
      
      $Simulations[[1]]$Compounds[[2]]$Alternatives
      list()
      
      $Simulations[[1]]$Compounds[[2]]$Processes
      list()
      
      $Simulations[[1]]$Compounds[[2]]$Protocol
      $Simulations[[1]]$Compounds[[2]]$Protocol$Name
      [1] "SingleDose"
      
      $Simulations[[1]]$Compounds[[2]]$Protocol$Formulations
      $Simulations[[1]]$Compounds[[2]]$Protocol$Formulations[[1]]
      $Simulations[[1]]$Compounds[[2]]$Protocol$Formulations[[1]]$Name
      [1] "Capsule"
      
      $Simulations[[1]]$Compounds[[2]]$Protocol$Formulations[[1]]$Key
      [1] "Formulation"
      
      
      
      
      
      
      $Simulations[[1]]$Interactions
      list()
      
      $Simulations[[1]]$HasResults
      [1] FALSE
      
      
      

# Interaction can be extracted

    Code
      extract_interactions(levo_itra_ddi)
    Output
      [[1]]
      [[1]]$Name
      CYP3A4-Isoherranen, 2004
      
      [[1]]$MoleculeName
      [1] "CYP3A4"
      
      [[1]]$CompoundName
      [1] "Itraconazole"
      
      
      [[2]]
      [[2]]$Name
      ABCB1-Shityakov 2014
      
      [[2]]$MoleculeName
      [1] "ABCB1"
      
      [[2]]$CompoundName
      [1] "Itraconazole"
      
      
      [[3]]
      [[3]]$Name
      CYP3A4-Isoherranen, 2004
      
      [[3]]$MoleculeName
      [1] "CYP3A4"
      
      [[3]]$CompoundName
      [1] "Hydroxy-Itraconazole"
      
      
      [[4]]
      [[4]]$Name
      CYP3A4-Isoherranen, 2004
      
      [[4]]$MoleculeName
      [1] "CYP3A4"
      
      [[4]]$CompoundName
      [1] "Keto-Itraconazole"
      
      
      [[5]]
      [[5]]$Name
      CYP3A4-Isoherranen, 2004
      
      [[5]]$MoleculeName
      [1] "CYP3A4"
      
      [[5]]$CompoundName
      [1] "N-desalkyl-Itraconazole"
      
      

# Compounds process can be extracted

    Code
      extract_compound_processes(levo_itra_ddi$compounds[[1]])
    Output
      [[1]]
      [[1]]$Name
      Total Hepatic Clearance-Parameter identification
      
      [[1]]$SystemicProcessType
      [1] "Hepatic"
      
      
      [[2]]
      [[2]]$Name
      CYP3A4-Parameter Identification
      
      [[2]]$MoleculeName
      [1] "CYP3A4"
      
      
      [[3]]
      [[3]]$Name
      SHBG-Qi-Gui & Humpel 1990
      
      [[3]]$MoleculeName
      [1] "SHBG"
      
      
      [[4]]
      [[4]]$Name
      ALB-Bayer report
      
      [[4]]$MoleculeName
      [1] "ALB"
      
      

