---
title: Overview of Economic History Datasets and Databases
author: 'Bas Machielsen'
date: '2022-12-06'
slug: []
categories: []
tags: []
layout: single
excerpt: "In this post, I'll give an overview and short description of various commonly-used and mostly publicly available data sources in Economic History."
---


## Introduction

In this post, I'll give an overview and short description of various commonly-used and mostly publicly available data sources in Economic History. I am planning to update this repository as soon as I find new data sources, so if you find something is missing or if you have any suggestions, please contact me or write a comment below! Here's the current overview:

1. [World Values Survey](#world-values-survey)
2. [Demographics and Health Survey](#demographics-and-health-survey)
3. [Global Climate Database](#global-climate-database)
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
15. [Statistical Agencies, Parliaments](#statistical-agencies-parliaments)
16. [GIS Databases](#gis-databases)

## World Values Survey

Available at [https://www.worldvaluessurvey.org](https://www.worldvaluessurvey.org). The data contains geographically coded outcomes for individual surveys on a broad range of questions related to values. The latest wave is available [here](https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp) and can be downloaded in various formats. 

## Demographics and Health Survey

Available at [https://dhsprogram.com/data](https://dhsprogram.com/data). This is also geographically coded data and contains information on characteristics of the household population, and their dwelling conditions, as well as describing eligible respondents and indicators of women's status and their situation, on fertility, fertility preferences, determinants of fertility, family planning, childhood mortality, maternal and child health and nutrition, and diseases. The survey is effectuated in a great number of African, Central Asian, Asian and Latin American countries, as well as some European and Oceanian ones. You need to make a (free) account to access the data. 

## Global Climate Database

A website containing climate data for the world on a number of spatial frequencies from 1970 to 2000. Available at [http://www.worldclim.org/](http://www.worldclim.org/). 

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

## Rates of Return


## EH.net Repostiory

The [EH.net repository](https://eh.net/databases/) contains various databases, mostly focused on the United States and finances. There are also a few datasets focusing on the UK. 

## Macrohistory Database

A database ([accessible here](https://www.macrohistory.net/database/)) with rates of returns per asset class per country, and balance sheets for the macroeconomy per country per year. 

## NBER Macrohistory Database

The [NBER Macrohistory Database](https://www.nber.org/research/data/nber-macrohistory-database) contains extensive data set that covers all aspects of the pre-WWI and interwar economies, including production, construction, employment, money, prices, asset market transactions, foreign trade, and government activity. Many series are highly disaggregated, and many exist at the monthly or quarterly frequency.


## OECD Database

The OECD has detailed data on various country-level indicators of OECD countries. For example, there are decomposed measures of social expenditures, globalisation, finance, the environment, ICT, labor, etc. An R package is available [here](https://cran.r-project.org/web/packages/OECD/). [Here](https://github.com/expersso/OECD) is a short readme. In my experience, the package is still a little buggy, which may change in the future. Up until then, it might be best to [just go to the web interface](https://stats.oecd.org/). 

## Statistical Agencies, Parliaments

This entry should serve as a repository for databases detailing countries, the data portal of their statistical agency (and package), and the data portal of their parliament, and other open data portals.

|Country | Description | Link |
| --- | ---| --- |
|Netherlands | CBS Statistics Data Portal | [R Package](https://cran.r-project.org/web/packages/cbsodataR/index.html), [Python package](https://pypi.org/project/cbsodata/), [Documentation](https://www.cbs.nl/en-gb/our-services/open-data/statline-as-open-data/quick-start-guide) |
| Kazakhstan | Open Data Portal | [Link](https://data.egov.kz/) |

## Historical GIS Databases

This entry should serve as a repository for historical GIS databases. To be updated more extensively. 

|Country | Description | Link |
| ---| --- | --- |
| Netherlands | Netherlands Historical Municipalities (1812-2020) | [Link](https://datasets.iisg.amsterdam/dataset.xhtml?persistentId=hdl:10622/URI8O2) |
| France | France Administrative Divisions, Other Divisions (1870-1940) | [Link](https://www.data.gouv.fr/fr/datasets/systeme-dinformation-geographique-de-la-france-de-la-troisieme-republique-1870-1940/#resources) |
| Russia | Russian Empire (1897), Guberniya and District Boundaries | [Link](https://datasets.iisg.amsterdam/dataset.xhtml?persistentId=hdl:10622/DN9QDM) |
| Germany | Various Territorial Entities, Various Levels | [Link](http://www.digihist.de/html/hgisg/index.htm) |

## To add:

- www.worldeconomichistory.org/datasets/our-datasets/
- NBER Macrohistory database (https://www.nber.org/research/data/nber-macrohistory-database)
- http://hgis.org.uk/resources.htm Historical GIS network
- Ethnic groups of the world (https://icr.ethz.ch/data/greg/) Atlas Narodov Mira
- Cshapes: https://icr.ethz.ch/data/cshapes/
- Side: https://icr.ethz.ch/data/side/
- Ethnic Power Relations: https://icr.ethz.ch/data/epr/
- Grow: Geographical Research on war: https://growup.ethz.ch/
- Soviet (including republics) and Russian censuses: http://www.demoscope.ru/weekly/ssp/census.php
- Global preferences survey: https://www.briq-institute.org/global-preferences/downloads
- Global Gallup Datasets: https://www.gallup.com/analytics/318923/world-poll-public-datasets.aspx
- Comparative Political Dataset: https://www.cpds-data.org/
