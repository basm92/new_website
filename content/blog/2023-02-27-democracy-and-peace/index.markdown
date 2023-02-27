---
title: Democracy and peace
author: 'Bas Machielsen'
date: '2023-02-27'
slug: []
excerpt: A short post on democratic peace theory to simply explore the correlation between democracy and peace. 
categories: []
tags: []
---
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index_files/lightable/lightable.css" rel="stylesheet" />




## Introduction

I wanted to write a short post on democratic peace theory to simply explore the correlation between democracy and peace. It is sometimes believed that democratic countries are less likely to wage war on each other than autocratic countries, and furthermore, that democratic countries are less likely to wage war in general (either against autocratic or democratic countries). In this blog post, I want to explore the data to see to which extent this holds true. 

There are various reasons why this may be true, ranging from democracies being able to discipline their leaders by the threat of removal from office, withholding them from engaging in wars, to democracies having more mechanisms to resolve conflicts peacefully. On the other hand, democracies might be prone to elect demagogues and be captured by nationalist fury, which might increase the likelihood of being involved in war.

I want to stress that the analysis features an analysis of the unconditional and conditional correlations between democracy and peace, and *not* a causal link. 

As a data source, I use the R package `peacesciencer`, which includes several functions allowing easy access to the _Correlates of War_ dataset, which includes diadic pairs of country-years, and indicators whether country `\(i\)` (i) started a conflict with country `\(j\)` in year `\(t\)`, or whether countries `\(i\)` and `\(j\)` had an enduring military conflict in year `\(t\)`. Throughout the analysis, I focus on both outcomes. 

The advantage of using this dataset is that it has a high coverage in the period it focuses on (1815-2007), but the disadvantage is that it only covers recent history up to 2007. The coding might also be subjective to a certain degree: for example, counting or not counting proxy war involvement happens at the discretion of the owners. Occupations (e.g. Iraq) are also not taken into account as intra-state conflict). An alternative might be to use the UCDP Armed Conflict Data, which records violent conflicts since the 1970's. The amount of casualties in the dataset are also rough estimations.


```r
library(peacesciencer)
```

First, I want to explore the pattern of wars over time. To do so, I create a dataset with dyads of all (existing) polities `\(i\)` and `\(j\)` at time `\(t\)`, and then merge it to the _Correlates of War_ dataset:


```r
country_years_data <- create_dyadyears(system = "cow") |>
  filter(year < 2008)

wars_data <- peacesciencer::add_cow_wars(country_years_data, type = "inter") 
```

The data thus has the following form:


```r
wars_data |> head(5)
```

```
## # A tibble: 5 × 14
##   ccode1 ccode2  year cowinteron…¹ cowin…² sidea1 sidea2 initi…³ initi…⁴ outco…⁵
##    <dbl>  <dbl> <dbl>        <dbl>   <dbl>  <dbl>  <dbl>   <dbl>   <dbl>   <dbl>
## 1      2     20  1920            0       0     NA     NA      NA      NA      NA
## 2      2     20  1921            0       0     NA     NA      NA      NA      NA
## 3      2     20  1922            0       0     NA     NA      NA      NA      NA
## 4      2     20  1923            0       0     NA     NA      NA      NA      NA
## 5      2     20  1924            0       0     NA     NA      NA      NA      NA
## # … with 4 more variables: outcome2 <dbl>, batdeath1 <dbl>, batdeath2 <dbl>,
## #   resume <dbl>, and abbreviated variable names ¹​cowinterongoing,
## #   ²​cowinteronset, ³​initiator1, ⁴​initiator2, ⁵​outcome1
```

And contains the following variables: 

  - `cowinteronset`: whether there is an inter-state war onset between country `\(i\)` and `\(j\)`: 
  - `cowinterongoing`: whether there is an ongoing conflict between country `\(i\)` and country `\(j\)` in year `\(t\)`. 
  - `sidea1`, `sidea2`: a description of sides in the conflict in question. 
  - `initiator1`, `initiator2`: dummies indicating whether country `\(i\)` or `\(j\)` was the initiator of the war. 
  - `outcome1`, `outcome2`: mappings attempting to code the outcome of the war for both parties. 
  - `batdeath1`, `batdeath2`: estimates of causalties for each of the parties `\(i\)` and `\(j\)` respectively. 


