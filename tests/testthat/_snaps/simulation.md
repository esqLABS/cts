# `add_compound` can add compounds to the simulation.

    Code
      my_sim
    Output
      Simulation name: Test
      Individual: Woman
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

# Adding population to a simulation compound works.

    Code
      my_sim
    Output
      Simulation name: Test
      Population: Women
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
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
    Output
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
    Output
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
    Output
      Simulation name: Test
      Individual: Woman
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
      my_sim
    Output
      Simulation name: Test
      Individual: Woman
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
      * Organism|ArterialBlood|Plasma|Levonorgestrel 1|Concentration in container

---

    Code
      my_sim
    Output
      Simulation name: Test
      Individual: Woman
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
      * Organism|VenousBlood|Plasma|Itraconazole|Concentration in container
      * Organism|VenousBlood|Plasma|Levonorgestrel 1|Concentration in container

# Simulation output interval can be set and added

    Code
      my_sim
    Output
      Simulation name: Test
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
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

---

    Code
      add_simulation(ddi, my_sim)
    Condition
      Warning:
      Automatically adding interactions to the simulation.
      Using first interaction found for each enzyme/compound pair.
      Warning:
      Automatically adding processes to the simulation for compound `Levonorgestrel 1`.
      Using first processes of each type and of each metabolizing enzyme found.
      Warning:
      Automatically adding processes to the simulation for compound `Itraconazole`.
      Using first processes of each type and of each metabolizing enzyme found.

# Adding default interactions works.

    Code
      my_sim
    Output
      Simulation name: Test2
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
      * Interactions:
        1. CYP3A4-Isoherranen, 2004
        2. ABCB1-Shityakov 2014
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Adding unknown interactions throws a warning.

    Code
      my_sim
    Output
      Simulation name: Test4
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Adding default processes works.

    Code
      my_sim
    Output
      Simulation name: Test5
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
        1. Total Hepatic Clearance-Parameter identification
        2. CYP3A4-Parameter Identification
        3. SHBG-Qi-Gui & Humpel 1990
        4. ALB-Bayer report
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
        1. Glomerular Filtration-GFR
        2. CYP3A4-Isoherranen 2004
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Adding processes to a simulation compound works.

    Code
      my_sim
    Output
      Simulation name: Test6
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
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
    Output
      Simulation name: Test6
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
        1. CYP3A4-Parameter Identification
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
        1. CYP3A4-Isoherranen 2004
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Adding unknown processes throws a warning.

    Code
      my_sim
    Output
      Simulation name: Test7
      Individual: Woman
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

# Add simulation without compound protocol works

    Code
      my_sim
    Output
      Simulation name: Test
      Individual: Woman
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

# Add a simulation with an unknown population throws an error

    Code
      my_sim
    Output
      Simulation name: Test
      Population: UnknowPop
      Compound: Levonorgestrel 1
      * Protocol: LNG_150 ug_21 Days
      * Formulations: Microlut
      * Processes:
      * Interactions:
      Compound: Itraconazole
      * Protocol: ITZ 100mg 21 days
      * Formulations: IR Dissolved
      * Processes:
      * Interactions:
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h
      Outputs:

