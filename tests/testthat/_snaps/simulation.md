# `add_compound` can add compounds to the simulation.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol:
      * Formulations:
      Compound: Midazolam
      * Protocol:
      * Formulations:
      Compound: Test compound 2
      * Protocol: New protocol
      * Formulations:

# `set_compound_protocol` can set a new protocol for a compound.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol: iv 300 mg (0.5 h)
      * Formulations:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Tablet (Dormicum)

# Adding population to a simulation compound works.

    Code
      my_sim
    Message
      Simulation name: Test
      Population: Women
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations:
        1. Formulation: Microlut
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations:
        1. Formulation: IR Dissolved

# Adding an unknown population to a simulation compound does not work.

    Code
      my_sim
    Message
      Simulation name: Test
      Population: UnknowPop
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations:
        1. Formulation: Microlut
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations:
        1. Formulation: IR Dissolved

# Setting a population in a simulation remove defined individual and vice versa.

    Code
      sim
    Message
      Simulation name: Test
      Population: Women
      Compound: Levonorgestrel 1
      * Protocol:
      * Formulations:
      Compound: Itraconazole
      * Protocol:
      * Formulations:

---

    Code
      sim
    Message
      Simulation name: Test
      Individual: Woman SHBG 40% more
      Compound: Levonorgestrel 1
      * Protocol:
      * Formulations:
      Compound: Itraconazole
      * Protocol:
      * Formulations:

