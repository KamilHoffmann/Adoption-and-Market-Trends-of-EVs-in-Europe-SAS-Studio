*Simon Petru start 26/06/25;
*OTH ZADA Final Project;

*1. Import;
*AF Market share of total registrations;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/20250523_183259_export.csv'
out=evsmarketsharetotal
dbms=csv
replace;
guessingrows=max;

*GDP per capita in PPS;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/tec00114_page_spreadsheet.csv'
out=gdp
dbms=csv
replace;
guessingrows=max;

*IEA Global EV Data_timeline2024;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/IEA Global EV Data_timeline2024.csv'
out=evsmarketsharetimeline
dbms=csv
replace;
guessingrows=max;

*Monthly Electricity Statistics;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/MES_0125.csv'
out=electricity
dbms=csv
replace;
guessingrows=max;
getnames=no;
datarow=10;

*National Emissions Europe;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/UNFCCC_v28.csv'
out=emissions
dbms=csv
replace;
guessingrows=max;

*Recharging points Q4 2024;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/20250523_183321_export.csv'
out=recharging
dbms=csv
replace;
guessingrows=max;
getnames=no;
datarow=2;

*Total numbers of BEVs in Europe;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/20250523_183235_export.csv'
out=evstotal
dbms=csv
replace;
guessingrows=max;

*WorldEnergyInvestment2024_DataFile;
proc import datafile='/export/viya/homes/edu.simon.petru@savs.cz/Project/Datasets/WorldEnergyInvestment2024_DataFile.xlsx'
out=energyinvest
dbms=xlsx
replace;
sheet='Europe';

run;

*2. Primary cleaning and filtration;
%let eu_countries = 
    'Austria' 'Belgium' 'Bulgaria' 'Croatia' 'Cyprus' 'Czechia' 'Denmark' 'Estonia' 'Finland'
    'France' 'Germany' 'Greece' 'Hungary' 'Iceland' 'Ireland' 'Italy' 'Latvia' 'Lithuania'
    'Luxembourg' 'Netherlands' 'Norway' 'Poland' 'Portugal' 'Romania' 'Slovakia' 'Slovenia'
    'Spain' 'Sweden';

*AF Market share of total registrations;
data evsmarketsharetotal_clean;
    set evsmarketsharetotal;
    Country = strip(Category);
	drop Category;
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
	keep Country BEV;
run;

*GDP per capita in PPS;
data gdp_clean;
    set gdp;
    Country = strip("Geopolitical entity (reporting)"n);
	drop "Geopolitical entity (reporting)"n;
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
	keep Country TIME_PERIOD OBS_VALUE;
run;

*IEA Global EV Data;
data evsmarketsharetimeline_clean;
    set evsmarketsharetimeline;
    Country = strip(region);
	drop region;
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
run;

*Monthly Electricity Statistics;
data electricity_clean;
    set electricity;
	rename 
        VAR1 = Country
        VAR2 = Time
        VAR3 = Balance
        VAR4 = Product
        VAR5 = Value
        VAR6 = Unit;
run;
data electricity_clean;
    set electricity_clean;
	Country = strip(Country);
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
run;

*National Emissions Europe;
data emissions_clean;
    set emissions;
	Country = strip(Country);
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
	keep Country Pollutant_name Sector_name Year emissions;
run;

*Recharging Points;
data recharging_clean;
    set recharging;
    Country = strip(VAR1);
    Slow_AC   = coalesce(VAR2, 0);
    Medium_AC = coalesce(VAR3, 0);
    Fast_AC   = coalesce(VAR4, 0);
    Slow_DC   = coalesce(VAR5, 0);
    Fast_DC   = coalesce(VAR6, 0);
    Ultra1_DC = coalesce(VAR7, 0);
    Ultra2_DC = coalesce(VAR8, 0);
run;
data recharging_clean;
    set recharging_clean;
    Country = strip(Country);
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
	drop VAR1 VAR2 VAR3 VAR4 VAR5 VAR6 VAR7 VAR8;
run;

*Total numbers of BEVs in Europe;
data evstotal_clean;
    set evstotal;
    Country = strip(Category);
	drop Category;
    if Country = 'Czech Republic' then Country = 'Czechia';
    if Country = 'Slovak Republic' then Country = 'Slovakia';
    if Country in (&eu_countries);
	keep Country BEV;
run;

