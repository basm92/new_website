---
title: Spatial Merging Roman Roads with Eurostat Data
author: ''
date: '2023-02-15'
slug: []
excerpt: A short blog about the spatial merging of roman roads with contemporary Eurostat data.
categories: []
tags: []
---

## Introduction

In this short blog post, I focus on combining several European municipal (LAU, Local Urban Areas) shapefiles, combined with data on roads and cities in the Roman Empire, to find relationships between present-day outcomes and deep-routed interventions as far as more than 2000 years ago. 

Let us first load the libraries we need to perform operations. 
  

```r
library(tidyverse)
library(giscoR)
library(sf)
library(cawd)
```

For robustness, and out of curiosity, I will use two roads files. One of them is in the `cawd` package, and contains roads that existed at about 200AD:


```r
roads <- cawd::darmc.roman.roads.major.sp |> st_as_sf()
```

```
## Loading required package: sp
```

The other is found [here](http://awmc.unc.edu/awmc/map_data/shapefiles/ba_roads/), which is derived from the _Barrington Atlas of the Greek and Roman World_. 


```r
roads_alt <- read_sf("~/Downloads/shp_roads/ba_roads.shp")
```

I'll also use data on Roman cities, from [here](https://projectmercury.eu/datasets/#cities). 


```r
url <- 'http://oxrep.classics.ox.ac.uk/oxrep/docs/Hanson2016/Hanson2016_Cities_OxREP.csv'
download.file(url, destfile = 'roman_cities.csv')

cities <- read_csv('roman_cities.csv')
```

```
## Rows: 1388 Columns: 12
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (9): Primary Key, Ancient Toponym, Modern Toponym, Province, Country, Ba...
## dbl (3): Start Date, Longitude (X), Latitude (Y)
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

The shapefiles at the LAU level can be downloaded with the help of the `giscoR` package, an interface to the API of Eurostat. Alternatively, it is available [here](https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/lau). Let us first focus on France and Germany, for simplicity. 


```r
lau <- giscoR::gisco_get_lau(year = '2020', country = c("Germany" , "France"))
```

We need to exclude the overseas territories of France. Let us do that: 


```r
xmin <- -10
xmax <- 20
ymin <- 40
ymax <- 80
box <- st_bbox(c(xmin=xmin, xmax=xmax, ymax=ymax, ymin=ymin), crs = st_crs(4326))
square <- st_sf(st_as_sfc(box))

fr_gr <- st_intersection(lau, square) 
```

```
## Warning: attribute variables are assumed to be spatially constant throughout all
## geometries
```





```r
lau |> ggplot() + geom_sf()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

## Merging of different shapefiles

I will focus on a slightly different spatial operation, which is the merging of different shapefiles together. As it is difficult to use the Roman Empire map for this, I will use more contemporary data from the `eurostat` package. 