## Pattern of wars over time

The first thing I set out to do is grouping the data by year, and compute the sum of ongoing conflicts, and the sum of conflicts started in year `\(t\)`: 


```r
stats <- wars_data |>
  group_by(year) |>
  summarize(ongoing = sum(cowinterongoing, na.rm = TRUE),
            started = sum(cowinteronset, na.rm = TRUE),
            count = n())
```

Investigating the number of ongoing conflicts over time, we see there is no sharp decrease in the number of wars over time.  


```r
stats |>
  ggplot(aes(x = year)) + geom_line(aes(y = ongoing))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

There are many periods, such as the _interbellum_ between the First and Second World Wars, and the "first globalization" from about 1870 to the beginning of the First World War, which were roughly as peaceful, or arguably, more peaceful than present-day. 

To take into account the change in the number of countries, we can also plot the percentage of countries that is at war: 


```r
stats |>
  ggplot(aes(x = year)) + geom_line(aes(y = ongoing/count))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />

We notice a strong drop in the percentage of countries that go to war from about 1950 onward, reflecting the independence of many countries in the decolonization wave (and the fact that they did not fight among each other). 

We can also look at this using some simple models (I estimate linear models, but also Poisson regressions, as the outcome is a count variable): 
  

```r
library(fixest); library(modelsummary)

model1 <- feols(ongoing ~ year, data = stats)
model2 <- feols(started ~ year, data = stats)

model3 <- glm(ongoing ~ year, data = stats, family = poisson(link = "log"))
model4 <- glm(started ~ year, data = stats, family = poisson(link = "log"))

modelsummary(list(model1, model2, model3, model4), 
             stars = TRUE)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;">  (1) </th>
   <th style="text-align:center;">   (2) </th>
   <th style="text-align:center;">   (3) </th>
   <th style="text-align:center;">   (4) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> −127.150* </td>
   <td style="text-align:center;"> −42.572 </td>
   <td style="text-align:center;"> −12.309*** </td>
   <td style="text-align:center;"> −10.926*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (57.165) </td>
   <td style="text-align:center;"> (26.134) </td>
   <td style="text-align:center;"> (0.848) </td>
   <td style="text-align:center;"> (1.322) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year </td>
   <td style="text-align:center;"> 0.072* </td>
   <td style="text-align:center;"> 0.024+ </td>
   <td style="text-align:center;"> 0.008*** </td>
   <td style="text-align:center;"> 0.006*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.030) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.014) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.000) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.001) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 192 </td>
   <td style="text-align:center;"> 192 </td>
   <td style="text-align:center;"> 192 </td>
   <td style="text-align:center;"> 192 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.029 </td>
   <td style="text-align:center;"> 0.016 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.024 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 5286.7 </td>
   <td style="text-align:center;"> 2419.9 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 5293.2 </td>
   <td style="text-align:center;"> 2426.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> −2641.359 </td>
   <td style="text-align:center;"> −1207.969 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 299.261 </td>
   <td style="text-align:center;"> 87.304 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 22.84 </td>
   <td style="text-align:center;"> 10.44 </td>
   <td style="text-align:center;"> 23.04 </td>
   <td style="text-align:center;"> 10.48 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

These analyses corroborate the conclusions made when eyeballing the graphical pattern above: The time trend is slightly positive, meaning as time goes on, wars are _more_ likely to occur and there is a higher likelihood of a country being involved in a war with another country. However, the time trend is not significant. 
  
However, we might argue that the second World War represents such a shock to humanity that everything is different after 1945. Using only observations after 1945, we see the following pattern:
  

```r
stats2 <- stats |> filter(year > 1945)

