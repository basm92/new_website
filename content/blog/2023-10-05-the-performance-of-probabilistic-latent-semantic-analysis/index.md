---
title: The Performance of Probabilistic Latent Semantic Analysis
author: 'Bas Machielsen'
date: '2023-10-05'
slug: []
categories: []
tags: []
---

## Introduction

In this blog post, I want to investigate the performance of probabilistic latent semantic analysis: a subject I have been teaching (but also studying) for a course. Probabilistic latent semantic analysis proceeds from a _document-term_ matrix, a standard data matrix in the field of text mining. It should look something like this, where the rows of the matrix represent `\(n\)` documents and the columns `\(p\)` terms (words). Usually, `\(p > n\)`. 
  
$$
A = \begin{pmatrix}
doc_1,term_1 & doc_1, term_2 & \dots & doc_1, term_p \\
\vdots & \dots & \ddots & \vdots \\
doc_n, term_1 & \dots & \dots & doc_n, term_p \end{pmatrix}
$$
The standard maximum likelihood estimator for `\(Pr(d_i, t_j)\)` is `\(x_{ij} / m\)` where `\(m\)` is the total word count in all documents. This has a simple interpretation: count of word `\(j\)` in document `\(i\)` / total word count in all documents. 

## PLSA

Probabilistic Latent Semantic Analysis (PLSA) is an attempt to decompose this matrix using something similar to a singular value decomposition. In particular, given a probability matrix: 


$$
P = \begin{pmatrix} p(d_1, t_1) & \dots & p(d_1, t_p) \\
\vdots & \ddots & \vdots \\
p(d_n, t_1)&  \dots & p(d_n, t_p) \end{pmatrix}
$$


We can have construct an approximation `\(U\Sigma V^T\)` with `\(U=N \times r\)` ($r$ classes):

$$
U = \begin{pmatrix} p(d_1 | c_1) & \dots & p(d_1 | c_r) \\
\vdots &  & \vdots \\
p(d_n | c_1) & \dots & p(d_n | c_r) \end{pmatrix}
$$

`\(\Sigma = \text{diag}(P(c_r))\)`, and `\(V^T\)` ($r \times p$) has elements `\(V^T_{ij} = P(t_j | c_i)\)`. Naturally, the object of interest is usually `\(U\)`: this represents the probabilities of the document belonging to class `\(1\)` to `\(r\)`. 

In R, the package `svs` can be used to carry out probabilistic latent semantic analysis:


```r
library(svs)
```

In what follows, I'll demonstrate the capacity of PLSA to distinguish two types of documents on its own: I'll scrape and convert into a document text matrix several pages about football, and several pages about tennis, set `\(k\)` (the number of classes) equal to 2, and investigate the output. 


## Example

Here, I first web-scrape the text of eight wikipedia pages: 


```r
library(rvest); library(tidyverse, quietly=T)
```

```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.2     ✔ readr     2.1.4
## ✔ forcats   1.0.0     ✔ stringr   1.5.0
## ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
## ✔ purrr     1.0.1     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter()         masks stats::filter()
## ✖ readr::guess_encoding() masks rvest::guess_encoding()
## ✖ dplyr::lag()            masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

```r
urls <- c('https://en.wikipedia.org/wiki/2022_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2018_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2014_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2010_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2006_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2002_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/1998_FIFA_World_Cup',
          'https://en.wikipedia.org/wiki/2022_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/2018_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/2014_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/2010_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/2006_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/2002_Wimbledon_Championships',
          'https://en.wikipedia.org/wiki/1998_Wimbledon_Championships')

texts <- map(urls, ~ read_html(.x) |> 
  html_elements('div.mw-parser-output p') |> 
  html_text())
```

Now, I use the `tidytext` package to put these into a document-term matrix:


```r
library(tidytext)
# Compute the texts into a data.frame
text_df <- tibble(Text = texts) |> 
  rowwise() |> 
  mutate(Text = paste(Text, collapse="")) |> 
  ungroup()

# Put all words together grouped by document
text_data <- text_df |>
  group_by(row_number()) |> 
  unnest_tokens(word, Text) |> 
  rename('document' = 'row_number()')

# Convert to a document-term matrix
# Filter out stop_words and numbers
stop_words <- bind_rows(stop_words, data.frame(word = as.character(0:10000), lexicon="Custom"))

dtm <- text_data |>
  count(document, word) |>
  filter(!is.element(word, stop_words)) |> #!str_detect(word, paste(as.character(0:10000), collapse="|"))) |> 
  cast_dtm(document, word, n)
```

The document-term matrix (`dtm`) looks like this:


```r
as.data.frame(as.matrix(dtm)) |> dim()
```

```
## [1]   14 6197
```

Now, let's compute the frequencies and apply LPSA:


```r
library(svs)
X <- as.matrix(dtm)
out <- fast_plsa(X, k=2, symmetric=T)
```

Now, I want to find out which class each of the documents have been assigned to:


```r
apply(
  out$prob1, 1, which.max
)
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 
##  2  2  1  1  1  1  1  2  2  2  2  2  2  2
```

.. which means that the majority of the documents is classified in the correct corresponding cluster. 

## Comparison

We can compare the results with a so-called latent semantic analysis, which is just a singular value decomposition. 



```r
out_lsa <- fast_lsa(X)

out_lsa$pos1[, 'Dim1']
```

```
##            1            2            3            4            5            6 
## -0.803081398 -0.338888792 -0.191561592 -0.298909337 -0.271174528 -0.133052909 
##            7            8            9           10           11           12 
## -0.146478395 -0.026522482 -0.011199147 -0.008402141 -0.019986480 -0.013202093 
##           13           14 
## -0.001734649 -0.001084412
```

In this case, we can see that the mean of the first dimension already separates the documents perfectly in two classes. The first 7 observations having very low values and the second 7 values having very high values. So we can take this to be an indicator for which class the documents belong to:


```r
data.frame(doc_no = 1:14) |> 
  mutate(class = if_else(out_lsa$pos1[,'Dim1'][doc_no] > median(out_lsa$pos1[,'Dim1']), 1, 2))
```

```
##    doc_no class
## 1       1     2
## 2       2     2
## 3       3     2
## 4       4     2
## 5       5     2
## 6       6     2
## 7       7     2
## 8       8     1
## 9       9     1
## 10     10     1
## 11     11     1
## 12     12     1
## 13     13     1
## 14     14     1
```

## Conclusion

In this setting, I have demonstrated a simple example of latent probabilistic semantic analysis, and latent semantic analysis, and I would prefer a simpler method to a potentially more complicated method. Thank you for reading!