/*
This section was checked by ChatGPT for syntax: "Check my sas code syntax:

data energyinvest_clean;
    set energyinvest;
    if N = 5;
    array years {*} "47" "48" "49" "50" "51" "52" "53" "54" "55";
    do i = 1 to dim(years);
        Year = 2014 + i;
        Clean_Energy_Inv = input(years{i}, best.);
        output;
    end;
    keep Year Clean_Energy_Inv;
run;
*/

*WorldEnergyInvestment2024_DataFile;
data energyinvest_clean;
    set energyinvest;
    if _N_ = 5;
    array years {*} "47"n "48"n "49"n "50"n "51"n "52"n "53"n "54"n "55"n;
    do i = 1 to dim(years);
        Year = 2014 + i;
        Clean_Energy_Inv = input(years{i}, best.);
        output;
    end;
    keep Year Clean_Energy_Inv;
run;

*3. Analysis;
*A. Economic and environmental drivers of BEV adoption;
*A1;
*Filter data IEA Global EV Data_timeline2024;
data bev_marketshare_A1;
    set evsmarketsharetimeline_clean;
    where parameter = "EV sales share"
          and category = "Historical"
          and mode ne "Buses"
          and powertrain in ("EV", "BEV")
          and 2013 <= year <= 2023;
    keep Country year value;
    rename value = BEV_market_share;
run;

*Filter and rename GDP data (2013–2023);
data gdp_A1;
    set gdp_clean;
    where 2013 <= TIME_PERIOD <= 2023;
    year = TIME_PERIOD;
    GDP_per_capita_PPS = OBS_VALUE;
    keep Country year GDP_per_capita_PPS;
run;

*A1a;
*Merge BEV market share and GDP datasets;
proc sql;
    create table A1a as
    select a.Country, a.year, a.BEV_market_share, b.GDP_per_capita_PPS
    from bev_marketshare_A1 as a
    inner join gdp_A1 as b
    on a.Country = b.Country and a.year = b.year;
quit;

*Correlation analysis;
proc corr data=A1a;
    var BEV_market_share GDP_per_capita_PPS;
	title "A1 BEV Market Share and GDP Correlation Analysis (2013–2023)";
run;

*Regression analysis;
proc reg data=A1a;
    model BEV_market_share = GDP_per_capita_PPS;
	title "A1 BEV Market Share and GDP Regression Analysis (2013–2023)";
run;
quit;

*A2;
*A2a; 
*Annual clean electricity share (% of final consumption);

data electricity_A2a1;
    set electricity_clean;
    Year = input(scan(Time, 2, ' '), 4.);
run;

proc sql;
	create table A2a as
	select Country,
           Year,
          	sum(case when Product in ("Nuclear", "Total Renewables (Hydro, Geo, Solar, Wind, Other)") 
                 then Value else 0 end) as Clean_Energy,
          	sum(case when Balance = "Final Consumption (Calculated)" then Value else 0 end) 
			as Final_Consumption from electricity_A2a1
    	where Year between 2013 and 2023
    group by Country, Year;
quit;

data A2a;
    set A2a;
    Clean_Energy_Share = (Clean_Energy / Final_Consumption) * 100;
    keep Country Year Clean_Energy_Share;
run;

*A2b; 
*Annual transport emissions;
proc sql;
    create table A2b as
    select Country, Year,
           sum(emissions) as Transport_Emissions
    from emissions_clean
    where Sector_name = "1.A.3 - Transport"
      and Year between 2013 and 2023
    group by Country, Year;
quit;

*A2c;
*Merge Clean Energy Share, Transport Emissions, and A1a;
proc sql;
    create table A2c as
    select a.*, b.Clean_Energy_Share, c.Transport_Emissions
    from A1a as a
    left join A2a as b
        on a.Country = b.Country and a.Year = b.Year
    left join A2b as c
        on a.Country = c.Country and a.Year = c.Year;
quit;

*Correlation analysis;
proc corr data=A2c;
    var BEV_market_share GDP_per_capita_PPS Clean_Energy_Share Transport_Emissions;
	title1 "A2 Correlation Analysis";
	title2 "BEV market share explained by GDP Clean Energy and Transport Emissions (2013–2023)";
run;

*Multiple Linear Regression analysis;
proc reg data=A2c plots=none;
    model BEV_market_share = GDP_per_capita_PPS Clean_Energy_Share Transport_Emissions;
	title1 "A2 Multiple Linear Regression Analysis";
	title2 "BEV market share explained by GDP Clean Energy and Transport Emissions (2013–2023)";
run;