model1 <- feols(ongoing ~ year, data = stats2)
model2 <- feols(started ~ year, data = stats2)

model3 <- glm(ongoing ~ year, data = stats2, family = poisson(link = "log"))
model4 <- glm(started ~ year, data = stats2, family = poisson(link = "log"))

modelsummary(list(model1, model2, model3, model4),
             stars = TRUE)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;">  (1) </th>
   <th style="text-align:center;">   (2) </th>
   <th style="text-align:center;">   (3) </th>
   <th style="text-align:center;">   (4) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 519.374** </td>
   <td style="text-align:center;"> 117.553 </td>
   <td style="text-align:center;"> 65.063*** </td>
   <td style="text-align:center;"> 31.897*** </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (169.558) </td>
   <td style="text-align:center;"> (87.508) </td>
   <td style="text-align:center;"> (5.218) </td>
   <td style="text-align:center;"> (7.368) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> year </td>
   <td style="text-align:center;"> −0.258** </td>
   <td style="text-align:center;"> −0.058 </td>
   <td style="text-align:center;"> −0.032*** </td>
   <td style="text-align:center;"> −0.015*** </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.086) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.044) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.003) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.004) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 62 </td>
   <td style="text-align:center;"> 62 </td>
   <td style="text-align:center;"> 62 </td>
   <td style="text-align:center;"> 62 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.131 </td>
   <td style="text-align:center;"> 0.027 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.117 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AIC </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 868.3 </td>
   <td style="text-align:center;"> 566.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> BIC </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 872.6 </td>
   <td style="text-align:center;"> 570.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Log.Lik. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> −432.153 </td>
   <td style="text-align:center;"> −281.118 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 144.696 </td>
   <td style="text-align:center;"> 17.171 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 11.89 </td>
   <td style="text-align:center;"> 6.14 </td>
   <td style="text-align:center;"> 11.88 </td>
   <td style="text-align:center;"> 6.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

There is a significant downward time trend in this case, indicating that countries are less likely to wage war with each other since 1945, and that the likelihood of being involved in a war in a given year also decreases. 

This could be the result of a lot of factors potentially, among which might be:
  - Changes in the international system: the post-WWII order created a sort of hegemonic stability preventing large-scale war between countries. 
  - Changes in the composition of countries: after the independence of countries from colonialism, many countries were left poor and did not have sufficient resources to devote to belligerence. 
  - Democratization: many countries became more democratic, and democratic control might prevent countries' leaders from waging war. 
  
In this blog post, I focus on the last theory and find out whether there is evidence for it. This theory is very frequently encountered in the literature, for example, in Harari's books, in Steven Pinker's last book, and in Oded Galor's last book, though I do not think Galor explicitly endorsed it. 

Although all of these books do a good job in anecdotally making their point, and and are much more nuanced than might seem to be the case in this blog post, I think there is a need to tackle this issue from a statistical point of view rather than from a perspective of anecdotes.

## Are democratic countries less likely to start wars or be involved in wars?

In order to analyze whether democratic countries are less likely to start a war, we have to obtain data measuring how democratic countries are. Fortunately, the `peacesciencer` also contains democracy data, featuring three different indicators coming from: the Varieties of Democracy project, the Polity project, and the quickUDS indicators. I'll focus mainly on the third indicator (`quickUDS`) because of its broad coverage:


```r
wars_data <- peacesciencer::add_democracy(wars_data)
```

Now we can analyze the probability of country `\(i\)` being in a war as a function of its democracy score. In order to aid interpretability, let us calculate the extent to which the democracy varies from country to country and over time:


```r
wars_data |>
  group_by(ccode1) |>
  summarize(sd = sd(xm_qudsest1, na.rm = T)) |>
  summarize(se = mean(sd), max_se = max(sd), min_se = min(sd))
```

```
## # A tibble: 1 × 3
##      se max_se min_se
##   <dbl>  <dbl>  <dbl>
## 1 0.391   1.30      0
```

