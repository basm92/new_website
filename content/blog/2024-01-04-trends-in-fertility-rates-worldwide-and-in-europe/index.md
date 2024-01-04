---
title: Trends in Fertility Rates Worldwide and in Europe
author: 'Bas Machielsen'
date: '2024-01-04'
excerpt: An short analysis hopefully illustrating some facts about worldwide fertility trends.
slug: []
categories: []
tags: []
---
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />

# Introduction

After some discussions I've had with people, I thought it'd be interesting to look at the data to see what trends in fertility rates are visible in a cross-country context. By now, I guess it is well-known that some countries, notably South-Korea and Japan, but also other East Asian countries as well as European countries have been stuck in a very low fertility rate regime (a TFR of about 1, or just slightly higher) for some time, creating demographic problems such as an "inverse population pyramid" which can in turn entail manifold economic costs. I think there are _a lot_ of theories, and by now, also a lot of empirical case studies, out there investigating what influences fertility rates. There is, for example, a [cool recent study](https://www.sciencedirect.com/science/article/pii/S004727272300110X) relating a recent Dutch pension reform to reduced fertility rates. The argument is that reduced, or more expensive, grandparental child care supply causes mothers to substitute away from child-rearing. This is an obvious example of economic incentives being involved in fertility decisions. On the other hand, [this study](https://www.guillaumeblanc.com/files/theme/Blanc_secularization.pdf) argues that secularization is an important driver of fertility rates. It is not clear a priori if and how economic incentives play a role in secularization. There is a good literature review on the economics of fertility [here](https://www.sciencedirect.com/science/article/abs/pii/S2949835X23000034). 

In general, I think people tend to separate _economic_ factors from arguably less tangible _psychological_, _ideological_ or _cultural_ factors influencing fertility. In this blog post, I want to focus on economic determinants, while leaving cultural and ideological out of the picture. Before starting off, I should stress that this analysis is purely correlational, and the point is rather to look at the extent to which economic factors can potentially explain fertility trends, rather than laying bare the exact causal effects of particular factors. 

After some suggestions, I propose to look at the following factors:
  - GDP per capita (PPP), 
  - Female labor force participation (FLFP)
  - Gini coefficient
  - Gross private savings of the country (an indicator of Y-C-G)
  - Broad money supply (M2)
  - Two measures of consumer inflation: one based on the CPI and the other based on housing. 
  
Distinguishing between the last two measures of inflation turned out to be a waste of time, since both inflation measures turned out to be statistically collinear. (In addition, the IMF API is very buggy, and the quality of these measures is unclear).

The reasoning for looking at these factors is roughly as follows: 

GDP per capita: national income means more resources, hence, on the country-level, a country can implement various measures aimed at making child-rearing more attractive. On the other hand, higher productivity means the opportunity costs of child-rearing increase. It is an empirical matter to investigate which ones of these channels might dominate. 

Female labor force participation (FLFP): even though not a real explanatory variable, since likely FLFP and fertility rates are determined simultaneously, FLFP and fertility can be substitutes, but potentially, depending on institutions, also compliments. It would be interesting to look at heterogeneity between countries with different institution to what extent there is evidence for either one of these views. In what follows, FLFP is measured as percentage of the labor force being women.

Gini coefficient: in addition to the national income, if income is distributed very unequally, this might potentially mean large parts of the population might simply not be able to afford to have children. 

Gross private savings: at the individual level, income might not be the primary determinant of child-rearing. Rather, wealth, or a rough proxy in the form of savings, might play a role in this decision, since the financing of child-related expenses might not only come from 

Broad money supply (M2): Conditional on a particular level of output and a CPI, this can be interpreted as some measure of _future_ inflation. It is supposed to negatively affect child supply. 

CPI: The Consumer Price Index (CPI) is generally used as a measure of present inflation. This interpretation is strengthened by conditioning on M2 growth, thereby distinguishing between present and expected future inflation. 

# Method

Because my objective is to make use of variation in the TFR within countries rather than comparing wildly different countries with different institutions with each other, I estimate within-country (fixed effects) regressions, exploiting differences in the TFR within the same country over time. Also, from a policy perspective, it makes sense to look at to what extent these "economic" factors can explain fertility. I therefore also report the within-country `\(R^2\)`. The regression I estimate looks like this:

`$${TFR}_{it} = \alpha_i + \beta_1 \text{GDP/Cap}_{it} + \beta_2 \text{FLFP}_{it} + \beta_3 \text{Gini}_{it} + \beta_4 \text{GrossSavings}_{it} + \beta_5 \text{MoneySupply}_{it} + \beta_6 \text{CPI}_{it} + \epsilon_{it}$$`

For inference, I cluster standard errors at the country level. The `\(TFR\)` is defined as:

`$$\displaystyle \sum_i \frac{\text{No. Births from women aged i}}{\text{No. Women aged i}}$$`

[See here for a toy example](https://getinthepicture.org/sites/default/files/resources/11.%20Total%20fertility%20rates.pdf). It reflects the amount of children per mother over a lifetime. This indicator has the example of being normalized and independent of the current population pyramid structure. It is also the most widely used indicator in the literature. The data come from the World Bank with the exception of the CPI, which comes from the IMF.  

# Data

I make use of a couple of R packages giving direct access to the World Bank and IMF API's:


```r
library(wbstats)
library(fixest)
library(tidyverse)
library(countrycode)
library(imf.data)
library(modelsummary)
```

Then, from the World Bank database, I extract the following indicators, corresponding to the TFR, GDP per Capita (PPP), FLFP, Gini, and Gross Savings: 


```r
#wbstats::wb_search('Total Fertility Rate')
wb <- wbstats::wb_data(c('SP.DYN.TFRT.IN', 
                         'NY.GDP.PCAP.PP.CD',
                         'SL.TLF.TOTL.FE.ZS',
                         'SI.POV.GINI',
                         'NY.GDS.TOTL.CD',
                         'FM.LBL.BMNY.CN'))

wb <- wb |> 
  select(c(1,4:10))
```


From the IMF database, I extract two measures of the CPI, a CPI including everything PCPI_IX, and a CPI based on housing and fuels PCPIH_IX. Because the IMF API is buggy, I'm forced to do this through a for loop over countries, and finding which variable contains repetitions, which is the variable that has to be taken out:


```r
prel <- imf.data::load_datasets('CPI')
countries <- prel$dimensions$ref_area$Value[1:233]
inflation <- list()

for (i in 1:length(countries)) {
  country <- countries[i]
  prel_data <- prel$get_series(freq = 'A',
                               ref_area = country,
                               indicator = 'PCPI_IX')
  # clean it
  if(!is.null(prel_data)){
    # Find which column is the repeated column
    prel_data <- prel_data |>
      janitor::clean_names()
    
    repeated_value_columns <- prel_data %>%
      keep(~ length(unique(.)) == 1) %>%
      names()
    
    out <- prel_data |> 
      select(-all_of(repeated_value_columns)) |>
      rename(time = 1, cpi = 2) |>
      mutate(country = country)
    
    inflation[[i]] <- out
  } 
  else{
    inflation[[i]] <- NULL
  }
}

# Put inflation together
cpi <- inflation |>
  reduce(bind_rows) |> 
  select(time, country, cpi) |>
  mutate(time = as.numeric(time), cpi = as.numeric(cpi))
```

I repeat the same trick for the housing indicator but won't report it for brevity. 

Since I want to investigate heterogeneity according to regions, I'll also use a granular regional classification of countries from the `countrycode` package:


```r
# Get regions classification
regions <- countrycode::codelist |> 
  select(iso2c, region23)
```

Finally, I'll merge these datasets together and give somewhat more clear variable names:


```r
wb <- wb |>
  rename(fert_rate = SP.DYN.TFRT.IN,
         gdp_pp = NY.GDP.PCAP.PP.CD,
         flfp = SL.TLF.TOTL.FE.ZS,
         gini = SI.POV.GINI,
         savings = NY.GDS.TOTL.CD,
         money = FM.LBL.BMNY.CN) |>
  left_join(regions, by = 'iso2c')

data <- wb |>
  left_join(cpi, by = join_by(iso2c == country, date == time))

data_europe <- data |> 
  filter(str_detect(region23, "Europe"))
```

# Analysis

I estimate a couple of regression models. I estimate a model for the world as a whole, for the world with observations starting from 2010, for Europe and for non-Europe. I also want to investigate some heterogeneity within Europe, for example, by contrasting western Europe (focusing on Netherlands, Germany and France) with Eastern Europe (say Russia, Ukraine, Belarus). I drop the money supply from the analysis of Western Europe since it is unavailable:


```r
world <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + log(money) + cpi | iso2c, data = data)
world_2010 <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + log(money) + cpi | iso2c, data = data |> filter(date > 2010))
eur <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + log(money) + cpi | iso2c, data = data_europe)
rest <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + log(money) + cpi | iso2c, data = data |> filter(!str_detect(region23, "Europe")))
# NL, DE, FR
we <- data |> 
  filter(is.element(iso2c, c("NL", "FR", "DE")))

we_mod <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + cpi | iso2c, data = we)

# RF, BY, UA
ee <- data |> 
  filter(is.element(iso2c, c("RU", "BY", "UA")))

ee_mod <- feols(fert_rate ~ log(gdp_pp) + flfp  + gini + log(savings) + log(money) + cpi | iso2c, data = ee)
```

I summarize the results in a table:




```r
modelsummary(list(
  "World" = world,
  "World (after 2010)" = world_2010,
  "Europe" = eur,
  "Rest of World" = rest,
  "NL, DE, FR" = we_mod,
  "RF, UA, BY" = ee_mod),
  title = "Conditional Correlations between a number of Factors and TFR", 
  coef_map = c('log(gdp_pp)' =  "Log GDP/Cap (PPP)",
               "flfp" = "FLFP",
               "gini" = "Gini",
               "log(savings)" = "Log Gross Savings",
               "log(money)" = "Log M2",
               "cpi" = "CPI"),
  gof_map = c('nobs', 'No. Countries', 'r2.within'),
  stars=c("*"=0.1, "**"=0.05, "***"=0.01))
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption><span id="tab:unnamed-chunk-6"></span>Table 1: Conditional Correlations between a number of Factors and TFR</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> World </th>
   <th style="text-align:center;">  World (after 2010) </th>
   <th style="text-align:center;"> Europe </th>
   <th style="text-align:center;"> Rest of World </th>
   <th style="text-align:center;"> NL, DE, FR </th>
   <th style="text-align:center;"> RF, UA, BY </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Log GDP/Cap (PPP) </td>
   <td style="text-align:center;"> 0.103 </td>
   <td style="text-align:center;"> 0.106 </td>
   <td style="text-align:center;"> −0.065 </td>
   <td style="text-align:center;"> −0.050 </td>
   <td style="text-align:center;"> 0.503 </td>
   <td style="text-align:center;"> 0.275 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.119) </td>
   <td style="text-align:center;"> (0.159) </td>
   <td style="text-align:center;"> (0.109) </td>
   <td style="text-align:center;"> (0.182) </td>
   <td style="text-align:center;"> (0.436) </td>
   <td style="text-align:center;"> (0.161) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FLFP </td>
   <td style="text-align:center;"> −0.058*** </td>
   <td style="text-align:center;"> −0.015 </td>
   <td style="text-align:center;"> −0.039** </td>
   <td style="text-align:center;"> −0.045** </td>
   <td style="text-align:center;"> 0.015 </td>
   <td style="text-align:center;"> −0.115* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.017) </td>
   <td style="text-align:center;"> (0.015) </td>
   <td style="text-align:center;"> (0.016) </td>
   <td style="text-align:center;"> (0.020) </td>
   <td style="text-align:center;"> (0.034) </td>
   <td style="text-align:center;"> (0.027) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Gini </td>
   <td style="text-align:center;"> 0.010 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> −0.004 </td>
   <td style="text-align:center;"> 0.015* </td>
   <td style="text-align:center;"> 0.016 </td>
   <td style="text-align:center;"> −0.016** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.007) </td>
   <td style="text-align:center;"> (0.006) </td>
   <td style="text-align:center;"> (0.005) </td>
   <td style="text-align:center;"> (0.009) </td>
   <td style="text-align:center;"> (0.011) </td>
   <td style="text-align:center;"> (0.003) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log Gross Savings </td>
   <td style="text-align:center;"> −0.052 </td>
   <td style="text-align:center;"> −0.004 </td>
   <td style="text-align:center;"> 0.059 </td>
   <td style="text-align:center;"> −0.036 </td>
   <td style="text-align:center;"> 0.104 </td>
   <td style="text-align:center;"> 0.087 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.038) </td>
   <td style="text-align:center;"> (0.028) </td>
   <td style="text-align:center;"> (0.045) </td>
   <td style="text-align:center;"> (0.047) </td>
   <td style="text-align:center;"> (0.184) </td>
   <td style="text-align:center;"> (0.053) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log M2 </td>
   <td style="text-align:center;"> −0.092** </td>
   <td style="text-align:center;"> −0.248*** </td>
   <td style="text-align:center;"> 0.068** </td>
   <td style="text-align:center;"> −0.098* </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.065 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.044) </td>
   <td style="text-align:center;"> (0.063) </td>
   <td style="text-align:center;"> (0.031) </td>
   <td style="text-align:center;"> (0.051) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.030) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CPI </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000* </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> −0.014 </td>
   <td style="text-align:center;"> −0.003** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1.5px">  </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.000) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.000) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.000) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.000) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.007) </td>
   <td style="text-align:center;box-shadow: 0px 1.5px"> (0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 936 </td>
   <td style="text-align:center;"> 506 </td>
   <td style="text-align:center;"> 307 </td>
   <td style="text-align:center;"> 629 </td>
   <td style="text-align:center;"> 75 </td>
   <td style="text-align:center;"> 52 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;"> 0.429 </td>
   <td style="text-align:center;"> 0.273 </td>
   <td style="text-align:center;"> 0.172 </td>
   <td style="text-align:center;"> 0.537 </td>
   <td style="text-align:center;"> 0.507 </td>
   <td style="text-align:center;"> 0.643 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> No. Countries </td>
   <td style="text-align:center;"> 109 </td>
   <td style="text-align:center;"> 101 </td>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 89 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 3 </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> * p &lt; 0.1, ** p &lt; 0.05, *** p &lt; 0.01</td></tr></tfoot>
</table>

In these analyses, note that even the global sample is already heavily skewed towards developed countries due to data availability. In the global sample, the correlation (conditional on all other factors) of female labor force participation with TFR is negative: a 1 percentage point increase in FLFP is associated with approx. a 0.05 decrease in TFR. Extrapolating from this, moving from 10% to 50% female labor force participation implies a reduction in TFR of 2 children per woman. If you allow this to have a counterfactual interpretation, a policy of "getting all women back into the kitchen" or conversely, of "full emancipation", would hypothetically give you a fertility rate of about 3.5 in Europe, given current fertility levels and female labor participation, or a fertility rate of about 1.5 in places like Central Asia or North Africa, where FLFP is still pretty low. This estimate seems to be pretty plausible.

The correlation of broad money supply (M2) with TFR is also negative, and its magnitude is twice that of FLFP! A percentage increase in the broad base money is associated with a 0.10 fall in the TFR! Worldwide, people seem to really dislike monetary expansion in family planning. This seems to be true even after 2010: places with high money growth have lower fertility, conditional on these factors. Its correlation, again taken counterfactually, implies a 0.25 drop in the TFR following a 1% rise in inflation. The low explanatory power also favors other ideological or cultural factors influencing TFR. All other factors are not statistically associated with TFR after controlling for all these factors. Notably, the correlation between FLFP and TFR disappears, presumably due to a lack of movement in FLFP (radical changes in FLFP occurred long before that).

Focusing on Europe, the relationship between FLFP and TFR is robust. However, the correlation between money supply and fertility is now positive and significant. Maybe, European monetary authorities are more competent than elsewhere, and this could potentially explain the differences in the sign of the correlation between money growth and the TFR in Europe and elsewhere.  No other factors were significantly correlated with TFR. If we finally focus on Russia, Ukraine and Belarus (52 observations in total, mostly recent data, especially from Ukraine and Belarus), the correlation between FLFP and TFR is again significant and twice as large in magnitude as in the global case! At the same time, the Gini coefficient and CPI also significantly negatively correlate with TFR, although the value is very small. In this sample, there is no significant correlation between broad base money M2 and TFR. In this subsample, these factors together explain about 60% of the observed changes in TFR, potentially indicating that Eastern Europeans are more sensitive ("elastic") in providing children with respect to economic factors than other countries. In the Western European sample, _none of these factors_ seems to be associated with changes in fertility, although this sample also exhibits a high within `\(R^2\)` statistic, indicating potentially that European fertility is still more susceptible to economic policy in comparison to the rest of the world. 

Again, when looking either at the within `\(R^2\)` statistics I've reported, or at the coefficients, they should be taken with a grain of salt since unfortunately they come from just correlations: for example, I think it is plausible that FLFP and fertility rate are to some extent simultaneously determined by some third factor. In macroeconomic models, the fundamental exogenous factor that determines these decisions is usually something trivial and of little policy significance, such as the “time preference” embodied in the discount rate in optimal control problems. Newer generational models, presumably, have done a more constructive job in focusing on potentially policy-relevant drivers of fertility, but I have yet to study this literature :) Econometrically, it can be shown that the coefficient estimates are biased (except in special cases) if something like this is the true data generation process.


# Conclusion

I believe the main finding of this analysis is the lack of a correlation between GDP per capita and fertility after controlling for a number of other factors. This means that we have little reason to believe that rising or falling fertility is a side effect of economic growth. On the other hand, there are studies that focus on comparisons between families rather than countries, which show that, for example, pension reforms reduce fertility by increasing the opportunity costs of infant care for grandparents. The high explanatory power in some of these analyses provides a rationale for thinking that some targeted economic policies could work, but at the country level, and thus on a global scale, the most obvious correlate of fertility is still female labor force participation. Thank you for reading! 