*Matrix plot;
proc sgscatter data=A2c;
    matrix BEV_market_share GDP_per_capita_PPS Clean_Energy_Share Transport_Emissions;
    title "A2 Matrix plot BEV market share and GDP Clean Energy and Transport Emissions (2013–2023)";
run;

*B. Charging infrastructure and EV adoption;
*B1;
*B1a;
*Calculate Charging Points Index and Total Number of Chargers;
data B1a;
    set recharging_clean;
    Charging_Index =
        1  * input(strip(Slow_AC), best.) +
        2  * input(strip(Medium_AC), best.) +
        3  * input(strip(Fast_AC), best.) +
        4  * input(strip(Slow_DC), best.) +
        6  * input(strip(Fast_DC), best.) +
        8  * input(strip(Ultra1_DC), best.) +
        10 * input(strip(Ultra2_DC), best.);

    Total_Chargers = sum(of Slow_AC Medium_AC Fast_AC Slow_DC Fast_DC Ultra1_DC Ultra2_DC);
run;

*B1b;
*Merge B1a with Total BEV Market Share and Total Numbers of BEVs;
proc sql;
    create table B1b as
    select 
        a.Country,
        a.Charging_Index,
        a.Total_Chargers,
        b.BEV as BEV_total,
        c.BEV as BEV_market_share
    from B1a as a
    left join evstotal_clean as b
        on a.Country = b.Country
    left join evsmarketsharetotal_clean as c
        on a.Country = c.Country;
quit;

*Calculate BEVs per Charger and Index per 1000 BEVs;
data B1b;
    set B1b;

    if Total_Chargers > 0 then BEV_per_charger = BEV_total / Total_Chargers;
    else BEV_per_charger = .;

    if BEV_total > 0 then Index_per_1000_BEV =(Charging_Index / BEV_total)*1000;
    else Index_per_1000_BEV = .;
run;

*Map;
data europemap;
    set mapsgfk.europe;
    Country_ID = upcase(idname);
run;

data B1b_map;
	length Country_ID $55;
    set B1b;
    Country_ID = upcase(Country);

    if Country_ID = 'CZECHIA' then Country_ID = 'CZECH REPUBLIC';
    if Country_ID = 'SLOVAKIA' then Country_ID = 'SLOVAK REPUBLIC';
run;

pattern1 v=s c=darkgreen;
pattern2 v=s c=forestgreen;
pattern3 v=s c=seagreen;
pattern4 v=s c=mediumseagreen;
pattern5 v=s c=limegreen;
pattern6 v=s c=yellowgreen;
pattern7 v=s c=yellow;
pattern8 v=s c=gold;
pattern9 v=s c=orange;
pattern10 v=s c=red;

*Mapa: BEVs per charger;
proc gmap data=B1b_map map=europemap all;
    id Country_ID;
    choro BEV_per_charger / levels=10;
    title "B1 BEVs per Charger";
run;

pattern1 v=s c=red;
pattern2 v=s c=orange;
pattern3 v=s c=gold;
pattern4 v=s c=yellow;
pattern5 v=s c=yellowgreen;
pattern6 v=s c=limegreen;
pattern7 v=s c=mediumseagreen;
pattern8 v=s c=seagreen;
pattern9 v=s c=forestgreen;
pattern10 v=s c=darkgreen;

*Mapb: Charging Index per 1000 BEVs;
proc gmap data=B1b_map map=europemap all;
    id Country_ID;
    choro Index_per_1000_BEV / levels=10;
    title "B1 Charging Points Index per 1000 BEVs";
run;

*B2;
*Correlation Analysis for related metrics;
proc corr data=B1b;
    var Charging_Index Total_Chargers;
    with BEV_market_share BEV_total;
	title1 "B2 Correlation Analysis";
    title2 "Charging Infrastructure vs. BEV Outcomes in Pairs";
run;

*Regression charging index predict BEV market share;
proc reg data=B1b;
    model BEV_market_share = Charging_Index;
	title1 "B2 Regression Analysis";
    title2 "Charging Points Index Explaining BEV Market Share";
run;

*Regression total chargers predict BEV total;
proc reg data=B1b;
    model BEV_total = Total_Chargers;
	title1 "B2 Regression Analysis";
    title2 "Total Chargers Explaining BEV Count";
run;

*C. Impact of clean energy Investments (EU-wide);
*C1;
*BEV Sales Agregated for Europe;
data C1_BEV_sales;
    set evsmarketsharetimeline_clean;
    where parameter = "EV sales"
          and category = "Historical"
          and mode ne "Buses"
          and powertrain in ("EV", "BEV")
          and 2015 <= year <= 2023;
    keep Country year value;