This tells us that the _average_ within-country standard deviation is about 0.4, meaning that within countries, on average, the democracy score varies by about 0.4 units on this scale. Some countries have known a much more volatile trajectory, with a standard deviation of about 1.3, whereas other countries have no variation at all. 

Another way to shed light on this is just to take a particular case. The Netherlands, for instance, evolved like this:


```r
wars_data |> 
  filter(ccode1 == 210) |>
  group_by(year) |>
  summarize(dem_score = mean(xm_qudsest1)) |>
  ggplot(aes(x = year, y = dem_score)) + geom_line()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

.. and Albania evolved like this:


```r
wars_data |> 
  filter(ccode1 == 339) |>
  group_by(year) |>
  summarize(dem_score = mean(xm_qudsest1)) |>
  ggplot(aes(x = year, y = dem_score)) + geom_line()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

Thus, the switch from communism to a market economy and associated increases in democracy correspond to a jump of about 1.5 on this scale, or about 3 or 4 average intra-country standard deviations, whereas the switch from an absolute monarchy (Netherlands in 1815) to a contemporary liberal democracy (Netherlands in 2007) represents about 2 points. 

The average democracy score in the sample is equal to:


```r
wars_data |>
  group_by(ccode1) |>
  summarize(mean = mean(xm_qudsest1, na.rm = T)) |>
  summarize(avg_dem_score = mean(mean))
```

```
## # A tibble: 1 × 1
##   avg_dem_score
##           <dbl>
## 1         0.331
```

Next, we can start to analyze our data. The first thing to do is to restrict our attention to whether country `\(i\)` is at, or goes to, war at time `\(t\)` with at least 1 other country. I take going to war to mean, to be party in a newly starting war. Hence, this does not distinguish between aggressor and aggressee. 


```r
wars_data3 <- wars_data |>
  group_by(ccode1, year) |>
  summarize(xm_qudsest1 = mean(xm_qudsest1, na.rm = T), 
            be_in_war = if_else(sum(cowinterongoing, na.rm = T) > 0, 1, 0),
            go_to_war = if_else(sum(cowinteronset, na.rm = T) > 0, 1, 0))
```

Analyzing this dataset, we discover a very interesting pattern:


```r
model1 <- fixest::feols(go_to_war ~ xm_qudsest1, data = wars_data3)
model2 <- fixest::feols(go_to_war ~ xm_qudsest1 | year, data = wars_data3)
model3 <- fixest::feols(go_to_war ~ xm_qudsest1 | year + ccode1, data = wars_data3)
model4 <- fixest::feols(be_in_war ~ xm_qudsest1, data = wars_data3)
model5 <- fixest::feols(be_in_war ~ xm_qudsest1 | year, data = wars_data3)
model6 <- fixest::feols(be_in_war ~ xm_qudsest1 | year + ccode1, data = wars_data3)

modelsummary(dvnames(list(model1, model2, model3, model4, model5, model6)), stars = T)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> go_to_war </th>
   <th style="text-align:center;"> go_to_war  </th>
   <th style="text-align:center;"> go_to_war   </th>
   <th style="text-align:center;"> be_in_war </th>
   <th style="text-align:center;"> be_in_war  </th>
   <th style="text-align:center;"> be_in_war   </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.028*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.051*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.001) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest1 </td>
   <td style="text-align:center;"> −0.006*** </td>
   <td style="text-align:center;"> −0.003 </td>
   <td style="text-align:center;"> −0.008** </td>
   <td style="text-align:center;"> −0.007** </td>
   <td style="text-align:center;"> −0.001 </td>
   <td style="text-align:center;"> −0.005 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.002) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.002) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.003) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.002) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.003) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.004) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 14195 </td>
   <td style="text-align:center;"> 14195 </td>
   <td style="text-align:center;"> 14195 </td>
   <td style="text-align:center;"> 14195 </td>
   <td style="text-align:center;"> 14195 </td>
   <td style="text-align:center;"> 14195 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.087 </td>
   <td style="text-align:center;"> 0.121 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.107 </td>
   <td style="text-align:center;"> 0.178 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.074 </td>
   <td style="text-align:center;"> 0.095 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.094 </td>
   <td style="text-align:center;"> 0.153 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.16 </td>
   <td style="text-align:center;"> 0.16 </td>
   <td style="text-align:center;"> 0.15 </td>
   <td style="text-align:center;"> 0.22 </td>
   <td style="text-align:center;"> 0.21 </td>
   <td style="text-align:center;"> 0.20 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: year </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

We find that the unconditional relationship between democracy and going to war is negative, consistent with democratic peace theory. The effect is quite small, with a 1 unit increase in the democracy score associated with a 0.8 percentage point decline in the likelihood of being involved in the start of a war. 

However, as soon as we condition on a particular year, this relationship disappears for both going to war, and being in a war. I think it is correct to control for year to disentangle possible correlations between times at which wars spiked, like the first World War, or decolonization wars, and concurrent spikes in democracy. Secondly, when we also control for country fixed-effects, the relationship is insignificant in the case for being at war, but significant and negative for going to war, meaning more democratic countries are less likely to be _going_ to war (or to be a party of a starting war), but _NOT_ less likely to _be_ at war. Again, I think controlling for country fixed-effects is correct, because this way, effects like geographical location or regional stability can be disentangled from democracy. 

(In contrast, I think that controlling for country times year fixed effects is not correct, because that might reflect things like an increased defense budget, which might be caused by democracies and might change the calculus for going to war or not.) 

_But_, if we condition the data on the period _after_ 1945, we uncover the following pattern:


```r
wars_data4 <- wars_data3 |> filter(year > 1945)

