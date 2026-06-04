# EV Adoption in Europe – SAS Analysis

Final project for the ZADA course at OTH Regensburg (Erasmus, 2025).

## Overview
This project analyzes the key drivers of battery electric vehicle (BEV) adoption 
across 28 European countries using SAS Viya. The analysis covers the period 
2013–2024 and is structured around three main pillars:

- **Economic & Environmental Drivers** – GDP per capita, clean electricity share, 
  transport emissions (regression & correlation analysis)
- **Charging Infrastructure** – Custom Charging Points Index weighted by charger 
  speed/power, BEV-to-charger ratios, geographic density maps
- **Clean Energy Investment** – EU-wide regression of investment on BEV sales 
  and transport emissions (2015–2023)
- **Composite EV Ecosystem Score** – Z-score standardization across all three 
  pillars to rank countries by EV readiness

## Data Sources
EAFO, Eurostat, IEA Global EV Data, IEA Monthly Electricity Statistics, 
IEA World Energy Investment 2024, EEA National Emissions Database

## Tools & Methods
SAS Viya — `proc import`, `proc sql`, `proc corr`, `proc reg`, `proc standard`, 
`proc sgplot`, `proc gchart`, `proc gmap`

## Key Findings
- GDP and clean electricity share positively predict BEV market share
- Charger quantity (r = 0.90) tracks total BEV fleet far better than charger quality
- Clean energy investment explains 96% of variation in EU-wide BEV sales (R² = 0.961)
- Norway, Sweden, and Finland lead the composite EV ecosystem ranking
