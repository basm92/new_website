# add strikes
library(tidyverse); library(Hmisc)

data <- read_csv2('./vothbeh_test/data/voting/vot_beh_wealth_instr.csv')
# strikes url
#download.file("https://datasets.iisg.amsterdam/api/access/datafile/9841",
#              destfile = "./data/strikes/strikes.mdb")

data_strikes <- Hmisc::mdb.get('./vothbeh_test/data/strikes/strikes.mdb')
strikes <- data_strikes$tblActies
places <- data_strikes$tblPlaats |>
  mutate(ID = as.integer(ID)) |> 
  select(ID, PLAATS, Amsterdam.Code)
place_key <- data_strikes$tblActies_Plaats

# filter strikes within reasonable years
strikes_db <- strikes |> 
  as_tibble() |>
  left_join(place_key, by = c("ID" = "ActieID")) |> 
  filter(between(JAAR, 1850, 1950)) |> 
  left_join(places, by = c("PlaatsID" = "ID"))

#find an overview of number of strikes per year
strikes_db <- strikes_db |> 
  group_by(Amsterdam.Code, JAAR) |> 
  count()

# tomorrow: retrieve the municipality-mapping and incorporate the strikes in year-1