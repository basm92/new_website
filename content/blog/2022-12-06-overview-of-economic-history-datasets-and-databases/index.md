---
title: Overview of Economics Datasets and Databases
author: 'Bas Machielsen'
date: '2022-12-06'
slug: []
categories: []
tags: []
layout: single
excerpt: "In this post, I give an overview and short description of various commonly-used and mostly publicly available data sources in Economics and Economic History."
---


## Introduction

In this post, I'll give an overview and short description of various commonly-used and mostly publicly available data sources in Economic History. I am planning to update this repository as soon as I find new data sources, so if you find something is missing or if you have any suggestions, please contact me or write a comment below! Thanks to Giacomo Domini and Ruben Peeters for suggesting several of these sources. Here's the current overview:

1. [World Values Survey](#world-values-survey)
2. [Demographics and Health Survey](#demographics-and-health-survey)
3. [Global Climate Database](#global-climate-database)
4. [Global Agro-Ecological Zones](#global-agro-ecological-zones)
5. [GISS Surface Temperature Data](#giss-surface-temperature-data)
4. [National Centers for Environmental Information](#national-centers-for-environmental-information)
4. [Clio Infra](#clio-infra)
5. [Scholarly Measures of Politics](#scholarly-measures-of-politics)
6. [Correlates of War](#correlates-of-war)
7. [Eurostat](#eurostat)
9. [Pew Polls](#pew-polls)
10. [Political Protests](#political-protests)
11. [IISG Datasets](#iisg-datasets)
12. [D-place](#d-place)
13. [Labor conflicts](#labor-conflicts)
14. [World Bank, IMF, PWT](#world-bank-imf-pwt)
15. [UCDP Conflict Data](#ucdp-conflict-data)
16. [Regional GDP](#regional-gdp)
17. [EH.net Repository](#eh.net-repository)
18. [Macrohistory Database](#macrohistory-database)
19. [OECD Database](#oecd-database)
20. [World Economic History Datasets](#world-economic-history-datasets)
21. [International Conflict Research Databases](#international-conflict-research-databases)
22. [Soviet Historical Census](#soviet-historical-census)
23. [Global Preferences Survey](#global-preferences-survey)
24. [Global Gallup Datasets](#global-gallup-datasets)
25. [Comparative Political Dataset](#comparative-political-datasets)
26. [World Inequality Database](#world-inequality-database)
27. [COMTRADE](#comtrade)
28. [Observatory of Economic Complexity](#observatory-of-economic-complexity)
29. [Atlas of Economic Complexity](#atlas-of-economic-complexity)
30. [Ricardo Database](#ricardo-database)
31. [Federico-Tena World Trade Historical Database](#federico-tena-world-trade-historical-database)
32. [GRIP Global Roads Database](#grip-global-roads-database)
33. [Statistical Agencies, Parliaments](#statistical-agencies-parliaments)
34. [GIS Databases](#historical-gis-databases)
35. [Municipal Data](#municipal-data)
36. [R Spatial Data Packages](#r-spatial-data-packages)
37. [Other Data Packages](#other-data-packages)
38. [Regional GDP and HDI](#regional-gdp-and-hdi)
39. [Linguistic Data](#linguistic-data)
40. [Mining Production](#mining-production)
41. [Gridded Data Collection GRID PRIO](#gridded-data-collection-grid-prio)
42. [Gridded Population](#gridded-population)
43. [Road Networks](#road-networks)
44. [Biodiversity](#biodiversity)
45. [EEA Geospatial Data Catalogue](#eea-geospatial-data-catalogue)
46. [Cartes Historiques](#cartes-historiques)

## World Values Survey

Available at [https://www.worldvaluessurvey.org](https://www.worldvaluessurvey.org). The data contains geographically coded outcomes for individual surveys on a broad range of questions related to values. The latest wave is available [here](https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp) and can be downloaded in various formats. 

## Demographics and Health Survey

Available at [https://dhsprogram.com/data](https://dhsprogram.com/data). This is also geographically coded data and contains information on characteristics of the household population, and their dwelling conditions, as well as describing eligible respondents and indicators of women's status and their situation, on fertility, fertility preferences, determinants of fertility, family planning, childhood mortality, maternal and child health and nutrition, and diseases. The survey is effectuated in a great number of African, Central Asian, Asian and Latin American countries, as well as some European and Oceanian ones. You need to make a (free) account to access the data. 

## Global Climate Database

A website containing climate data for the world on a number of spatial frequencies from 1970 to 2000. Available at [http://www.worldclim.org/](http://www.worldclim.org/). 

## Global Agro-Ecological Zones

The Food and Agriculture Organization of the United Nations (FAO) and the International Institute for Applied Systems Analysis (IIASA) have cooperated over several decades to develop and implement the Agro-Ecological Zones (AEZ) modelling framework and databases. AEZ relies on well-established land evaluation principles to assess natural resources for finding suitable agricultural land utilization options. It identifies resource limitations and opportunities based on plant eco-physiological characteristics, climatic and edaphic requirements of crops and it uses these to evaluate suitability and production potentials for individual crop types under specific input and management conditions. Available [here](https://gaez.fao.org/)

## GISS Surface Temperature Data

The GISS Surface Temperature Analysis version 4 (GISTEMP v4) is an estimate of global surface temperature change. Graphs and tables are updated around the middle of every month using current data files from NOAA GHCN v4 (meteorological stations) and ERSST v5 (ocean areas). Available [here](https://data.giss.nasa.gov/gistemp/). 

## National Centers for Environmental Information

Another website containing historical (from 1763) to present climate information. Available at [https://www.ncei.noaa.gov/access/search/index](https://www.ncei.noaa.gov/access/search/index). Updates are applied daily. An example dataset can be found [here](https://www.ncei.noaa.gov/metadata/geoportal/rest/metadata/item/gov.noaa.ncdc:C00946/html). 

## Clio Infra

A repository of various economic history datasets assembled by various researchers in the discipline. It is available at [http://clio-infra.eu](http://clio-infra.eu). I also created an R package to access these data, available [here](www.github.com/basm92/Clio). 

## Scholarly Measures of Politics

This is not a database, but rather an R package that aggregates some widely used datasets. It is available at [https://github.com/xmarquez/democracyData](https://github.com/xmarquez/democracyData). You can use it to access some widely used datasets, including Polity5, Freedom House, Geddes, Wright, and Frantz’ autocratic regimes dataset, the Lexical Index of Electoral Democracy, the DD/ACLP/PACL/CGV dataset, the main indexes of the V-Dem dataset, and many others. The datasets can be looked at by running `democracyData::democracy_info` inside R. 

## Correlates of War 

Various datasets related to war, alliances and other geopolitical measures can be downloaded at [https://correlatesofwar.org/data-sets/](https://correlatesofwar.org/data-sets/). [Here](https://rforpoliticalscience.com/2020/06/03/add-correlates-of-war-codes-in-r-with-countrycode-package/) is also a short tutorial on how to harmonize country codes. This dataset is also available in the `peacesciencer` package in R. This, in turn, is available [here](https://rdrr.io/cran/peacesciencer). 

## Eurostat

European statistical agency: contains a lot of demographic, economic and other indicators at different levels (country, region, municipality). Available at [https://ec.europa.eu/eurostat/web/main/data/database](https://ec.europa.eu/eurostat/web/main/data/database). There is also an unofficial R package which you can use to access most of the data. A tutorial is available [here](https://ropengov.github.io/eurostat/articles/eurostat_tutorial.html). 

## Pew polls

Pew Research Center makes most of its survey data available for free online at [https://www.pewresearch.org/tools-and-resources/](https://www.pewresearch.org/tools-and-resources/). Then, one can download datasetes by research area. This includes datasets from the annual Global Attitudes Survey, a poll that asks adults in many countries about issues ranging from politics to economic conditions. [Here](https://medium.com/pew-research-center-decoded/analyzing-international-survey-data-with-the-pewmethods-r-package-3b0b21cba607) is a blog providing a short introduction to the data. 

## Political Protests

[ACLED](https://acleddata.com) provides data on political protests. You need to make a (free) account to access the data. This can be done by clicking the Register link at the bottom of the page (somewhat hidden). 

In addition, there are datasets on a per-country basis available [here](https://data.world/datasets/protests). You also need an account for that. 

## IISG Datasets

The Dutch _International Institute of Social History_ has a [data repository](https://iisg.amsterdam/en/data/datasets) containing a wide-array of (arguably) very specific datasets, coming from a large number of countries. One potentially interesting dataset here is the RISTAT (РИСТАТ) project, containing lots of historical statistical at the Guberniya (province) level in the Russian empire and beyond. These data are available [here](https://ristat.org/). 

## D-Place

D-PLACE is an open-source repository containing many data regarding cultures and environments. The famous Murdock Ethnographic Atlas is also available through this repository. In its own words, it "..is an attempt to bring together the dispersed corpus of information describing human cultural diversity. It aims to make it easy for individuals to contrast their own cultural practices with those of other societies, and to consider the factors that may underlie cultural similarities and differences." It can be accessed [here](https://d-place.org/contributions) and the datasets can be downloaded [here](https://github.com/D-PLACE/dplace-data/tree/master/datasets). There is also an R package as an inferface to this package, downloadable from [https://github.com/matthewgthomas/dplacer](https://github.com/matthewgthomas/dplacer).

## Labor Conflicts

The International Institute of Social History (IISH) has made datasets regarding labor conflicts publicly available. This features datasets for several countries all over the world throughout history. It can be accessed [here](https://datasets.iisg.amsterdam/dataverse/labourconflicts). 

## World Bank, IMF, PWT

The World Bank, IMF and Penn World Tables also contain many variables on the country and sometimes sub-country levels. I assume the reader to be familiar with these data sources, so it suffices to mention the URLs and potentially useful R packages here:

  - World Bank: [Here]() and the R package `wbstats` ([Small tutorial](https://github.com/gshs-ornl/wbstats))
  - IMF: [Here](https://data.imf.org/?sk=388dfa60-1d26-4ade-b505-a05a558d9a42)
  - Penn World Tables: [Here](https://www.rug.nl/ggdc/productivity/pwt/?lang=en), legend inside data file
  
## UCDP Conflict Data

The UCDP data is a repository containing a lot of dataset regarding conflicts, foreign policy, external support, candidate events, dyadic datasets, battle-related deaths and other indicators regarding conflicts. In their own words, "the Uppsala Conflict Data Program (UCDP) is the world’s main provider of data on organized violence and the oldest ongoing data collection project for civil war, with a history of almost 40 years. Its definition of armed conflict has become the global standard of how conflicts are systematically defined and studied. UCDP produces high-quality data, which are systematically collected, have global coverage, are comparable across cases and countries, and have long time series which are updated annually." Some databases are geo-referenced in a very granular way. They can be accessed [here](https://ucdp.uu.se/downloads/index.html). 

## Regional GDP

The [Roses-Wolf](https://cepr.org/node/424487) database contains estimates of regional GDP (NUTS-2 level) for select European countries from about 1900-2015. 

## EH.net Repostiory

The [EH.net repository](https://eh.net/databases/) contains various databases, mostly focused on the United States and finances. There are also a few datasets focusing on the UK. 

## Macrohistory Database

A database ([accessible here](https://www.macrohistory.net/database/)) with rates of returns per asset class per country, and balance sheets for the macroeconomy per country per year. 

## NBER Macrohistory Database

The [NBER Macrohistory Database](https://www.nber.org/research/data/nber-macrohistory-database) contains extensive data set that covers all aspects of the pre-WWI and interwar economies, including production, construction, employment, money, prices, asset market transactions, foreign trade, and government activity. Many series are highly disaggregated, and many exist at the monthly or quarterly frequency.

## OECD Database

The OECD has detailed data on various country-level indicators of OECD countries. For example, there are decomposed measures of social expenditures, globalisation, finance, the environment, ICT, labor, etc. An R package is available [here](https://cran.r-project.org/web/packages/OECD/). [Here](https://github.com/expersso/OECD) is a short readme. In my experience, the package is still a little buggy, which may change in the future. Up until then, it might be best to [just go to the web interface](https://stats.oecd.org/). 

## World Economic History Datasets

Several miscallaneous datasets are available on the [world economic history website](http://www.worldeconomichistory.org/datasets/our-datasets/). Most of the datasets concern China and Indonesia. 

## International Conflict Research Databases

The ICR Databses, set up by researchers from UTH Zurich, have assembled many extensive datasets concerning ethnic and linguistic groups all over the world. Here I list a couple of these and give a short description:

  - Greg (Geo-Referencing of Ethnic Groups): [https://icr.ethz.ch/data/greg/](https://icr.ethz.ch/data/greg/). Contains information based on the Soviet Atlas Narodov Mira, and supplemented by ETH Zurich researchers. 
  - Geo-Epr: [https://icr.ethz.ch/data/epr/geoepr/](https://icr.ethz.ch/data/epr/geoepr/). Similar to Greg, but slightly more condensed. Contains only groups that are relevant for ethnic power relations. 
  - C-shapes: [https://icr.ethz.ch/data/cshapes/](https://icr.ethz.ch/data/cshapes/). Maps the borders and capitals as they shift over more than a century, from 1886 to 2019. Also directly accessible via R: `install.packages("cshapes", dependencies = TRUE)`. 
  - Side: [https://icr.ethz.ch/data/side/](https://icr.ethz.ch/data/side/)The Spatially Interpolated Data on Ethnicity (SIDE) dataset is a collection of 253 near-continuous maps of local ethno-linguistic, religious, and ethno-religious settlement patterns in 47 low- and middle-income countries. These data are a generalization of ethnicity-related information in the geo-coded Demographic and Health Surveys (DHS). There is also an R package, see the web page for details. 
  - Grow (Geographical Research On War): [https://growup.ethz.ch/](https://growup.ethz.ch/). Data that can be linked with the geographical data above. This data contains several sets of variables about Conflict Data (UCDP ACD, ACD2EPR), Group Hierarchy Data, Settlement Area Data (GeoEPR variables), Raster Aggregated Data (GRUMPv1 Population, DMSP Stable Nightlights, G-ECON GCP, GTOPO30 Elevation), Transnational Ethnic Kin (TEK) Data, and Ethnic Dimensions Data. 
  - Ethnic Power Relations: [https://icr.ethz.ch/data/epr/](https://icr.ethz.ch/data/epr/). A family of datasets all related to conflict, civil wars and ethnic and ethnolinguistic cleavages. 
  
## Soviet Historical Census

A collection of historical Soviet censuses (including other republics than the RSFSR), decomposed in a number of ways, including ethnicity, on a region-level. Available [here (Russian)](http://www.demoscope.ru/weekly/ssp/census.php). 

## Global Preferences Survey

A survey containing individual and country-level data on economic, risk and social preferences based on the 2018 QJE Article "Global evidence on economic preferences". Available [here](https://www.briq-institute.org/global-preferences/downloads). A short registration is required before the data can be accessed. 

## Global Gallup Datasets

Gallup has a couple of global datasets, sometimes geographically coded, on a number of topics, including risk, finance, food security, and urbanisation. Available [here](https://www.gallup.com/analytics/318923/world-poll-public-datasets.aspx). 

## Comparitive Political Dataset

The "Comparative Political Data Set" (CPDS) is a collection of political and institutional country-level data provided by Klaus Armingeon, Sarah Engler and Lucas Leemann at the University of Zurich (Switzerland) and the Leuphana Universität (Germany). It contains data on the nature of governments and elections, and when which government was in power. Available [here](https://www.cpds-data.org). 

## World Inequality Database

Data on income and wealth inequality throughout the ages for various countries. Available [here](https://wid.world/). 

## COMTRADE

The United Nations Comtrade database aggregates detailed global annual and monthly trade statistics by product and trading partner for use by governments, academia, research institutes, and enterprises. Data compiled by the United Nations Statistics Division covers approximately 200 countries and represents more than 99% of the world's merchandise trade. Available using various API tools as well as [here](https://comtrade.un.org). 

## Observatory of Economic Complexity

Based on COMTRADE data, available [here](https://oec.world/). Unfortunately no longer free. 

## Atlas of Economic Complexity

The Atlas of Economic Complexity is an award-winning data visualization tool that allows people to explore global trade flows across markets, track these dynamics over time and discover new growth opportunities for every country. Available [here](https://atlas.cid.harvard.edu). 

## Ricardo Database

The RICardo project is a comprehensive trade database that collects total and bilateral trade statistics of all countries in the world from the early nineteenth century (first data go back to 1787) until 1938. Available [here](http://ricardo.medialab.sciences-po.fr). 

## Federico-Tena World Trade Historical Database

A database which contains annual series of trade by politics from 1800 to 1938 which sum up as series for continent and world. Available [here](https://www.uc3m.es/ss/Satellite/UC3MInstitucional/es/TextoMixta/1371246237481/Federico-Tena_World_Trade_Historical_Database). 

## GRIP Global Roads Database

A database with vector and raster shapefiles detailing all global roads, accessible [here](https://www.globio.info/download-grip-dataset). 

## Statistical Agencies, Parliaments

This entry should serve as a repository for databases detailing countries, the data portal of their statistical agency (and package), and the data portal of their parliament, and other open data portals.

|Country | Description | Link |
| --- | ---| --- |
|Netherlands | CBS Statistics Data Portal | [R Package](https://cran.r-project.org/web/packages/cbsodataR/index.html), [Python package](https://pypi.org/project/cbsodata/), [Documentation](https://www.cbs.nl/en-gb/our-services/open-data/statline-as-open-data/quick-start-guide) |
| Kazakhstan | Open Data Portal | [Link](https://data.egov.kz/) |
| Spain | Spanish Electoral Archive | [Link](https://dataverse.harvard.edu/dataverse/SEA) |

## Historical GIS Databases

This entry should serve as a repository for historical GIS databases. To be updated more extensively. 

|Country | Description | Link |
| ---| --- | --- |
| Netherlands | Netherlands Historical Municipalities (1812-2020) | [Link](https://datasets.iisg.amsterdam/dataset.xhtml?persistentId=hdl:10622/URI8O2) |
| France | France Administrative Divisions, Other Divisions (1870-1940) | [Link](https://www.data.gouv.fr/fr/datasets/systeme-dinformation-geographique-de-la-france-de-la-troisieme-republique-1870-1940/#resources) |
| Russia | Russian Empire (1897), Guberniya and District Boundaries | [Link](https://datasets.iisg.amsterdam/dataset.xhtml?persistentId=hdl:10622/DN9QDM) |
| Germany | Various Territorial Entities, Various Levels | [Link](http://www.digihist.de/html/hgisg/index.htm) |
| China | Various snapshots (1820-1990) of historical China | [Link](https://chgis.fairbank.fas.harvard.edu/) |
| Austro-Hungarian Empire | Including some German principalities, from abt. 1850 to WWI | [Link](https://histogis.acdh.oeaw.ac.at/shapes/sources/) |

There are also several other sources on the [Historical GIS Network Website](http://hgis.org.uk/resources.htm), but most of the links are defunct. 

## Municipal Data

https://www.insee.fr/fr/statistiques?debut=0&categorie=3

| Country | Description | Link |
| --- | ---| --- |
| France | Municipal (_Commune_) Statistics | [Link](https://statistiques-locales.insee.fr/#c=home) |
| France | INSEE (Communal/Regional) Statistics | [Link](https://www.insee.fr/fr/statistiques?debut=0&categorie=3) |
| Germany | Statistikportal Deutschland | [Link](https://www.statistikportal.de/de/datenbanken) |
| Germany | Regionaldatenbank Deutschland | [Link](https://www.regionalstatistik.de/genesis/online/) |
| Germany | Forschungsdatenzentrum | [Link](https://www.forschungsdatenzentrum.de) |
| Netherlands | Waar Staat Je Gemeente | [Link](https://www.waarstaatjegemeente.nl/jive) |
| Netherlands | Volkstellingen (Censuses) | [Link](http://www.volkstellingen.nl/) |
| Netherlands | Historical Database of Dutch Municipalities | [Link](https://datasets.iisg.amsterdam/dataverse/HDNG?q=&types=dataverses%3Adatasets&sort=dateSort&order=desc&page=1) | 
| Spain | Instituto Nacional de Estadistica | [Link](https://www.ine.es/en/index.htm) |
| Spain | Historical Municipalities Database | [Paper](https://www.ehvalencia.es/wp-content/uploads/2023/05/DT_EHV_2023_01.pdf) and [E-mail](ehvalencia@uv.es) (Chapter 4 in the Paper) 
| Austria | Ein Blick auf die Gemeinde | [Link](https://www.statistik.at/blickgem/index) |
| Belgium | Statbel | [Link](https://statbel.fgov.be/fr/open-data)


**Netherlands:** You can also access to miscellaneous datasets from CBS Open Data in the following way:

```{r eval = FALSE}
library(cbsodataR)

toc <- cbsodataR::cbs_get_toc()
gem_dat <- toc |> filter(stringr::str_detect(Title, 'gemeente')) 
```


## R Spatial Data Packages

- Based on [Moraga (2022)](https://www.paulamoraga.com/book-spatial/r-packages-to-download-open-spatial-data.html):
  - The `giscoR` package contains open data at the country (or lower) level for **European Union countries**
  - The `geodata` package contains **climate data** (temperature, precipitation, wind speed) across time: in particular through the `worldclim_country()` function
  - The package `chirps` contains daily high-resolution **precipitation**, as well as daily maximum and minimum temperatures from the Climate Hazards Group database.
  - The `elevatr` package can download **elevation data** from Amazon Web Services (AWS) Terrain Tiles and OpenTopography Global Digital Elevation Models API. Through the `get_elev_raster()` function, it can be used to download elevation at the locations specified in argument locations and with a zoom specified in argument `z`
  - `osmdata` allows you to download data from **OpenStreetMap**. OpenStreetMap (OSM) is an open world geographic database updated and maintained by a community of volunteers. We can use the osmdata package (Padgham et al. 2023) to retrieve OSM data including rivers roads, shops, railway stations, and other buildings.  
  - The `rWBclimate` data [available here](https://github.com/ropensci/rWBclimate) provides access to three different classes of climate data at two different spatial scales. 
- The `spocc` package is an interface to many species occurrence data sources including Global Biodiversity Information Facility (GBIF)
  - The `wopr` package provides access to the WorldPop Open Population Repository and provides estimates of population sizes for specific geographic areas
  - The `rdhs` package gives the users the ability to access and analyze the (geocoded) Demographic and Health Survey (DHS) data. 
  - The `openair` package contains air quality data and other atmospheric composition data.
  - The `malariaAtlas` package can be used to download global malaria data hosted by the Malaria Atlas Project.
  - The `GAEZr` package ([Installable here](https://floswald.github.io/GAEZr/)) facilitate downloading and processing of Global Agro-Ecological Zones data in R
  - The `rnaturalearth` package makes mapping easy by making natural earth map data from [Natural Earth Data](https://www.naturalearthdata.com/) available
  - The `rWBclimate` package ([here](https://github.com/ropensci/rWBclimate)) is an R interface for the World Bank climate data used in the World Bank climate knowledge portal.
  - The `climate` package automatizes downloading of in-situ meteorological and hydrological data from publicly available repositories

## Other Data Packages

- `ipumsr` - A package port to the IPUMS database: IPUMS is the world’s largest publicly available population database, providing census and survey data from around the world integrated across time and space. An overview is available [here](https://tech.popdata.org/ipumsr/index.html)
- `eurostat` R package: A port to [Eurostat](https://ec.europa.eu/eurostat/web/main/data/database). This is a database about European countries on aggregate (country) and more disaggregated levels
- `idbr`: Instational Data Base package: access to the US Census Bureau's International Data Base (IDB) API, and returns queries as R data frames. The IDB includes historical demographic data, current population estimates, and demographic projections to 2100 for countries of population 5,000 or greater that are recognized by the US Department of State
- `pewdata`: A package helping to download Pew polls data sets. 
- `glottospace`: A package allowing for geospatial analysis of linguistic data. Contains a lot of linguistic data. See [here](https://github.com/glottospace/glottospace) for documentation and examples. 
- `lingtypology`: The lingtypology package connects R with the Glottolog database (v. 4.8) and provides an additional functionality for linguistic typology. The Glottolog database contains a catalogue of the world’s languages. More documentation [here](https://ropensci.github.io/lingtypology/index.html)
- `WDI`: The WDI package allows users to search and download data from over 40 datasets hosted by the World Bank, including the World Development Indicators ('WDI'), International Debt Statistics, Doing Business, Human Capital Index, and Sub-national Poverty indicators. Available [here](https://github.com/vincentarelbundock/WDI)
- `countrycode`: countrycode standardizes country names, converts them into ~40 different coding schemes, and assigns region descriptors. Available [here](https://github.com/vincentarelbundock/countrycode)
- `dplacer`: An R package to the [D-Place](https://d-place.org/) database, with cultural and linguistic data including the Murdock ethnographic atlas available [here](https://github.com/matthewgthomas/dplacer)
- `owidR`: This package acts as an interface to Our World in Data datasets, allowing for an easy way to search through data used in over 3,000 charts and load them into the R environment. Available [here](https://github.com/piersyork/owidR)

## Regional GDP and HDI

Kummu et al. (Nature, 2018) present gap-filled multiannual datasets in gridded form for Gross Domestic Product (GDP) and Human Development Index (HDI). To provide a consistent product over time and space, the sub-national data were only used indirectly, scaling the reported national value and thus, remaining representative of the official statistics. This resulted in annual gridded datasets for GDP per capita (PPP), total GDP (PPP), and HDI, for the whole world at 5 arc-min resolution for the 25-year period of 1990–2015. Additionally, total GDP (PPP) is provided with 30 arc-sec resolution for three time steps (1990, 2000, 2015). Available [here](https://datadryad.org/stash/dataset/doi:10.5061/dryad.dk1j0).

Also, DOSE is a substantially extended version of DOSE – the MCC-PIK Database Of Sub-national Economic Output. DOSE v2 contains harmonised data on reported economic output for:
  - 1,661 sub-national regions
  - across 83 countries
  - from 1953 to 2020
  - with sectoral detail for the agricultural, manufacturing and services sectors.
  
Available [here](https://zenodo.org/records/7573249)

## Linguistic Data

- [WorldGeoDatasets](https://worldgeodatasets.com/language/)
- [Ethnologue](https://www.ethnologue.com/)
- [InfoPlease on basis of CIA world factbook](https://www.infoplease.com/countries/languages-spoken-in-each-country-of-the-world)
- [CIA World Factbook](https://www.cia.gov/the-world-factbook/field/languages/)

## Mining Production

While the extraction of natural resources has been well documented and analysed at the national level, production trends at the level of individual mines are more difficult to uncover, mainly due to poor availability of mining data with sub-national detail. In this paper, we contribute to filling this gap by presenting an open database on global coal and metal mine production on the level of individual mines. It is based on manually gathered information from more than 1900 freely available reports of mining companies, where every data point is linked to its source document, ensuring full transparency. The database covers 1171 individual mines and reports mine-level production for 80 different materials in the period 2000–2021. Available [here](https://www.nature.com/articles/s41597-023-01965-y). 

## Gridded Data Collection GRID PRIO

A whole host of gridded datasets, including nightlights, is available [here](https://grid.prio.org/#/download). The data come in .csv format. These need a grid reference file, which is also available somewhere on the website. Also available through: `devtools::install_github("prio-data/priogrid")`. The actual shapefile which allows you to combine these data is on [this page](https://grid.prio.org/#/extensions).

## Gridded Population

- [Gridded Population of the World](https://cmr.earthdata.nasa.gov/search/concepts/C1597159135-SEDAC.html)
- [Gridded Population of the Netherlands](https://www.pdok.nl/introductie/-/article/cbs-bevolkingsspreiding-population-distribution-)

## Road Networks

An overview of road networks per country:

| Country | Description | Link |
| --- | ---| --- |
| France | ROUTE 500 | [Link](https://transport.data.gouv.fr/datasets/route-500) |
| France | Medieval Road Network | [Link](http://www.medievalfrenchroads.org/map/) |
| Netherlands | Nationaal Wegen Bestand | [Link](https://www.pdok.nl/introductie/-/article/nationaal-wegen-bestand-nwb-wegen) |

## Biodiversity

- [Biodiversitymapping.org](https://biodiversitymapping.org/index.php/download/) has several GIS biodiversity shapefiles. 
- [European Biodiversity Data](https://sdi.eea.europa.eu/catalogue/biodiversity/eng/catalog.search#/home)


## EEA Geospatial Data Catalogue

- Available [here](https://sdi.eea.europa.eu/catalogue/srv/eng/catalog.search#/home)
  - Among which is the [Urban Atlas](https://sdi.eea.europa.eu/catalogue/srv/eng/catalog.search#/metadata/fb4dffa1-6ceb-4cc0-8372-1ed354c285e6)
  - And the [ESRI Land Cover Data](https://livingatlas.arcgis.com/landcoverexplorer/#mapCenter=6.02500%2C52.37100%2C8&mode=step&timeExtent=2017%2C2022&year=2017)
  - And the [CORINE Land Cover Data](https://land.copernicus.eu/en/products/corine-land-cover)
  - Which in turn comes from the [Copernicus Database](https://land.copernicus.eu/en/products)
  
## Cartes Historiques

- [A website](https://cartonumerique.blogspot.com/p/cartes-historiques.html) detailing an overview and redirections to repositories with various historical shapefiles

