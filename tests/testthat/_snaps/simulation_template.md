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
      [2] "Organism|PeripheralVenousBlood|rifampicin|Plasma Unbound (Peripheral Venous Blood)"  
      [3] "Organism|PeripheralVenousBlood|itraconazole|Plasma (Peripheral Venous Blood)"        
      [4] "Organism|PeripheralVenousBlood|itraconazole|Plasma Unbound (Peripheral Venous Blood)"
      
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
      
      
      $Simulations[[2]]
      $Simulations[[2]]$Name
      [1] "Generic victim only simulation"
      
      $Simulations[[2]]$Model
      [1] "4Comp"
      
      $Simulations[[2]]$Solver
      named list()
      
      $Simulations[[2]]$OutputSchema
      $Simulations[[2]]$OutputSchema[[1]]
      $Simulations[[2]]$OutputSchema[[1]]$Parameters
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[1]]
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[1]]$Value
      [1] 0
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[2]]
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[2]]$Name
      [1] "End time"
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[2]]$Value
      [1] 86400
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[2]]$Unit
      [1] "s"
      
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[3]]
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[3]]$Name
      [1] "Resolution"
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[3]]$Value
      [1] 4
      
      $Simulations[[2]]$OutputSchema[[1]]$Parameters[[3]]$Unit
      [1] "pts/h"
      
      
      
      
      
      $Simulations[[2]]$Parameters
      list()
      
      $Simulations[[2]]$OutputSelections
      [1] "Organism|PeripheralVenousBlood|rifampicin|Plasma (Peripheral Venous Blood)"        
      [2] "Organism|PeripheralVenousBlood|rifampicin|Plasma Unbound (Peripheral Venous Blood)"
      
      $Simulations[[2]]$Individual
      [1] "Male"
      
      $Simulations[[2]]$Compounds
      $Simulations[[2]]$Compounds[[1]]
      $Simulations[[2]]$Compounds[[1]]$Name
      [1] "rifampicin"
      
      $Simulations[[2]]$Compounds[[1]]$CalculationMethods
      list()
      
      $Simulations[[2]]$Compounds[[1]]$Alternatives
      list()
      
      $Simulations[[2]]$Compounds[[1]]$Processes
      list()
      
      $Simulations[[2]]$Compounds[[1]]$Protocol
      $Simulations[[2]]$Compounds[[1]]$Protocol$Name
      [1] "SingleDose"
      
      $Simulations[[2]]$Compounds[[1]]$Protocol$Formulations
      $Simulations[[2]]$Compounds[[1]]$Protocol$Formulations[[1]]
      $Simulations[[2]]$Compounds[[1]]$Protocol$Formulations[[1]]$Name
      [1] "Tablet"
      
      $Simulations[[2]]$Compounds[[1]]$Protocol$Formulations[[1]]$Key
      [1] "Formulation"
      
      
      
      
      
      
      $Simulations[[2]]$Interactions
      list()
      
      $Simulations[[2]]$HasResults
      [1] FALSE
      
      
      