model1 <- fixest::feols(go_to_war ~ xm_qudsest1, data = wars_data4)
model2 <- fixest::feols(go_to_war ~ xm_qudsest1 | year, data = wars_data4)
model3 <- fixest::feols(go_to_war ~ xm_qudsest1 | year + ccode1, data = wars_data4)
model4 <- fixest::feols(be_in_war ~ xm_qudsest1, data = wars_data4)
model5 <- fixest::feols(be_in_war ~ xm_qudsest1 | year, data = wars_data4)
model6 <- fixest::feols(be_in_war ~ xm_qudsest1 | year + ccode1, data = wars_data4)

modelsummary(dvnames(list(model1, model2, model3, model4, model5, model6)), stars = T)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> go_to_war </th>
   <th style="text-align:center;"> go_to_war  </th>
   <th style="text-align:center;"> go_to_war   </th>
   <th style="text-align:center;"> be_in_war </th>
   <th style="text-align:center;"> be_in_war  </th>
   <th style="text-align:center;"> be_in_war   </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.018*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.036*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.002) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest1 </td>
   <td style="text-align:center;"> −0.003+ </td>
   <td style="text-align:center;"> −0.001 </td>
   <td style="text-align:center;"> −0.002 </td>
   <td style="text-align:center;"> −0.005** </td>
   <td style="text-align:center;"> −0.001 </td>
   <td style="text-align:center;"> 0.003 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.001) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.002) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.004) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.002) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.003) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.005) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 8766 </td>
   <td style="text-align:center;"> 8766 </td>
   <td style="text-align:center;"> 8766 </td>
   <td style="text-align:center;"> 8766 </td>
   <td style="text-align:center;"> 8766 </td>
   <td style="text-align:center;"> 8766 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.033 </td>
   <td style="text-align:center;"> 0.084 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.052 </td>
   <td style="text-align:center;"> 0.173 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.026 </td>
   <td style="text-align:center;"> 0.056 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.045 </td>
   <td style="text-align:center;"> 0.148 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.13 </td>
   <td style="text-align:center;"> 0.13 </td>
   <td style="text-align:center;"> 0.12 </td>
   <td style="text-align:center;"> 0.18 </td>
   <td style="text-align:center;"> 0.17 </td>
   <td style="text-align:center;"> 0.16 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: year </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

