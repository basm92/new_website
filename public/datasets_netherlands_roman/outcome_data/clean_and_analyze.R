# analyze regression discontinuity roman border
# filter flevoland 
library(tidyverse)
library(sf)
library(rdrobust)
library(janitor)

gem <- read_sf("./static/datasets_netherlands_roman/netherlands_municipalities_distance_roman_border.shp") |>
  mutate(distance = st_distance(st_centroid(gem), boundary),
         running_variable = case_when(include == 1 ~ distance, 
                                      include == 0 ~ -distance, 
                                      TRUE ~ -distance))
boundary <- read_sf("./static/datasets_netherlands_roman/boundary_netherlands_romanempire.shp")

# now import all municipal dataset
bevolking <- read_delim('./static/datasets_netherlands_roman/outcome_data/Bevolking totaal - Gemeenten.csv')
gemraadverk <- read_delim('./static/datasets_netherlands_roman/outcome_data/Gemeenteraad - Opkomst - Gemeenten.csv')
income <- read_delim('./static/datasets_netherlands_roman/outcome_data/Gemiddeld besteedbaar inkomen per huishouden.csv')
poverty <- read_delim('./static/datasets_netherlands_roman/outcome_data/poverty.csv')
crime <- read_delim('./static/datasets_netherlands_roman/outcome_data/Totaal misdrijven - 2012 - Gemeenten.csv')
unemployment <- read_delim('./static/datasets_netherlands_roman/outcome_data/Werkloosheidspercentage - 2003 - Gemeenten.csv')

clean_stuff <- function(df) {
  df |>
  pivot_longer(
    cols = -c("Gemeenten"),
    names_to = 'variable', values_to = 'value') |>
    mutate(year = str_extract(variable, '\\d{4}'),
           variable = str_remove(variable, '\\|\\d{4}')) |>
    pivot_wider(names_from = variable, values_from = value) |>
    janitor::clean_names()
}

gemraadverk <- gemraadverk |>
  mutate(across(everything(), as.character)) |>
  clean_stuff() 

data <- map(list(bevolking, income, poverty, crime, unemployment), clean_stuff)

data_together <- data[[1]] |> left_join(data[[2]]) |> 
  left_join(data[[3]]) |>
  left_join(data[[4]]) |>
  left_join(data[[5]])

exclude <- c("Lelystad", "Almere", "Zeewolde", "Dronten")

data_together <- data_together |>
  left_join(gemraadverk) |>
  mutate(misdrijven_per_hoofd = totaal_misdrijven/bevolking_totaal) |>
  filter(!is.element(gemeenten, exclude))
  


## now merge it together with data.frame
analysis_df <- gem |>
  left_join(data_together,
            by = c('areaname' = 'gemeenten'))

## Bevolking and density
analysis2 <- analysis_df |> 
  filter(year == 2000) |>
  mutate(density = bevolking_totaal/area_large)

rdrobust::rdrobust(y = analysis2$density, 
                   x = analysis2$running_variable, c = 0) |> summary()

rdrobust::rdrobust(y = analysis2$bevolking_totaal, 
                   x = analysis2$running_variable, c = 0) |> summary()

## Income
analysis3 <-analysis_df |>
  filter(year == 2011) |>
  mutate(besteedbaar_inkomen_per_huishouden = 
           parse_number(besteedbaar_inkomen_per_huishouden,
                        locale = locale(decimal_mark = ",")))

rdrobust::rdrobust(y = analysis3$besteedbaar_inkomen_per_huishouden, 
                   x = analysis3$running_variable, c = 0) |> summary()

## Crime
analysis4 <- analysis_df |> filter(!is.na(misdrijven_per_hoofd))

rdrobust::rdrobust(y = analysis4$misdrijven_per_hoofd, 
                   x = analysis4$running_variable, c = 0) |> summary()

## Poverty

analysis5 <- analysis_df |>
  filter(year == 2011) 

rdrobust::rdrobust(y = analysis5$huishoudens_met_inkomen_ten_minste_1_jaar_tot_101_percent_sociaal_minimum,
                   x = analysis5$running_variable, c = 0 ) |> summary()

## Unemployment
analysis6 <- analysis_df |> filter(year == 2003)

rdrobust::rdrobust(y = analysis6$werkloosheidspercentage, 
                   x = analysis6$running_variable, c = 0) |> summary()
