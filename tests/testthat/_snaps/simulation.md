# `add_compound` can add compounds to the simulation.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Test compound 2
      * Protocol: New protocol
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# `set_compound_protocol` can set a new protocol for a compound.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol: iv 300 mg (0.5 h)
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Tablet (Dormicum)
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

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
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations:
        1. Formulation: IR Dissolved
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Setting a population in a simulation remove defined individual and vice versa.

    Code
      sim
    Message
      Simulation name: Test
      Population: Women
      Compound: Levonorgestrel 1
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

---

    Code
      sim
    Message
      Simulation name: Test
      Individual: Woman SHBG 40% more
      Compound: Levonorgestrel 1
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Adding/setting outptuts to a simulation object works.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

---

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:
      * Organism|ArterialBlood|Plasma|Rifampicin|Concentration in container

---

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol:
      * Formulations:
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:
      * Organism|VenousBlood|Plasma|Midazolam|Concentration in container
      * Organism|VenousBlood|Plasma|Rifampicin|Concentration in container

# Simulation output interval can be set and added

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol: iv 300 mg (0.5 h)
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Tablet (Dormicum)
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 2 h
        * Resolution: 20 pts/h
      * Interval 2
        * Start time: 2 h
        * End time: 48 h
        * Resolution: 1 pts/h
      Outputs:

# Adding processes to a simulation compound works.

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol: iv 300 mg (0.5 h)
      * Formulations:
      * Processes:
      * Interactions:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Oral solution
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

---

    Code
      my_sim
    Message
      Simulation name: Test
      Individual: European (P-gp modified, CYP3A4 36 h)
      Compound: Rifampicin
      * Protocol: iv 300 mg (0.5 h)
      * Formulations:
      * Processes:
        1. AADAC-Nakajima 2011
        2. P-gp-Collett 2004
      * Interactions:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Oral solution
      * Processes:
        1. CYP3A4-Optimized
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Add a simulation with an unknown population throws an error

    Code
      my_sim
    Message
      Simulation name: Test
      Population: UnknowPop
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations:
        1. Formulation: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations:
        1. Formulation: IR Dissolved
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

