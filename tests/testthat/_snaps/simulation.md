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
      Outputs:

# Add simulation without compound protocol works

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
      Outputs:

# Adding default interactions works.

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
        1. CYP3A4-Kajosaari 2005
        2. P-gp-Reitman 2011
        3. OATP1B1-Dixit 2007
        4. AADAC-Assumed
        5. CYP2C8-Kajosaari 2005
        6. CYP1A2-Chen 2010
        7. CYP2E1-Rae 2001
        8. OATP1B3-Annaert 2010
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Oral solution
      * Processes:
      * Interactions:
      Outputs:

# Adding unknown interactions throws a warning.

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
        1. P-gp-Reitman 2011
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Oral solution
      * Processes:
      * Interactions:
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
      Outputs:
      * Organism|VenousBlood|Plasma|Midazolam|Concentration in container
      * Organism|VenousBlood|Plasma|Rifampicin|Concentration in container

# Adding default processes works.

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
        3. OATP1B1-Tirona 2003
        4. Glomerular Filtration-GFR
      * Interactions:
      Compound: Midazolam
      * Protocol: po 3.5 mg
      * Formulations:
        1. Formulation: Oral solution
      * Processes:
        1. GABRG2-Buhr 1997
        2. Glomerular Filtration-Optimized
        3. CYP3A4-Optimized
        4. UGT1A4-Optimized
      * Interactions:
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
      Outputs:

# Adding unknowkn processes throws a warning.

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
      Outputs:

