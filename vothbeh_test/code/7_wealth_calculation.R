# wealth_calculation
## two ways, one constant shares (rebalancing) other variable shares dictated by time
# https://www.macrohistory.net/database/ 
# documentation > Main Data - then on page 6 and 7 contain the definitions 
library(tidyverse)

roroe <- readxl::read_xlsx('./vothbeh_test/data/roroe/rateofreturnoneveryting_data.xlsx', sheet=2)
data <- read_csv2('./vothbeh_test/data/voting/voting_b1_dis_elec.csv')
wealth <- read_delim("./vothbeh_test/data/wealth/wealth_politicians.csv") |> 
  distinct()

#merge data with wealth
data <- data |> 
  left_join(wealth, by = c('b1_nummer'='indexnummer'))


# make a foreign portfolio
weights_20 <- c("DEU", "FRA")
weights_10 <- c("BEL", "USA", "GBR", "ITA")
weights_2 <- c("AUS", "CAN", "DNK", "FIN", "JPN", "NOR", "PRT", "ESP", "SWE", "CHE")
countries <- c(weights_20, weights_10, weights_2)

# variables: govt bond rate, housing rental return (re), long term interest rate (duprbo, foprbo)
# nominal equity return (dush, fosh), safe return (last var for missing data and misc)
# long term interest rate also for debt
deflator <- readxl::read_xlsx("./vothbeh_test/data/roroe/rateofreturnoneveryting_data.xlsx", sheet = "Data") |>
  filter(iso == "NLD") |> 
  select(year, cpi) |>
  mutate(cpi_1900 = (cpi / 5.817804))

roroe <- readxl::read_xlsx("./vothbeh_test/data/roroe/rateofreturnoneveryting_data.xlsx", sheet = "Data") |>
  mutate(eq_tr = coalesce(eq_tr, safe_tr)) |>
  select(year, country, iso, bond_rate, housing_rent_rtn, ltrate, eq_tr, safe_tr) |>
  filter(is.element(iso, c(countries, "NLD")))

# create dutch returns
dutch <- roroe |> 
  filter(iso == "NLD")  |>
  mutate(across(c(bond_rate:safe_tr), ~ replace_na(.x, 0)))

# create foreign returns
foreign <- roroe |>
  filter(iso != "NLD") |>
  select(-country) |> 
  mutate(weight = case_when(
    is.element(iso, weights_20) ~ 0.2,
    is.element(iso, weights_10) ~ 0.1,
    is.element(iso, weights_2) ~ 0.02)) |>
  mutate(across(c(bond_rate:safe_tr), ~ .x * weight)) |> 
  group_by(year) |> 
  summarise(bond_rate = sum(bond_rate, na.rm = TRUE),
            housing_rent_rtn = sum(housing_rent_rtn, na.rm = TRUE),
            ltrate = sum(ltrate, na.rm = TRUE),
            eq_tr = sum(eq_tr, na.rm = TRUE),
            safe_tr = sum(safe_tr, na.rm = TRUE))

# calculate back and deflate assets function
## deflate cash, misc and debt with cpi
## this implements dynamic portfolio shares
calculate_back_deflate_assets <- function(row){
  re <- row$re
  dush <- row$dush
  dugobo <- row$dugobo
  duprbo <- row$duprbo
  fogobo <- row$fogobo
  foprbo <- row$foprbo
  fosh <- row$fosh
  cash <- row$cash
  misc <- row$misc
  debt <- row$debt
  
  vote_year <- row$date |> year()
  death_year <- row$death_date |> year()
  
  dp <- dutch |> 
    filter(year <= death_year, year >= vote_year) |> 
    summarize(re_back = exp(-sum(housing_rent_rtn)) * re,
              dugobo_back = exp(-sum(safe_tr))*dugobo,
              duprbo_back = exp(-sum(ltrate/100))*duprbo, 
              dush_back = exp(-sum(eq_tr))*dush,
              misc_back = exp(-sum(safe_tr))*misc,
              cash_back = exp(-sum(safe_tr))*cash,
              debt_back = exp(-sum(safe_tr))*-debt) |>
    rowwise() |> 
    summarize(dutch_part = sum(across(re_back:cash_back)) - debt_back) |>
    pull(dutch_part)
  
  fp <- foreign |> 
    filter(year <= death_year, year >= vote_year) |> 
    summarize(fogobo_back = exp(-sum(safe_tr))*fogobo,
              foprbo_back = exp(-sum(ltrate/100))*foprbo, 
              fosh_back = exp(-sum(eq_tr))*fosh) |>
    rowwise() |> 
    summarize(foreign_part = sum(across(everything()))) |> 
    pull(foreign_part)
  
  #nominal wealth in vote year
  nom <- fp + dp
  
  # deflated wealth
  def <- deflator |> 
    filter(year == vote_year) |> 
    summarize(wealth_defl = nom / cpi_1900)
  
  return(def)
}

# this works perfectly
test <- data |> 
  rowwise() |> 
  mutate(defw = list(calculate_back_deflate_assets(cur_data())))


# now, implement with constant rebalancing