run;

proc sql;
    create table C1_BEV_sales_grouped as
    select year,
           sum(value) as C1_BEV_sales_Europe
    from C1_BEV_sales
    group by year;
quit;

*Emissions Agregated for Europe;
data C1_emissions;
    set emissions_clean;
    where Sector_name contains "Transport"
          and 2015 <= Year <= 2023;
    keep Country Year Emissions;
run;

proc sql;
    create table C1_emissions_grouped as
    select Year,
           sum(Emissions) as C1_emissions_Europe
    from C1_emissions
    group by Year;
quit;

*C1a;
proc sql;
    create table C1a as
    select 
        a.Year,
        a.Clean_Energy_Inv,
        b.C1_BEV_sales_Europe,
        c.C1_emissions_Europe
    from energyinvest_clean as a
    left join C1_BEV_sales_grouped as b
        on a.Year = b.year
    left join C1_emissions_grouped as c
        on a.Year = c.Year;
quit;

*Regression Clean Energy Investment predicts BEV Sales;
proc reg data=C1a;
    model C1_BEV_sales_Europe = Clean_Energy_Inv;
	title1 "C1 Regression Analysis";
    title2 "Clean Energy Investment Explaining BEV Sales";
run;

*Regression Clean Energy Investment predicts Emissions;
proc reg data=C1a;
    model C1_emissions_Europe = Clean_Energy_Inv;
	title1 "C1 Regression Analysis";
    title2 "Clean Energy Investment Explaining Emissions";
run;

proc sgplot data=C1a;
    title "C1 Investment and BEV Sales Over Time";
    series x=Year y=Clean_Energy_Inv / lineattrs=(thickness=2 color=blue) legendlabel="Investment (Bilion USD)";
    series x=Year y=C1_BEV_sales_Europe / y2axis lineattrs=(thickness=2 color=green) legendlabel="EV Sales (Units)";
    yaxis label="Clean Energy Investment (Bilion USD)";
    y2axis label="EV Sales" min=0;
    keylegend / position=bottom;
run;

proc sgplot data=C1a;
    title "C1 Investment and Transport Emissions Over Time";
    series x=Year y=Clean_Energy_Inv / lineattrs=(thickness=2 color=blue) legendlabel="Investment";
    series x=Year y=C1_emissions_Europe / y2axis lineattrs=(thickness=2 color=red) legendlabel="Emissions";
    yaxis label="Clean Energy Investment (Bilion USD)";
    y2axis label="Transport Emissions" min=0;
    keylegend / position=bottom;
run;

*D.	Most balanced EV ecosystems in Europe;
*D1;
/* 
This list was checked for correct values using ChatGPT: Check values of land areas in sq km for this list:Austria' 'Belgium' 'Bulgaria' 'Croatia' 'Cyprus' 'Czechia' 'Denmark' 'Estonia' 'Finland'
   	'France' 'Germany' 'Greece' 'Hungary' 'Iceland' 'Ireland' 'Italy' 'Latvia' 'Lithuania'
    'Luxembourg' 'Netherlands' 'Norway' 'Poland' 'Portugal' 'Romania' 'Slovakia' 'Slovenia'
    'Spain' 'Sweden'
*/

*Introducing generated dataset containing Land Areas of the relevant countries in sq km;
data country_land_area;
    input Country :$20. Land_Area;
    datalines;
Austria 83871
Belgium 30528
Bulgaria 110879
Croatia 56594
Cyprus 9251
Czechia 78867
Denmark 42933
Estonia 45228
Finland 303816
France 551695
Germany 357588
Greece 131957
Hungary 93028
Iceland 102775
Ireland 70273
Italy 301340
Latvia 62200
Lithuania 62674
Luxembourg 2586
Netherlands 41543
Norway 365268
Poland 311888
Portugal 91590
Romania 238397
Slovakia 49035
Slovenia 20273
Spain 505992
Sweden 447425
;
run;

*D1a;
*Filter Out only Q4 2024 electricity data;
data D1_electricity;
    set electricity_clean;
    Month = scan(Time, 1, ' ');
    Year = input(scan(Time, 2, ' '), 4.);
    if Month in ('October', 'November', 'December') and Year = 2024;
run;

