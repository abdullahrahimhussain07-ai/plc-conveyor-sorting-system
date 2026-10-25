# PLC-Based Conveyor Sorting System | Industrial Automation

## Overview
Developed as part of the DecodeLabs industrial training mastery phase[cite: 10], this project implements a deterministic **Finite State Machine (FSM)**, sensor edge detection, transit timing physics, and hardwired safety interlocks for an automated conveyor sorting line.

## System Architecture & I/O Mapping
* **`%I0.0` (i_Start_PB):** Start Push Button (NO) with 500ms debounce filter[cite: 14].
* **`%I0.1` (i_Prox_Sensor):** Proximity sensor for box entry detection[cite: 14].
* **`%I0.2` (i_EStop_Mon):** Safety relay monitoring feedback input[cite: 14].
* **`%Q1.0` (q_Conv_Motor):** Conveyor belt drive contactor[cite: 14].
* **`%Q1.1` (q_Reject_Push):** Pneumatic diverter solenoid valve[cite: 14].
* **`%Q1.2` (q_Warn_Light):** Amber warning beacon for fault states[cite: 14].

## Key Engineering Logic
* **Finite State Machine (FSM):** Mutually exclusive states (`Idle`, `Running`, `Sorting`, `Fault`) prevent output race conditions[cite: 15].
* **Transit Timing Physics:** Utilizes an On-Delay Timer (`TON`) set to $1.5\text{s}$ based on transport velocity ($v = 0.5\text{m/s}$) and distance ($d = 0.75\text{m}$)[cite: 19].
* **Safety Mandates (NFPA 79 / IEC 60204-1):** Dual-contact E-Stop architecture ensures a hardware-level Stop Category 0 power cutoff independent of PLC CPU software loops[cite: 20].

## Running the Digital Twin Simulation
You can execute the control logic simulation locally using PowerShell:
```powershell
.\simulation.ps1
