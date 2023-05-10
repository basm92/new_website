#8_add_iv_variables
library(tidyverse)
data <- read_csv2('./vothbeh_test/data/voting/voth_wealth.csv')

instrumental <- readxl::read_xlsx('./vothbeh_test/data/wealth/instrumental_variable_est.xlsx') 
ihs <- function(x) log(x + sqrt(x^2 + 1))

instrumental <- readxl::read_xlsx('./vothbeh_test/data/wealth/instrumental_variable_est.xlsx') |> 
  select(polid,
         hoeveel_broers_zussen,
         father_profession,
         wealth_father,
         wealth_mother) |> 
  mutate(wealth_father = as.numeric(wealth_father),
         hoeveel_broers_zussen = if_else(!is.na(as.numeric(hoeveel_broers_zussen)), as.numeric(hoeveel_broers_zussen), 0), 
         expected_inheritance_rough = case_when(
    is.na(wealth_father) & !is.na(wealth_mother) ~ wealth_mother*2,
    is.na(wealth_mother) & !is.na(wealth_father) ~ wealth_father*2,
    !is.na(wealth_mother) & !is.na(wealth_father) ~ wealth_father + wealth_mother),
    expected_inheritance_rough = expected_inheritance_rough,
    expected_inheritance = expected_inheritance_rough / (1+hoeveel_broers_zussen)) |>
  mutate(father_politician = if_else(father_profession == "Politicus", 1, 0)) |>
  select(polid, expected_inheritance_rough, expected_inheritance, father_politician) |> 
  distinct(polid, .keep_all = T)


data <- data |> 
  left_join(instrumental, by = c('b1_nummer' = 'polid'))

# write to csv
write_csv2(data, "./vothbeh_test/data/voting/vot_beh_wealth_instr.csv")

