# wealth_calculation
## two ways, one constant shares (rebalancing) other variable shares dictated by time
library(tidyverse)

roroe <- readxl::read_xlsx('../data/roroe/rateofreturnoneveryting_data.xlsx', sheet=2)
data <- read_csv2('../data/voting/voting_b1_dis_elec.csv')
wealth <- read_delim("../data/wealth/wealth_politicians.csv") |> 
  distinct()

#merge data with wealth
data <- data |> 
  left_join(wealth, by = c('b1_nummer'='indexnummer'))

