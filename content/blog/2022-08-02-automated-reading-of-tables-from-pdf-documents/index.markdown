---
title: Automated Reading of Tables from PDF Documents
author: 'Bas Machielsen'
date: '2020-05-31'
draft: false
excerpt: A post about automated reading using an example of the Indonesian census data
layout: single
series: null
subtitle: ""
tags: null
---




## Introduction

In this post, I will briefly explain how to read in a table easily from the Indonesian data sources that I have been planning to use (see [here](https://www.bps.go.id/publication/2019/10/04/9812a1c4ea25298004839596/produk-domestik-regional-bruto-kabupaten-kota-di-indonesia-2014-2018.html)). First, I download the file, containing data about municipalities in every province and their GRDP:


```r
if(!is.element("hello.pdf", list.files())){
download.file("https://www.bps.go.id/publication/download.html?nrbvfeve=OTgxMmExYzRlYTI1Mjk4MDA0ODM5NTk2&xzmn=aHR0cHM6Ly93d3cuYnBzLmdvLmlkL3B1YmxpY2F0aW9uLzIwMTkvMTAvMDQvOTgxMmExYzRlYTI1Mjk4MDA0ODM5NTk2L3Byb2R1ay1kb21lc3Rpay1yZWdpb25hbC1icnV0by1rYWJ1cGF0ZW4ta290YS1kaS1pbmRvbmVzaWEtMjAxNC0yMDE4Lmh0bWw%3D&twoadfnoarfeauf=MjAyMi0wOC0wMyAwMDo1NDoyMg%3D%3D", destfile = "hello.pdf")}
```

## Reading in the table

There are different ways in which I can read the table. First, I use the `tabulizer` package, from which I can use the `extract_tables` function, with two arguments:

- The file path (in this case: "hello.pdf")
- The page number (in this case, we start at page 24, so let us take that page as an example)


```r
library(tabulizer)

#remotes::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch")

file <- "hello.pdf"

tabulizer::extract_tables(file, pages = 24)
```

```
## [[1]]
##       [,1]                       [,2]     [,3]      [,4]     [,5]     [,6]    
##  [1,] "KABUPATEN/KOTA"           ""       ""        ""       ""       ""      
##  [2,] ""                         "2014"   "2015"    "2016"   "2017*"  "2018**"
##  [3,] "Regency/Municipality"     ""       ""        ""       ""       ""      
##  [4,] "(1)"                      "(2)"    "(3)"     "(4)"    "(5)"    "(6)"   
##  [5,] "01. Kab. Simeulue"        "1.517"  "1.640"   "1.773"  "1.897"  "2.048" 
##  [6,] "02. Kab. Aceh Singkil"    "1.686"  "1.816"   "1.981"  "2.127"  "2.259" 
##  [7,] "03. Kab. Aceh Selatan"    "3.930"  "4.227"   "4.554"  "4.855"  "5.210" 
##  [8,] "04. Kab. Aceh Tenggara"   "3.314"  "3.567"   "3.883"  "4.236"  "4.558" 
##  [9,] "05. Kab. Aceh Timur"      "8.695"  "8.196"   "8.510"  "9.105"  "9.700" 
## [10,] "06. Kab. Aceh Tengah"     "5.463"  "5.875"   "6.307"  "6.722"  "7.184" 
## [11,] "07. Kab. Aceh Barat"      "5.469"  "5.828"   "6.184"  "6.943"  "7.651" 
## [12,] "08. Kab. Aceh Besar"      "9.650"  "10.327"  "10.969" "11.637" "12.501"
## [13,] "09. Kab. Pidie"           "7.255"  "7.862"   "8.490"  "9.187"  "9.904" 
## [14,] "10. Kab. Bireun"          "9.392"  "10.069"  "10.726" "11.411" "12.139"
## [15,] "11. Kab. Aceh Utara"      "19.941" "16.340"  "16.696" "17.542" "18.953"
## [16,] "12. Kab. Aceh Barat Daya" "2.780"  "2.968"   "3.175"  "3.395"  "3.635" 
## [17,] "13. Kab. Gayo Lues"       "1.934"  "2.076"   "2.234"  "2.428"  "2.597" 
## [18,] "14. Kab. Aceh Tamiang"    "5.648"  "5.763"   "6.063"  "6.518"  "7.008" 
## [19,] "15. Kab. Nagan Raya"      "5.457"  "5.775"   "6.159"  "6.571"  "6.931" 
## [20,] "16. Kab. Aceh Jaya"       "1.839"  "1.981id" "2.116"  "2.275"  "2.434" 
## [21,] "17. Kab. Bener Meriah"    "3.312"  "3.55.0"  "3.802"  "3.998"  "4.203" 
## [22,] "18. Kab. Pidie Jaya"      "2.389"  "2o.598"  "2.770"  "3.013"  "3.242" 
## [23,] "71. Kota Banda Aceh"      "13.502" "g14.494" "15.801" "16.685" "17.571"
## 
## [[2]]
##      [,1]                                                 [,2]         
## [1,] "71. Kota Banda Aceh"                                ""           
## [2,] "72. Kota Sabang"                                    ""           
## [3,] "73. Kota Langsa 74. Kota Lhokseumawe"               ""           
## [4,] "75. Kota Subulussalam"                              ""           
## [5,] "Jml Kab./Kota Total of Reg./Mun. Provinsi/Province" "ww  128.246"
##      [,3]           [,4] [,5]              [,6]              [,7]             
## [1,] "13.502"       ""   "14.494"          "15.801"          "16.685"         
## [2,] "992 ."        ""   "1.070"           "1.158"           "1.273"          
## [3,] "3.562ps9.321" ""   "3.875 7.636"     "4.217 7.729"     "4.538 8.070"    
## [4,] ". 1.b201"     ""   "1.295"           "1.400"           "1.536"          
## [5,] "127.897"      ""   "128.831 129.093" "136.698 136.844" "145.962 145.807"
##      [,8]            
## [1,] "17.571"        
## [2,] "1.399"         
## [3,] "4.8908.454"    
## [4,] "1.642"         
## [5,] "156.114155.912"
```

Not bad at all! But as you can see, it read two tables instead of one, and in the second table, it also missed some spaced. Finally ,the row summarizing the total is very confusing for the algorithm. A super useful feature of this package is the ability to select a part of the picture to extract:


```r
extract_areas(file, 24)
```

You can also do this in two or three (or more) parts, and then combine the results to get a data.frame you want. Sometimes, or actually, most of the time, this will still not help you in getting exactly the table you want. One option is to resort to reading the table as a text, and then creating the table you want. 

## Reading the table as text

That is what we will do next. The same `tabulizer` package also allows us to read in text, in the following way:


```r
extract_text(file, 24)
```

```
## [1] "KABUPATEN/KOTA\nRegency/Municipality\n(1) (2) (3) (4) (5) (6)\n01. Kab. Simeulue 1.517            1.640            1.773            1.897            2.048            \n02. Kab. Aceh Singkil 1.686            1.816            1.981            2.127            2.259            \n03. Kab. Aceh Selatan 3.930            4.227            4.554            4.855            5.210            \n04. Kab. Aceh Tenggara 3.314            3.567            3.883            4.236            4.558            \n05. Kab. Aceh Timur 8.695            8.196            8.510            9.105            9.700            \n06. Kab. Aceh Tengah 5.463            5.875            6.307            6.722            7.184            \n07. Kab. Aceh Barat 5.469            5.828            6.184            6.943            7.651            \n08. Kab. Aceh Besar 9.650            10.327          10.969          11.637          12.501          \n09. Kab. Pidie 7.255            7.862            8.490            9.187            9.904            \n10. Kab. Bireun 9.392            10.069          10.726          11.411          12.139          \n11. Kab. Aceh Utara 19.941          16.340          16.696          17.542          18.953          \n12. Kab. Aceh Barat Daya 2.780            2.968            3.175            3.395            3.635            \n13. Kab. Gayo Lues 1.934            2.076            2.234            2.428            2.597            \n14. Kab. Aceh Tamiang 5.648            5.763            6.063            6.518            7.008            \n15. Kab. Nagan Raya 5.457            5.775            6.159            6.571            6.931            \n16. Kab. Aceh Jaya 1.839            1.981            2.116            2.275            2.434            \n17. Kab. Bener Meriah 3.312            3.550            3.802            3.998            4.203            \n18. Kab. Pidie Jaya 2.389            2.598            2.770            3.013            3.242            \n71. Kota Banda Aceh 13.502          14.494          15.801          16.685          17.571          \n72. Kota Sabang 992               1.070            1.158            1.273            1.399            \n73. Kota Langsa 3.562            3.875            4.217            4.538            4.890            \n74. Kota Lhokseumawe 9.321            7.636            7.729            8.070            8.454            \n75. Kota Subulussalam 1.201            1.295            1.400            1.536            1.642            \nJml Kab./Kota Total of Reg./Mun. 128.246        128.831        136.698        145.962        156.114        \nProvinsi/Province 127.897        129.093        136.844        145.807        155.912        \nCatatan/Note: \n#) Merupakan pecahan dari kabupaten yang berada diatasnya/ As a part of Regency/Municipality above\n* Angka sementara/Preliminary figures\n** Angka sangat sementara/Very preliminary figures\nTabel/Table  1.\nPDRB Provinsi Aceh Atas Dasar Harga Berlaku \nMenurut Kabupaten/Kota (miliar rupiah), 2014-2018\nGRDP of Aceh Province at Current Market Prices \nby Regency/Municipality (billion rupiahs), 2014-2018\n2018**201620152014 2017*\n3\nht\ntp\ns:\n//w\nww\n.b\nps\n.g\no.\nid\n"
```

This seems kinda messy, but you will shortly see that this is in fact just what we need. To make this clear, let's do some cleaning:


```r
extract_text(file, 24) %>%
  stringr::str_split("\n") %>%
  lapply(stringr::str_squish) %>%
  magrittr::extract2(1) %>%
  magrittr::extract(4:26) 
```

```
##  [1] "01. Kab. Simeulue 1.517 1.640 1.773 1.897 2.048"       
##  [2] "02. Kab. Aceh Singkil 1.686 1.816 1.981 2.127 2.259"   
##  [3] "03. Kab. Aceh Selatan 3.930 4.227 4.554 4.855 5.210"   
##  [4] "04. Kab. Aceh Tenggara 3.314 3.567 3.883 4.236 4.558"  
##  [5] "05. Kab. Aceh Timur 8.695 8.196 8.510 9.105 9.700"     
##  [6] "06. Kab. Aceh Tengah 5.463 5.875 6.307 6.722 7.184"    
##  [7] "07. Kab. Aceh Barat 5.469 5.828 6.184 6.943 7.651"     
##  [8] "08. Kab. Aceh Besar 9.650 10.327 10.969 11.637 12.501" 
##  [9] "09. Kab. Pidie 7.255 7.862 8.490 9.187 9.904"          
## [10] "10. Kab. Bireun 9.392 10.069 10.726 11.411 12.139"     
## [11] "11. Kab. Aceh Utara 19.941 16.340 16.696 17.542 18.953"
## [12] "12. Kab. Aceh Barat Daya 2.780 2.968 3.175 3.395 3.635"
## [13] "13. Kab. Gayo Lues 1.934 2.076 2.234 2.428 2.597"      
## [14] "14. Kab. Aceh Tamiang 5.648 5.763 6.063 6.518 7.008"   
## [15] "15. Kab. Nagan Raya 5.457 5.775 6.159 6.571 6.931"     
## [16] "16. Kab. Aceh Jaya 1.839 1.981 2.116 2.275 2.434"      
## [17] "17. Kab. Bener Meriah 3.312 3.550 3.802 3.998 4.203"   
## [18] "18. Kab. Pidie Jaya 2.389 2.598 2.770 3.013 3.242"     
## [19] "71. Kota Banda Aceh 13.502 14.494 15.801 16.685 17.571"
## [20] "72. Kota Sabang 992 1.070 1.158 1.273 1.399"           
## [21] "73. Kota Langsa 3.562 3.875 4.217 4.538 4.890"         
## [22] "74. Kota Lhokseumawe 9.321 7.636 7.729 8.070 8.454"    
## [23] "75. Kota Subulussalam 1.201 1.295 1.400 1.536 1.642"
```

Only the last command, `magrittr:extract` contains a parameter, because that's where the actual content of the table is separated from things like the header and footer. In this case, I wanted to extract only the municipalities' info, and not the total or headers or anything, so that's why I went with row 4 to row 26, but I could've included more if I wanted to. 

Let us now write this output to a vector called `data`, and see if we want split up the strings and put the data in a data.frame.


```r
data <- extract_text(file, 24) %>%
  stringr::str_split("\n") %>%
  lapply(stringr::str_squish) %>%
  magrittr::extract2(1) %>%
  magrittr::extract(4:26) 
```

## Splitting up the data in columns

Naturally, we wanted to have a data.frame in which the first and second column contain information about the specific municipality, and all the other numbers afterwards to go to separate variables. Unfortunately, the `stringr::str_split` function, which is the usual way to go about this, has some limitations, forcing us to use either complicated Regex's to get the string to split in chunks we want, or to go with a second-best alternative. Fortunately, I found [this blog](https://www.r-bloggers.com/strsplit-but-keeping-the-delimiter/):



```r
strsplit2 <- function(x,
                     split,
                     type = "remove",
                     perl = FALSE,
                     ...) {
  if (type == "remove") {
    # use base::strsplit
    out <- base::strsplit(x = x, split = split, perl = perl, ...)
  } else if (type == "before") {
    # split before the delimiter and keep it
    out <- base::strsplit(x = x,
                          split = paste0("(?<=.)(?=", split, ")"),
                          perl = TRUE,
                          ...)
  } else if (type == "after") {
    # split after the delimiter and keep it
    out <- base::strsplit(x = x,
                          split = paste0("(?<=", split, ")"),
                          perl = TRUE,
                          ...)
  } else {
    # wrong type input
    stop("type must be remove, after or before!")
  }
  return(out)
}
```

which was exactly what I was looking for: I could use easy Regex, and clean the data in very few steps:



```r
data %>%
  strsplit2("\\s[0-9]+", type = "before") %>%
  purrr::reduce(rbind) %>%
  as.data.frame(row.names = F)
```

```
##                          V1      V2      V3      V4      V5      V6
## 1         01. Kab. Simeulue   1.517   1.640   1.773   1.897   2.048
## 2     02. Kab. Aceh Singkil   1.686   1.816   1.981   2.127   2.259
## 3     03. Kab. Aceh Selatan   3.930   4.227   4.554   4.855   5.210
## 4    04. Kab. Aceh Tenggara   3.314   3.567   3.883   4.236   4.558
## 5       05. Kab. Aceh Timur   8.695   8.196   8.510   9.105   9.700
## 6      06. Kab. Aceh Tengah   5.463   5.875   6.307   6.722   7.184
## 7       07. Kab. Aceh Barat   5.469   5.828   6.184   6.943   7.651
## 8       08. Kab. Aceh Besar   9.650  10.327  10.969  11.637  12.501
## 9            09. Kab. Pidie   7.255   7.862   8.490   9.187   9.904
## 10          10. Kab. Bireun   9.392  10.069  10.726  11.411  12.139
## 11      11. Kab. Aceh Utara  19.941  16.340  16.696  17.542  18.953
## 12 12. Kab. Aceh Barat Daya   2.780   2.968   3.175   3.395   3.635
## 13       13. Kab. Gayo Lues   1.934   2.076   2.234   2.428   2.597
## 14    14. Kab. Aceh Tamiang   5.648   5.763   6.063   6.518   7.008
## 15      15. Kab. Nagan Raya   5.457   5.775   6.159   6.571   6.931
## 16       16. Kab. Aceh Jaya   1.839   1.981   2.116   2.275   2.434
## 17    17. Kab. Bener Meriah   3.312   3.550   3.802   3.998   4.203
## 18      18. Kab. Pidie Jaya   2.389   2.598   2.770   3.013   3.242
## 19      71. Kota Banda Aceh  13.502  14.494  15.801  16.685  17.571
## 20          72. Kota Sabang     992   1.070   1.158   1.273   1.399
## 21          73. Kota Langsa   3.562   3.875   4.217   4.538   4.890
## 22     74. Kota Lhokseumawe   9.321   7.636   7.729   8.070   8.454
## 23    75. Kota Subulussalam   1.201   1.295   1.400   1.536   1.642
```


The example of this method is that it can be used on virtually all tables from the aforementioned .pdf file, requiring very little editing and data wrangling, which saves a lot of time. To domenstrate, let's look at pages 25, 26 and 27, the pages following the original p 24 which I started with. 

- Page 25:


```r
data <- extract_text(file, 25) %>%
  stringr::str_split("\n") %>%
  lapply(stringr::str_squish) %>%
  magrittr::extract2(1) %>%
  magrittr::extract(4:36) #Remember to change this parameter


data
```

```
##  [1] "01. Kab. Nias 2.443 2.677 2.966 3.234 3.509"                     
##  [2] "02. Kab. Mandailing Natal 8.758 9.586 10.660 11.713 12.618"      
##  [3] "03. Kab. Tapanuli Selatan 9.310 10.058 10.965 11.983 12.902"     
##  [4] "04. Kab. Tapanuli Tengah 6.516 7.140 7.850 8.545 9.230"          
##  [5] "05. Kab. Tapanuli Utara 5.429 5.856 6.300 6.766 7.297"           
##  [6] "06. Kab. Toba Samosir 5.173 5.623 6.124 6.642 7.167"             
##  [7] "07. Kab. Labuhan Batu 22.176 24.083 26.505 29.032 31.303"        
##  [8] "08. Kab. Asahan 24.329 26.465 29.207 32.020 34.667"              
##  [9] "09. Kab. Simalungun 25.338 27.147 30.123 32.832 35.445"          
## [10] "10. Kab. Dairi 6.268 6.823 7.484 8.049 8.736"                    
## [11] "11. Kab. Karo 13.817 15.150 16.728 18.066 19.359"                
## [12] "12. Kab. Deli Serdang 69.674 76.735 85.152 93.194 101.120"       
## [13] "13. Kab. Langkat 27.875 30.742 34.105 37.119 39.819"             
## [14] "14. Kab. Nias Selatan 4.298 4.729 5.193 5.696 6.262"             
## [15] "15. Kab. Humbang Hasundutan 4.050 4.413 4.777 5.130 5.524"       
## [16] "16. Kab. Pakpak Bharat 754 826 917 994 1.083"                    
## [17] "17. Kab. Samosir 2.838 3.144 3.443 3.752 4.085"                  
## [18] "18. Kab. Serdang Bedagai 18.457 20.152 22.114 24.095 25.995"     
## [19] "19. Kab. Batu Bara 23.461 25.395 27.555 29.770 31.972"           
## [20] "20. Kab. Padang Lawas Utara 7.448 8.222 9.074 9.904 10.765"      
## [21] "21. Kab. Padang Lawas 7.288 7.853 8.808 9.705 10.591"            
## [22] "22. Kab. Labuhan Batu Selatan 17.601 19.052 21.004 23.196 25.124"
## [23] "23. Kab. Labuhan Batu Utara 16.262 17.620 19.374 21.162 22.750"  
## [24] "24. Kab. Nias Utara 2.319 2.525 2.775 3.008 3.252"               
## [25] "25. Kab. Nias Barat 1.184 1.289 1.414 1.548 1.672"               
## [26] "71. Kota Sibolga 3.429 3.836 4.263 4.645 5.064"                  
## [27] "72. Kota Tanjung Balai 5.439 6.052 6.723 7.425 8.176"            
## [28] "73. Kota Pematang Siantar 9.555 10.566 11.579 12.444 13.177"     
## [29] "74. Kota Tebing Tinggi 3.912 4.288 4.725 5.123 5.513"            
## [30] "75. Kota Medan 148.247 164.722 184.809 203.016 222.482"          
## [31] "76. Kota Binjai 7.649 8.382 9.112 9.905 10.765"                  
## [32] "77. Kota Padang Sidempuan 4.001 4.425 4.903 5.372 5.859"         
## [33] "78. Kota Gunungsitoli 3.212 3.595 4.034 4.503 5.010"
```


```r
data %>%
  strsplit2("\\s[0-9]+", type = "before") %>%
  purrr::reduce(rbind) %>%
  as.data.frame(row.names = F)
```

```
##                               V1       V2       V3       V4       V5       V6
## 1                  01. Kab. Nias    2.443    2.677    2.966    3.234    3.509
## 2      02. Kab. Mandailing Natal    8.758    9.586   10.660   11.713   12.618
## 3      03. Kab. Tapanuli Selatan    9.310   10.058   10.965   11.983   12.902
## 4       04. Kab. Tapanuli Tengah    6.516    7.140    7.850    8.545    9.230
## 5        05. Kab. Tapanuli Utara    5.429    5.856    6.300    6.766    7.297
## 6          06. Kab. Toba Samosir    5.173    5.623    6.124    6.642    7.167
## 7          07. Kab. Labuhan Batu   22.176   24.083   26.505   29.032   31.303
## 8                08. Kab. Asahan   24.329   26.465   29.207   32.020   34.667
## 9            09. Kab. Simalungun   25.338   27.147   30.123   32.832   35.445
## 10                10. Kab. Dairi    6.268    6.823    7.484    8.049    8.736
## 11                 11. Kab. Karo   13.817   15.150   16.728   18.066   19.359
## 12         12. Kab. Deli Serdang   69.674   76.735   85.152   93.194  101.120
## 13              13. Kab. Langkat   27.875   30.742   34.105   37.119   39.819
## 14         14. Kab. Nias Selatan    4.298    4.729    5.193    5.696    6.262
## 15   15. Kab. Humbang Hasundutan    4.050    4.413    4.777    5.130    5.524
## 16        16. Kab. Pakpak Bharat      754      826      917      994    1.083
## 17              17. Kab. Samosir    2.838    3.144    3.443    3.752    4.085
## 18      18. Kab. Serdang Bedagai   18.457   20.152   22.114   24.095   25.995
## 19            19. Kab. Batu Bara   23.461   25.395   27.555   29.770   31.972
## 20   20. Kab. Padang Lawas Utara    7.448    8.222    9.074    9.904   10.765
## 21         21. Kab. Padang Lawas    7.288    7.853    8.808    9.705   10.591
## 22 22. Kab. Labuhan Batu Selatan   17.601   19.052   21.004   23.196   25.124
## 23   23. Kab. Labuhan Batu Utara   16.262   17.620   19.374   21.162   22.750
## 24           24. Kab. Nias Utara    2.319    2.525    2.775    3.008    3.252
## 25           25. Kab. Nias Barat    1.184    1.289    1.414    1.548    1.672
## 26              71. Kota Sibolga    3.429    3.836    4.263    4.645    5.064
## 27        72. Kota Tanjung Balai    5.439    6.052    6.723    7.425    8.176
## 28     73. Kota Pematang Siantar    9.555   10.566   11.579   12.444   13.177
## 29        74. Kota Tebing Tinggi    3.912    4.288    4.725    5.123    5.513
## 30                75. Kota Medan  148.247  164.722  184.809  203.016  222.482
## 31               76. Kota Binjai    7.649    8.382    9.112    9.905   10.765
## 32     77. Kota Padang Sidempuan    4.001    4.425    4.903    5.372    5.859
## 33         78. Kota Gunungsitoli    3.212    3.595    4.034    4.503    5.010
```

- Page 26:


```r
data <- extract_text(file, 26) %>%
  stringr::str_split("\n") %>%
  lapply(stringr::str_squish) %>%
  magrittr::extract2(1) %>%
  magrittr::extract(4:23) #Remember to change this parameter


data %>%
  strsplit2("\\s[0-9]+", type = "before") %>%
  purrr::reduce(rbind) %>%
  as.data.frame(row.names = F)
```

```
##                                  V1       V2       V3       V4       V5
## 1       01. Kab. Kepulauan Mentawai    3.027    3.396    3.726    4.089
## 2          02. Kab. Pesisir Selatan    9.114   10.197   11.271   12.522
## 3                    03. Kab. Solok    9.408   10.165   11.053   11.980
## 4                04. Kab. Sijunjung    6.471    6.955    7.439    7.978
## 5              05. Kab. Tanah Datar    9.178    9.901   10.735   11.620
## 6          06. Kab. Padang Pariaman   14.153   15.846   17.533   19.182
## 7                     07. Kab. Agam   13.918   15.248   16.693   18.220
## 8          08. Kab. Lima Puluh Kota   10.564   11.583   12.678   13.783
## 9                  09. Kab. Pasaman    5.951    6.505    7.336    8.008
## 10           10. Kab. Solok Selatan    3.891    4.236    4.598    4.987
## 11             11. Kab. Dharmasraya    7.155    7.725    8.438    9.282
## 12           12. Kab. Pasaman Barat   10.703   11.713   12.794   14.068
## 13                  71. Kota Padang   41.266   45.093   49.386   53.869
## 14                   72. Kota Solok    2.729    2.965    3.241    3.555
## 15             73. Kota Sawah Lunto    2.514    2.715    2.938    3.214
## 16          74. Kota Padang Panjang    2.348    2.533    2.774    3.028
## 17             75. Kota Bukittinggi    5.636    6.170    6.783    7.453
## 18              76. Kota Payakumbuh    4.181    4.655    5.203    5.757
## 19                77. Kota Pariaman    3.406    3.699    4.037    4.387
## 20 Jml Kab./Kota Total of Reg./Mun.  165.612  181.302  198.656  216.982
##          V6
## 1     4.397
## 2    13.643
## 3    12.801
## 4     8.516
## 5    12.393
## 6    20.639
## 7    19.506
## 8    14.739
## 9     8.530
## 10    5.303
## 11    9.917
## 12   14.997
## 13   58.272
## 14    3.835
## 15    3.461
## 16    3.269
## 17    8.069
## 18    6.342
## 19    4.765
## 20  233.394
```

- And finally, page 27. Let me introduce a more abstract way of recognizing the parameter, making use of `which` to find out in which character string "Jml Kab." is located, so I know at which string to stop:


```r
data <- extract_text(file, 27) %>%
  stringr::str_split("\n") %>%
  lapply(stringr::str_squish) %>%
  magrittr::extract2(1) 

uptothis <- which(stringr::str_detect(data, "Jml Kab."))-1

data <- data %>%
  magrittr::extract(4:uptothis)


data %>%
  strsplit2("\\s[0-9]+", type = "before") %>%
  purrr::reduce(rbind) %>%
  as.data.frame(row.names = F)
```

```
##                            V1       V2       V3       V4       V5       V6
## 1   01. Kab. Kuantan Singingi   24.022   25.195   27.522   29.518   30.652
## 2     02. Kab. Indragiri Hulu   33.762   34.584   37.033   38.740   40.392
## 3    03. Kab. Indragiri Hilir   47.822   51.800   57.292   60.891   60.223
## 4          04. Kab. Pelalawan   35.401   38.176   41.165   43.871   46.154
## 5               05. Kab. Siak   85.736   77.236   78.942   79.619   84.674
## 6             06. Kab. Kampar   68.817   66.285   69.676   71.587   77.197
## 7         07. Kab. Rokan Hulu   25.355   26.907   29.146   31.006   32.311
## 8          08. Kab. Bengkalis  165.899  135.505  132.201  132.994  149.407
## 9        09. Kab. Rokan Hilir   74.546   70.693   73.268   74.030   78.707
## 10 10. Kab. Kepulauan Meranti   15.127   15.152   16.044   16.731   18.186
## 11        71. Kota Pekan Baru   73.841   83.664   92.129  101.112  108.840
## 12             73. Kota Dumai   23.628   25.454   27.962   30.299   32.994
```

## Conclusion

In this post, I attempted to explain, and show, how to easily import tables from .pdf documents in R. I also did not show a couple of other aspects, most notably, endogenous start of data extraction (a little tricker than endogenous ending), and I also did not separate the Identifiers from the names. Neither did I convert all variables to numeric, and gave variable names. If you want to know more about such basic cleaning operations, feel free to message me, or better, go to [the tidyverse website](http://www.tidyverse.org). 
