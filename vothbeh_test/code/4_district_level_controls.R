library(tidyverse)
hdng <- read_delim('../data/district/HDNG_v4.txt')
# use the district information to match the districts to municipalities
## and given that, find municipality-level variables of interest, and
## aggregate them to the district level

# variables of interest:
## labor force decomposition
## share of distr. in tax rev.
## share of tax-liability indvs. in distr. 
## no. of strikes in year t-1
## religious decomposition, hervormd, gereformeerd, catholic

# step 1: prepare the map between district and hdng:
## merge these to get the district -> gemeentenaam -> amco (hdng identifier) match
dm <- read_delim('../data/district/district_municipality_time_table.csv')
key <- read_delim('../data/district/key_elections_hdng_amco.csv')
mapping <- dm |> left_join(key, by = c('gemeentenaam' = 'name_elections'))

data <- read_delim('../data/voting/voting_behavior_b1_nummer_district.csv')

# step 2: define helpers to find the municipalities, the variables and aggregate