In this sample, we find that, before controlling for year- and country fixed-effects, there is a negative relationship between democracy and going to / being in a war. This finding might also explain why democratic peace theory is so prevalent. However, _after_ conditioning on country and year fixed effects, the relationship is no longer statistically significant, and its point estimate for being to war is even positive! 

## Are more democratic less likely to go to war with more democratic countries?

Another thing we can do is more explicitly analyze the dyadic dataset, indicating whether country `\(i\)` and `\(j\)` are in an armed conflict, as a function of both of their democracy scores. In particular, we estimate the following model:

$$
W\_{i,j,t} = \alpha\_t + \gamma\_i + \delta\_j + \beta\_1 \cdot \text{DemocracyScore}\_{it} + \beta\_2 \cdot \text{DemocracyScore}\_{jt} + \epsilon\_{ijt} 
$$

This deserves some elaboration. When modeling the likelihood `\(W \in \{0,1\}\)` of countries `\(i\)` and `\(j\)` starting/being in a war at time `\(t\)`, it makes sense to consider the democracy score of country `\(j\)` when modeling the decision of country `\(i\)`. As before, we also want to condition on year and country fixed-effects. Our coefficient of interest is `\(\beta_1\)`, reflecting the likelihood of country `\(i\)` going to war with country `\(j\)` conditional on country `\(j\)`'s democracy score and fixed effects. 

Optionally, we might also add joint country `\((i,j)\)` fixed effects to control, for example, for the distance between them. 

With `\(\beta_2\)`, we test whether the likelihood increases/decreases as the democracy score of country `\(j\)` changes for a given democracy score of country `\(i\)`. This is strictly speaking not an investigation of democratic peace theory, but if more democratic countries are less likely to go to war with more democratic countries (vis-a-vis less democratic countries), this coefficient would be _negative_. 

Also, since dyadic data is symmetric, let us first filter out (without loss of generality) the double observations, and let us also rescale the independent variables to get a more reasonable magnitude of coefficient estimates:


```r
wars_data2 <- wars_data |>
  filter(ccode2 < ccode1) |>
  mutate(xm_qudsest1 = xm_qudsest1 / 10000,
         xm_qudsest2 = xm_qudsest2 / 10000)
```

Then, we estimate the models:


