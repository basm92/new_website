---
title: 'R: filtering with across in dplyr'
author: 'Bas Machielsen'
date: '2020-05-17'
draft: false
excerpt: A blog post about a new functionality and way of thinking in R
images: null
layout: single
series: null
subtitle: ""
tags: null
---



## Introduction

The newest versions of the `dplyr` package introduced a new function, `across()`, to be used within summarise, mutate and filter functions, and I am trying to learn it. I am, however, having a hard time understanding the use and the mechanics of the function in combination with filter. While [this vignette](https://dplyr.tidyverse.org/dev/articles/colwise.html) has ample examples on mutate and summarise, the examples on filter are few and not very insightful. The same is true for several non-official guides that I have read. 

As mentioned, the `dplyr` documentation provides examples with the `summarise` and `mutate` functions, but it does not deal extensively with the `filter` function, which is not (in my opinion) straightforward to use at all. The objective of this pamphlet is to introduce the reader to the (proper and transparent) usage of `across()` in conjunction with `filter`, but also to remind the writer of the functionality of `across()`. Finally, it aims to help new and experienced programmers wrap their head around this new function. 
After reading this pamphlet, you should be familiar enough with `across()` to be able to replace the `_all`, `_at`, and `_if` function family intuitively. I will illustrate how this works with the help of some examples. 

## Filter with all_vars

First, let us look at the most basic usage of `across` in `filter`: filtering a dataset based on all rows meeting a certain condition or requirement. 

Suppose we want to select rows in a dataset such that for every character variable, the length of the string should be larger than a particular number, in this example, 5. This would be the equivalent of `filter_all` in a data.frame consisting purely of character vectors, or otherwise, of `filter_at`. 

First, load the relevant packages.. 


```r
library(tidyverse)
```



```r
library(stringr)
```

As mentioned in the vignette, the across function without any additions works automatically as `all_vars`, as evidenced by the following behavior:


```r
numbers <- data.frame(a = c(10000, 90000, 60000, 3000),
                      b = c(10000, 20000, 4000, 30000))

numbers
```

```
##       a     b
## 1 10000 10000
## 2 90000 20000
## 3 60000  4000
## 4  3000 30000
```



```r
numbers %>%
  filter(across(everything(),~.x > 9999))
```

```
##       a     b
## 1 10000 10000
## 2 90000 20000
```

We can also specify which variables we want to meet the condition. Let's take the dataset from before and apply the filter only on the first column: 



```r
numbers %>%
  filter(across(a, ~ . > 9999))
```

```
##       a     b
## 1 10000 10000
## 2 90000 20000
## 3 60000  4000
```

As as second example, let's implement a condition requiring that the string length of every character variable be greater than 2 (or 3) in the dplyr::starwars dataset:


```r
starwars %>%
  filter(across(is.character, ~ str_length(.) > 2))
```

```
## # A tibble: 69 × 14
##    name     height  mass hair_color skin_color eye_color birth_year sex   gender
##    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
##  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
##  2 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
##  3 Leia Or…    150    49 brown      light      brown           19   fema… femin…
##  4 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
##  5 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
##  6 Biggs D…    183    84 black      light      brown           24   male  mascu…
##  7 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
##  8 Anakin …    188    84 blond      fair       blue            41.9 male  mascu…
##  9 Wilhuff…    180    NA auburn, g… fair       blue            64   male  mascu…
## 10 Chewbac…    228   112 brown      unknown    blue           200   male  mascu…
## # … with 59 more rows, and 5 more variables: homeworld <chr>, species <chr>,
## #   films <list>, vehicles <list>, starships <list>
```


```r
starwars %>%
  filter(across(is.character, ~ str_length(.) > 3))
```

```
## # A tibble: 63 × 14
##    name     height  mass hair_color skin_color eye_color birth_year sex   gender
##    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
##  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
##  2 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
##  3 Leia Or…    150    49 brown      light      brown           19   fema… femin…
##  4 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
##  5 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
##  6 Biggs D…    183    84 black      light      brown           24   male  mascu…
##  7 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
##  8 Anakin …    188    84 blond      fair       blue            41.9 male  mascu…
##  9 Wilhuff…    180    NA auburn, g… fair       blue            64   male  mascu…
## 10 Chewbac…    228   112 brown      unknown    blue           200   male  mascu…
## # … with 53 more rows, and 5 more variables: homeworld <chr>, species <chr>,
## #   films <list>, vehicles <list>, starships <list>
```

We select all character variables with `as.character`, and condition the filter on the string length of all variables being larger than 5. 

Similarly, consider the following modified dataframe from the colwise vignette I mentioned above:



```r
df <- tibble(x = c("a", "b"), 
             y = c(1, 1), 
             z = c(-1, 1),
             w = c("Hanz", "Genghis Khan"),
             u = c("Werner", "Monsieur Eugene Duchene"))

df
```

```
## # A tibble: 2 × 5
##   x         y     z w            u                      
##   <chr> <dbl> <dbl> <chr>        <chr>                  
## 1 a         1    -1 Hanz         Werner                 
## 2 b         1     1 Genghis Khan Monsieur Eugene Duchene
```

Suppose we want to select, in parallel to the example given in the vignette, the rows for which all numeric variables are greater than -1:


```r
df %>%
  filter(across(is.numeric, ~ . > -1))
```

```
## # A tibble: 1 × 5
##   x         y     z w            u                      
##   <chr> <dbl> <dbl> <chr>        <chr>                  
## 1 b         1     1 Genghis Khan Monsieur Eugene Duchene
```


So it is very straightforward to use the `filter()` function if you want to filter such that **all** variables meet a criterion. It is also very straightforward to filter using multiple criteria, as long as you want all variables, and **NOT** some variables, to which you apply the criterion have to meet it: 




```r
df %>%
  filter(across(is.numeric, ~ . > -1), across(c(w,u), ~ str_length(.) > 5))
```

```
## # A tibble: 1 × 5
##   x         y     z w            u                      
##   <chr> <dbl> <dbl> <chr>        <chr>                  
## 1 b         1     1 Genghis Khan Monsieur Eugene Duchene
```


.. or perhaps better illustrated by:



```r
# All numeric variables must be larger than 10
starwars %>%
  filter(across(is.numeric, ~ . > 10))
```

```
## # A tibble: 35 × 14
##    name     height  mass hair_color skin_color eye_color birth_year sex   gender
##    <chr>     <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
##  1 Luke Sk…    172    77 blond      fair       blue            19   male  mascu…
##  2 C-3PO       167    75 <NA>       gold       yellow         112   none  mascu…
##  3 R2-D2        96    32 <NA>       white, bl… red             33   none  mascu…
##  4 Darth V…    202   136 none       white      yellow          41.9 male  mascu…
##  5 Leia Or…    150    49 brown      light      brown           19   fema… femin…
##  6 Owen La…    178   120 brown, gr… light      blue            52   male  mascu…
##  7 Beru Wh…    165    75 brown      light      blue            47   fema… femin…
##  8 Biggs D…    183    84 black      light      brown           24   male  mascu…
##  9 Obi-Wan…    182    77 auburn, w… fair       blue-gray       57   male  mascu…
## 10 Anakin …    188    84 blond      fair       blue            41.9 male  mascu…
## # … with 25 more rows, and 5 more variables: homeworld <chr>, species <chr>,
## #   films <list>, vehicles <list>, starships <list>
```




```r
# All numeric variables must be larger than 10 
# and both name AND hair_color should contain an a. 

starwars %>%
  filter(across(is.numeric, ~ . > 10), 
         across(c(name, hair_color), ~ grepl("a", .)))
```

```
## # A tibble: 7 × 14
##   name      height  mass hair_color skin_color eye_color birth_year sex   gender
##   <chr>      <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
## 1 Biggs Da…    183  84   black      light      brown           24   male  mascu…
## 2 Obi-Wan …    182  77   auburn, w… fair       blue-gray       57   male  mascu…
## 3 Boba Fett    183  78.2 black      fair       brown           31.5 male  mascu…
## 4 Lando Ca…    177  79   black      dark       brown           31   male  mascu…
## 5 Luminara…    170  56.2 black      yellow     blue            58   fema… femin…
## 6 Barriss …    166  50   black      yellow     blue            40   fema… femin…
## 7 Jango Fe…    183  79   black      tan        brown           66   male  mascu…
## # … with 5 more variables: homeworld <chr>, species <chr>, films <list>,
## #   vehicles <list>, starships <list>
```


## Filter with any_vars

Problems arise when we attempt to do the following: Suppose we want to laxen the condition, and instead, we want to require that at least one condition be met. 

For example, in the data.frame `df` below, we want *at least* one character string to be larger than 7. How do we go about this? Instead of using the `any_vars` and `all_vars` helpers, we must use an auxiliary function, as documented [here](https://dplyr.tidyverse.org/dev/articles/colwise.html). In my opinion, this way of filtering is far from intuitive and transparent, and it took me a while to figure it out what I should do in each specific case: it is the reason why I wrote this pamphlet. 




```r
df <- tibble(x = c("a", "b"), 
             y = c(1, 1),
             z = c(-1, 1),
             w = c("Harry", "Potterisverycool")
)

df
```

```
## # A tibble: 2 × 4
##   x         y     z w               
##   <chr> <dbl> <dbl> <chr>           
## 1 a         1    -1 Harry           
## 2 b         1     1 Potterisverycool
```


Now, suppose we want to filter the data.frame `df` to include only the rows in which at least one character vector has a string length greater than 6. The vignette advises us to use a helper function, which is defined to be:



```r
rowAny <- function(x) rowSums(x) > 0
```

In my view, this seems to be pretty much the only 'helper' function I can think of and that works, so I don't see why it is not included as a function in the package. In any case, the job consists of apply the `across()` function as an argument to `rowAny`:



```r
library(stringr)

df %>%
  filter(rowAny(across(is.character, ~ str_length(.) > 6)))
```

```
## # A tibble: 1 × 4
##   x         y     z w               
##   <chr> <dbl> <dbl> <chr>           
## 1 b         1     1 Potterisverycool
```



```r
df %>%
  filter(rowAny(across(is.character, ~ str_length(.) > 4)))
```

```
## # A tibble: 2 × 4
##   x         y     z w               
##   <chr> <dbl> <dbl> <chr>           
## 1 a         1    -1 Harry           
## 2 b         1     1 Potterisverycool
```


In other words, we are asking R to filter to any rows to which the following condition aplies:

1. For any row, check all character vectors

2. Compute the string length (`str_length`) of the cells

3. Ask whether it is larger than 6 (or 4, respectively, in the examples)

4. We get back a logical in every cell

5. If the rowwise-sum of all these conditions is larger than 0, then keep the row

Let's go over each of these individual steps quickly and try to emulate R's behavior over this function:



```r
#First, this is what we get when we evaluate the condition in each cell
df %>%
  summarise(across(everything(), ~ str_length(.x) > 5))
```

```
## # A tibble: 2 × 4
##   x     y     z     w    
##   <lgl> <lgl> <lgl> <lgl>
## 1 FALSE FALSE FALSE FALSE
## 2 FALSE FALSE FALSE TRUE
```



```r
#Then, we sum the value of all the logicals per row:
df %>%
  summarise(across(everything(), ~ str_length(.x) > 5)) %>%
  rowwise() %>%
  rowSums() > 0
```

```
## [1] FALSE  TRUE
```



```r
#which gives us back the rows eligible for inclusion
  
df[df %>%
  summarise(across(everything(), ~ str_length(.x) > 5)) %>%
  rowwise() %>%
  rowSums() > 0,
]
```

```
## # A tibble: 1 × 4
##   x         y     z w               
##   <chr> <dbl> <dbl> <chr>           
## 1 b         1     1 Potterisverycool
```


Similarly, going back to the df example, we could have also changed the zero to go from "at least one" to "at least two", for example. So this would mean "select all Rows in which at least 2 variables meet a certain condition". More concretely:



```r
rowAny <- function(x) rowSums(x) > 1
```




```r
df <- df %>%
  mutate(u = c("Hermione", "Granger"))

df
```

```
## # A tibble: 2 × 5
##   x         y     z w                u       
##   <chr> <dbl> <dbl> <chr>            <chr>   
## 1 a         1    -1 Harry            Hermione
## 2 b         1     1 Potterisverycool Granger
```


Let's see if filter now works as expected, that is to say, it should only include the second row, as I've specified that the amount of occurrences (the count of the logical vectors) should be larger than one. (In case of the first row, it is 1.)



```r
df %>%
  filter(
    rowAny(
      across(
        is.character, ~ str_length(.) > 5
        )
      )
    )
```

```
## # A tibble: 1 × 5
##   x         y     z w                u      
##   <chr> <dbl> <dbl> <chr>            <chr>  
## 1 b         1     1 Potterisverycool Granger
```


```r
df %>%
  filter(
    rowAny(
      across(
        is.character, ~ str_length(.) > 7
        )
      )
    )
```

```
## # A tibble: 0 × 5
## # … with 5 variables: x <chr>, y <dbl>, z <dbl>, w <chr>, u <chr>
```

## Conclusion

Whereas `across()` has many other benefits clearly demonstrated in various vignettes, and has enormous potential, in the specific case of filtering, it might have become more awkward to use: the functions of `filter_all` or `filter_at` in combination with `any_vars` and `all_vars` were (i) at least as, or more intuitive, and (ii) did not require the user to specify a helper function. As for me, I hope this `rowAny` will get a place inside `dplyr`, preferably under an intuitive monniker. In any case, I hope you've found the small demonstration useful. Feel free to contact me at any time via [e-mail](mailto:a.h.machielsen@uu.nl) or [Github](https://www.github.com/basm92). 
