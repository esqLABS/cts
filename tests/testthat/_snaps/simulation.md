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
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h

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
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 24 h
        * Resolution: 4 pts/h

# Simulation output interval can be set and added

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
      Output schema:
      * Interval 1
        * Start time: 0 h
        * End time: 2 h
        * Resolution: 20 pts/h
      * Interval 2
        * Start time: 2 h
        * End time: 48 h
        * Resolution: 1 pts/h