*Q4 2024 clean electricity share (% of final consumption);
proc sql;
    create table D1a as
    select 
        Country,
        sum(case 
                when Product in ("Nuclear", "Total Renewables (Hydro, Geo, Solar, Wind, Other)") 
                then Value else 0 
            end) as Clean_Energy,
        sum(case 
                when Balance = "Final Consumption (Calculated)" 
                then Value else 0 
            end) as Final_Consumption
    from D1_electricity
    group by Country;
quit;

data D1a;
    set D1a;
    Clean_Energy_Share = (Clean_Energy / Final_Consumption) * 100;
    keep Country Clean_Energy_Share;
run;

*D1b
*Merge Clean Electricity, Charging Index, Country Land Area and BEV market Share;
proc sql;
    create table D1b as
    select 
        a.Country,
        a.BEV as BEV_market_share,
        b.Charging_Index,
        c.Land_Area,
        d.Clean_Energy_Share
    from evsmarketsharetotal_clean as a
    left join B1a as b
        on a.Country = b.Country
    left join country_land_area as c
        on a.Country = c.Country
    left join D1a as d
        on a.Country = d.Country;
quit;

*Calculate Charging Index per 1000 km²;
data D1b;
    set D1b;
    Charging_Index_per_1000_km2 = Charging_Index / (Land_Area / 1000);
run;

*Standardize dataset D1b;
proc standard data=D1b mean=0 std=1 out=D1b_std;
    var BEV_market_share Charging_Index_per_1000_km2 Clean_Energy_Share;
run;

*D2a;
*Composite Score Calculation using means of z-scores;
data D2a;
    set D1b_std;
    Composite_Score = mean(of BEV_market_share Charging_Index_per_1000_km2 Clean_Energy_Share);
run;

*D3;
*EV Readiness Level;
data D2c;
    set D2a;
    length EV_Readiness $10;
    if Composite_Score >= 0.5 then EV_Readiness = "High";
    else if Composite_Score >= -0.5 then EV_Readiness = "Medium";
    else EV_Readiness = "Low";
run;

data D2d_map;
    set D2c;
    Country_ID = upcase(Country);
    if Country_ID = 'CZECHIA' then Country_ID = 'CZECH REPUBLIC';
    if Country_ID = 'SLOVAKIA' then Country_ID = 'SLOVAK REPUBLIC';

   if Composite_Score < -0.75 then Level_Group = 1;
else if Composite_Score < -0.55 then Level_Group = 2;
else if Composite_Score < -0.35 then Level_Group = 3;
else if Composite_Score < -0.10 then Level_Group = 4;
else if Composite_Score <  0.20 then Level_Group = 5;
else if Composite_Score <  0.5 then Level_Group = 6;
else if Composite_Score <=  0.70 then Level_Group = 7;
else if 1.00 <= Composite_Score < 1.50 then Level_Group = 8;
else Level_Group = 9;                                 
run;

proc sort data=D2d_map out=D2d_srt;
    by descending Composite_Score;
run;

proc print data=D2d_srt noobs label;
    var Country BEV_market_share Charging_Index_per_1000_km2 Clean_Energy_Share Composite_Score EV_Readiness;
    label
        BEV_market_share = "BEV Share Score"
        Charging_Index_per_1000_km2 = "Charging Index Score"
        Clean_Energy_Share = "Clean Electricity Share Score"
        Composite_Score = "Composite Score"
        EV_Readiness = "EV Readiness Level";
    title "D3 Countries Grouped by EV Readiness";
run;

pattern1 v=s c=darkred;
pattern2 v=s c=red;
pattern3 v=s c=orange;
pattern4 v=s c=yellow;
pattern5 v=s c=yellowgreen;
pattern6 v=s c=limegreen;
pattern7 v=s c=mediumseagreen;
pattern8 v=s c=seagreen;
pattern9 v=s c=forestgreen;

*Bar Chart of Composite Scores;
proc gchart data=D2d_srt;
    format Composite_Score 6.2;
    hbar Country / sumvar=Composite_Score descending
        discrete
        subgroup=Level_Group
        patternid=subgroup
        space=1
        maxis=axis1
        raxis=axis2
        autoref cref=graydd;
    label Composite_Score = "Composite Score (Standardized)";
    title "D3 Composite EV Ecosystem Score";
run;
quit;

* Map with same color scale;
data europemap;
    set mapsgfk.europe;
    Country_ID = upcase(idname);
run;

proc gmap data=D2d_map map=europemap all;
    id Country_ID;
    choro Level_Group / levels=9;
    title "D3 EV Ecosystem Composite Score";
run;