```r
model1 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2, 
                data = wars_data2)
model2 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2  | year, 
                data = wars_data2)
model3 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2, 
                data = wars_data2)
model31 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2 + ccode1*ccode2, 
                data = wars_data2)

model4 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2, 
                data = wars_data2)
model5 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2 | year, 
                data = wars_data2)
model6 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2| year + ccode1 + ccode2, 
                data = wars_data2)

model61 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2 + ccode1*ccode2, 
                data = wars_data2)

modelsummary(dvnames(list(model1, model2, model3, model31, 
                          model4, model5, model6, model61)),
             stars = T)
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> cowinterongoing </th>
   <th style="text-align:center;"> cowinterongoing  </th>
   <th style="text-align:center;"> cowinterongoing   </th>
   <th style="text-align:center;"> cowinterongoing    </th>
   <th style="text-align:center;"> cowinteronset </th>
   <th style="text-align:center;"> cowinteronset  </th>
   <th style="text-align:center;"> cowinteronset   </th>
   <th style="text-align:center;"> cowinteronset    </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.002*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.001*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest1 </td>
   <td style="text-align:center;"> −2.473*** </td>
   <td style="text-align:center;"> −1.144 </td>
   <td style="text-align:center;"> −5.192** </td>
   <td style="text-align:center;"> −4.844* </td>
   <td style="text-align:center;"> −1.381*** </td>
   <td style="text-align:center;"> −0.764+ </td>
   <td style="text-align:center;"> −2.546* </td>
   <td style="text-align:center;"> −2.518* </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.431) </td>
   <td style="text-align:center;"> (0.938) </td>
   <td style="text-align:center;"> (1.924) </td>
   <td style="text-align:center;"> (1.955) </td>
   <td style="text-align:center;"> (0.274) </td>
   <td style="text-align:center;"> (0.426) </td>
   <td style="text-align:center;"> (1.085) </td>
   <td style="text-align:center;"> (1.121) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest2 </td>
   <td style="text-align:center;"> −5.207*** </td>
   <td style="text-align:center;"> −0.768 </td>
   <td style="text-align:center;"> −7.884* </td>
   <td style="text-align:center;"> −6.069* </td>
   <td style="text-align:center;"> −2.542*** </td>
   <td style="text-align:center;"> −0.935** </td>
   <td style="text-align:center;"> −4.770** </td>
   <td style="text-align:center;"> −3.741* </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.427) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.554) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (3.296) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (3.054) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.271) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.339) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (1.816) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (1.712) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
   <td style="text-align:center;"> 786332 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.021 </td>
   <td style="text-align:center;"> 0.030 </td>
   <td style="text-align:center;"> 0.074 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.014 </td>
   <td style="text-align:center;"> 0.029 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.021 </td>
   <td style="text-align:center;"> 0.030 </td>
   <td style="text-align:center;"> 0.053 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.011 </td>
   <td style="text-align:center;"> 0.013 </td>
   <td style="text-align:center;"> 0.007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.03 </td>
   <td style="text-align:center;"> 0.03 </td>
   <td style="text-align:center;"> 0.03 </td>
   <td style="text-align:center;"> 0.03 </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: year </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1:ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

This indicates that in the entire dataset, we again have that the more democratic a country, the less likely it is to be involved in a war, even after controlling for another country's democracy score. Similarly, the more democratic the other country `\(j\)`, the less likely there is for country `\(i\)` to be involved in a war against it. But again, let us look at the pattern _after_ 1945:


```r
wars_data5 <- wars_data2 |>
  filter(year > 1945)

model1 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2, 
                data = wars_data5)
model2 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2 | year, 
                data = wars_data5)
model3 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2, 
                data = wars_data5)
model31 <- feols(cowinterongoing ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2 + ccode1*ccode2, 
                data = wars_data5)

modelsummary(dvnames(list( model1, model2, model3, model31)), stars  =T, 
             title = "Ongoing Wars")
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>Table 1: Ongoing Wars</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> cowinterongoing </th>
   <th style="text-align:center;"> cowinterongoing  </th>
   <th style="text-align:center;"> cowinterongoing   </th>
   <th style="text-align:center;"> cowinterongoing    </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.001*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest1 </td>
   <td style="text-align:center;"> −1.594*** </td>
   <td style="text-align:center;"> −1.521* </td>
   <td style="text-align:center;"> 2.129+ </td>
   <td style="text-align:center;"> 1.685 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.273) </td>
   <td style="text-align:center;"> (0.636) </td>
   <td style="text-align:center;"> (1.159) </td>
   <td style="text-align:center;"> (1.119) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest2 </td>
   <td style="text-align:center;"> −1.623*** </td>
   <td style="text-align:center;"> −0.811* </td>
   <td style="text-align:center;"> 2.927* </td>
   <td style="text-align:center;"> 1.864+ </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.263) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.332) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (1.141) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.977) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.003 </td>
   <td style="text-align:center;"> 0.014 </td>
   <td style="text-align:center;"> 0.096 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.003 </td>
   <td style="text-align:center;"> 0.013 </td>
   <td style="text-align:center;"> 0.072 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
   <td style="text-align:center;"> 0.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: year </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1:ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>


```r
model4 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2, 
                data = wars_data5)
model5 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2 | year, 
                data = wars_data5)
model6 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2, 
                data = wars_data5)

model61 <- feols(cowinteronset ~ xm_qudsest1 + xm_qudsest2 | year + ccode1 + ccode2 + ccode1*ccode2, 
                data = wars_data5)

modelsummary(dvnames(list(model4, model5, model6, model61)), stars = T,
             title = "Start of Wars")
```

