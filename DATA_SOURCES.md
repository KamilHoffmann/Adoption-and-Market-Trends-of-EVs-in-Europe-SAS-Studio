# Data Sources

Datasets small enough to be included are available in the `data/` folder.
Larger datasets must be downloaded separately from the links below.
All data was downloaded in May 2025; results may differ with newer versions.

## EAFO
All three datasets available at:
https://alternative-fuels-observatory.ec.europa.eu/transport-mode/road/eu27-uk-norway-iceland-switzerland-turkey-liechtenstein

Download instructions (CSV format, no login required):
- **AF Market Share of Total Registrations** ✅ included in `data/` – scroll to "AF Market share of total registrations (M1&N1)" → download icon → Download CSV
- **BEV Total Numbers** ⬇️ download separately – scroll to "AF Fleet (M1&N1)" → download icon → Download CSV
- **Recharging Points Q4 2024** ⬇️ download separately – scroll to "Recharging points (EVSE)" → download icon → Download CSV

## Eurostat
- **GDP per Capita in PPS** ✅ included in `data/` – https://ec.europa.eu/eurostat/databrowser/view/tec00114/default/table?lang=en  
  CSV format, no login required.

## IEA
Free email registration required. Files available as CSV or Excel.
- **IEA Global EV Data timeline 2024** ✅ included in `data/` – The 2024 edition is no longer publicly available as IEA has since released newer versions. Current versions can be found by searching "Global EV Outlook" at https://www.iea.org/data-and-statistics/data-products
- **Monthly Electricity Statistics** ✅ included in `data/` – https://www.iea.org/data-and-statistics/data-product/monthly-electricity-statistics
- **World Energy Investment 2024** ⬇️ download separately – https://www.iea.org/data-and-statistics/data-product/world-energy-investment-2024-datafile

## EEA
- **National GHG Emissions** ⬇️ download separately – https://www.eea.europa.eu/en/datahub/datahubitem-view/3b7fe76c-524a-439a-bfd2-a6e4046302a2  
  Free download, CSV or Excel format.

## File Path Note
The SAS code references file paths specific to the SAS Viya environment used
during development. Before running, update all `proc import` file paths in
`Final Project Code_Petru.sas` to match your local file locations.
