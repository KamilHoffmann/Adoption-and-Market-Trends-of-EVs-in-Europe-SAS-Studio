# Data Sources

## EAFO
All three datasets available at:
https://alternative-fuels-observatory.ec.europa.eu/transport-mode/road/eu27-uk-norway-iceland-switzerland-turkey-liechtenstein

Download instructions (CSV format, no login required):
- **BEV Total Numbers** – scroll to "AF Fleet (M1&N1)" → click download icon → Download CSV
- **AF Market Share of Total Registrations** – scroll to "AF Market share of total registrations (M1&N1)" → click download icon → Download CSV
- **Recharging Points Q4 2024** – scroll to "Recharging points (EVSE)" → click download icon → Download CSV

## Eurostat
- **GDP per Capita in PPS**: https://ec.europa.eu/eurostat/databrowser/view/tec00114/default/table?lang=en  
  CSV format, no login required.

## IEA
Free email registration required. Files available as CSV or Excel.
- **World Energy Investment 2024**: https://www.iea.org/data-and-statistics/data-product/world-energy-investment-2024-datafile
- **Monthly Electricity Statistics**: https://www.iea.org/data-and-statistics/data-product/monthly-electricity-statistics
- **Global EV Outlook 2024**: The 2024 edition used in this project is no longer 
  publicly available as IEA has since released newer versions. The original dataset 
  is included in the `data/` folder of this repository.

## EEA
- **National GHG Emissions**: https://www.eea.europa.eu/en/datahub/datahubitem-view/3b7fe76c-524a-439a-bfd2-a6e4046302a2  
  Free download, CSV or Excel format.

## File Path Note
The SAS code references file paths specific to the SAS Viya environment used during development.
Before running the code, update all `proc import` file paths in `Final Project Code_Petru.sas` to match the location where you have saved the datasets locally.
All paths are at the top of each `proc import` statement.