<table style="NAborder-bottom: 0; width: auto !important; margin-left: auto; margin-right: auto;" class="table">
<caption>Table 2: Start of Wars</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:center;"> cowinteronset </th>
   <th style="text-align:center;"> cowinteronset  </th>
   <th style="text-align:center;"> cowinteronset   </th>
   <th style="text-align:center;"> cowinteronset    </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> (Intercept) </td>
   <td style="text-align:center;"> 0.000*** </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.000) </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest1 </td>
   <td style="text-align:center;"> −0.587** </td>
   <td style="text-align:center;"> −0.620 </td>
   <td style="text-align:center;"> 0.072 </td>
   <td style="text-align:center;"> −0.206 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:center;"> (0.181) </td>
   <td style="text-align:center;"> (0.394) </td>
   <td style="text-align:center;"> (0.690) </td>
   <td style="text-align:center;"> (0.732) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> xm_qudsest2 </td>
   <td style="text-align:center;"> −0.571** </td>
   <td style="text-align:center;"> −0.371+ </td>
   <td style="text-align:center;"> 0.188 </td>
   <td style="text-align:center;"> −0.284 </td>
  </tr>
  <tr>
   <td style="text-align:left;box-shadow: 0px 1px">  </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.174) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.211) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.771) </td>
   <td style="text-align:center;box-shadow: 0px 1px"> (0.762) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Num.Obs. </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
   <td style="text-align:center;"> 666317 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.004 </td>
   <td style="text-align:center;"> 0.029 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Adj. </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.001 </td>
   <td style="text-align:center;"> 0.003 </td>
   <td style="text-align:center;"> 0.004 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> R2 Within Adj. </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
   <td style="text-align:center;"> 0.000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RMSE </td>
   <td style="text-align:center;"> 0.01 </td>
   <td style="text-align:center;"> 0.01 </td>
   <td style="text-align:center;"> 0.01 </td>
   <td style="text-align:center;"> 0.01 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Std.Errors </td>
   <td style="text-align:center;"> IID </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
   <td style="text-align:center;"> by: year </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: year </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
   <td style="text-align:center;"> X </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FE: ccode1:ccode2 </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> X </td>
  </tr>
</tbody>
<tfoot><tr><td style="padding: 0; " colspan="100%">
<sup></sup> + p &lt; 0.1, * p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td></tr></tfoot>
</table>

These two tables show us that, using data _after_ 1945, after controlling for country `\(i\)` and country `\(j\)` fixed effects, there is no relationship anymore between how democratic a country is and its tendency to engage in war. That means that there is no evidence that as countries become more democratic, they are less inclined to engage (or be engaged) in military conflict with other states. These results hold for both being involved in a war in year `\(t\)`, as well as for being involved in the _start_ of a war in year `\(t\)`. The last analysis also show that, after controlling for country fixed effects, and cross-country fixed effects, there is no clear relationship for countries to be less likely (or more likely) to be engaged with more democratic countries, conditional on their own democracy. 

## Conclusion

I do _not_ analyse whether democracy causes peace. That is of course a much more interesting question, but also one which requires better data and, ideally, experimental administering of democraticness, something which is unimaginable. Some researchers have attempted to use the effect of democracies on e.g. economic growth. Perhaps, instruments similar to those could be used to investigate the influence on the likelihood of going to war. 

Instead, I only analyze the correlation between democracy and the likelihood of being involved in war. I find that contrary to popular wisdom, the correlation, after controlling for a few simple factors, is essentially zero, and statistically insignificant. 

There are a lot of limitations to this analysis. For example, I did not take into account possible dynamic of the sort mentioned before, in that particular democracies might chose autocratic leaders who subsequently go to war. As it is not clear _a priori_ how to tackle these dynamics, I thought it best to leave them. 

Finally, in addition to engaging directly in military conflict with other states, there are also various other ways in which less democratic countries could be more belligerent, for example, by financing proxy wars, supporting parties in inter-state conflicts, etc. 
