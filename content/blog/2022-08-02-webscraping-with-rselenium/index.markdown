---
title: Webscraping with RSelenium
author: 'Bas Machielsen'
date: '2020-05-27'
draft: false
excerpt: A post about how to use the Selenium package in R to retrieve data scraped from the web. 
layout: single
series: null
subtitle: ""
tags: null
---




## Introduction

In this blogpost, I want to tell you about web scraping using `RSelenium`, something which I've recently been learning and which I am very enthusiastic about, because it is very powerful. I want to do this in the context of an example. I have been supervising undergraduate students, and a group of students asked me where they could get a list of members of the Iranian parliament. So I went to [the official English-language website](https://en.parliran.ir/eng/en/10th%20Term) of the Iranian parliament, and looked up the list of members. 

Naturally, I wanted to scrape all of these names. For those of you familiar with scraping, a first approach would be something like the following. For those who aren't, I have another nice blog post about elementary web scraping, but maybe you can follow along! 

- First, we observe, by looking at the html-structure of the page, that all the names are stored in a `<div>` of class `text-left h4`. 

- We can use [CSS selectors](https://www.w3schools.com/css/css_selectors.asp) to find the specific elements of these classes:


```r
library(rvest)
url <- "https://en.parliran.ir/eng/en/10th%20Term"

read_html(url) %>%
  html_nodes("div .text-left.h4:not(.blue)")
```

Here I am saying, select all nodes (separate chunks of html, be it `<p>`, `<a>`, `<div>` or something else), that are `<div>`, and have the classes `text-left`, `h4`, and don't have `blue`. (The reason for no blue is that it would take some unnecessary information. Try it out yourself!)

Now, we can extract the names with the help of the `html_text` command from the `rvest` package, which extract all text inside these particular html-elements:


```r
read_html(url) %>%
  html_nodes("div .text-left.h4:not(.blue)") %>%
  html_text()
```

Don't worry about the `Name:` parts for now. We'll clean those later. 

The difficulty is: these are obviously not all members of Iran's parliament. If you go to the [actual website](https://en.parliran.ir/eng/en/10th%20Term), you will notice that there are pages 1 to 10 (and up to 29), which you can click. But if you do so, the page's URL does not change! That means we cannot readily scrape the names of all members by navigating to a new URL. Here, `RSelenium` comes into play.

## RSelenium

- What is Selenium?

>  Selenium is a project focused on automating web browsers. 

from [this vignette](https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html). In layman's terms, Selenium creates 'robot browsers' that you can control by giving commands. 

- What is RSelenium?

> The goal of RSelenium is to make it easy to connect to a Selenium Server/Remote Selenium Server from within R. RSelenium provides R bindings for the Selenium Webdriver API.

> RSelenium allows you to carry out unit testing and regression testing on your webapps and webpages across a range of browser/OS combinations. This allows us to integrate from within R testing and manipulation of popular projects such as Shiny Apps.

Originally, RSelenium was used primarily to test apps by creating virtual environments of different browsers, and see how they look/behave. We will be using it to create a virtual browser, give it some commands, and extract data in a `for` loop as we go. Specifically, we will use the virtual browser to navigate through each of the 10 pages, and scrape all the names as we go along!

## Setting up a Virtual Browser

To get `RSelenium` working, we need two things: [Docker](https://www.docker.com/why-docker) to set up a server to run the virtual browser on, and the `RSelenium` package. 

In Ubuntu, the OS of my preference, Docker can be installed in the following way:

```{}
$ sudo apt-get install docker.io
```

.. and you start it, up and test whether it is working by executing the following query in the command bash:

```{}
$ sudo service docker start

$ sudo docker run hello-world
```


Following which you should get the following output:

```{}
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:6a65f928fb91fcfbc963f7aa6d57c8eeb426ad9a20c7ee045538ef34847f44f1
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```

## Installing RSelenium

You can install and load RSelenium in the way you're used to:


```r
install.packages('RSelenium')
```

It seems that `devtools` is required to get Selenium working, so load it with:

```r
library(devtools)
library(RSelenium)
```

Now you can start up a Selenium-server (in command prompt) by entering:

```{}
$ sudo docker run -d -p 4445:4444 selenium/standalone-chrome
```

Check if it's working by entering `docker ps` in command prompt, following which you should get a list containing the one server you just set up, and some additional information (CONTAINER ID, IMAGE, etc.)

You can replace chrome by any other browser, and the version no. by a specific desired version number of your liking, by entering e.g. `$ sudo docker run -d -p 4445:4444 selenium/standalone-chrone:1.0.0` Now, back in R, we use `RSelenium` to connect to the server we've just created:


```r
remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                 port = 4445L,
                                 browserName = "chrome")
```

And we can start navigating, just like we would do in a real browser:


```r
remDr$open()

remDr$navigate("http://bas-m.netlify.app") 
```

The only difference is that we know explicitly write down our activities (clicks, filling in forms, etc.) using a few simple commands. The basic commands used to navigate a browser can be found [here](https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html), for example. 

## Scraping in R Using Selenium

Now, let's get back to the job we started with: scraping the names of Iranian MP's! We know how to navigate to the desired webpage in RSelenium, and we know we want the following: 

1. We want to scrape all MP's names on page 1. 
2. We want to go to page 2.
3. We want to scrape all MP's names on page 2.
4. Etc. etc. until page 29

Let us start with the sample case - we scrape all names from page 1, and then click on page 2, and scrape all names from that page:


```r
#By default, we end up at page 1
remDr$navigate("https://en.parliran.ir/eng/en/10th%20Term")

remDr$getPageSource() %>%
  magrittr::extract2(1) %>%
  read_html() %>%
  html_nodes("div .text-left.h4:not(.blue)") %>%
  html_text()
```

Notice that we used the same CSS Selector as before to get the names. If all pages have a similar markup, then we can use the same CSS Selector on every page. We'll soon find out whether that's the case. Let us store the obtained names in a vector:


```r
names <- remDr$getPageSource() %>%
  magrittr::extract2(1) %>%
  read_html() %>%
  html_nodes("div .text-left.h4:not(.blue)") %>%
  html_text()
```

.. and attempt to navigate to page two:


```r
remDr$navigate("https://en.parliran.ir/eng/en/10th%20Term")

remDr$findElement(using = "css", 'input[value="2"]') -> elem
elem$clickElement()
```

Now we have navigated to page 2! Let us now find the names on page 2:


```r
remDr$getPageSource() %>%
  magrittr::extract2(1) %>%
  read_html() %>%
  html_nodes("div .text-left.h4:not(.blue)") %>%
  html_text()
```

And let's also store them in `names`, the vector we've made before:


```r
names <- c(names, 
           remDr$getPageSource() %>%
                magrittr::extract2(1) %>%
                read_html() %>%
                html_nodes("div .text-left.h4:not(.blue)") %>%
                html_text()
)

names
```

## Scraping all pages

Let us now proceed to scrape all pages at once, meaning, using one `for` loop! We can make clever use that the values of the CSS selectors for the buttons are numbers 1 to 29, so we can use that to generate code to go to the next page after storing the results of the current page. For clarity's sake, we start from scratch, closing our current session:


```r
remDr$close()
```

And assuming only that we've set up our Selenium server using Docker:


```r
remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                 port = 4445L,
                                 browserName = "chrome")

remDr$open()

remDr$navigate("https://en.parliran.ir/eng/en/10th%20Term")

#Page 1
names <- remDr$getPageSource() %>%
  magrittr::extract2(1) %>%
  read_html() %>%
  html_nodes("div .text-left.h4:not(.blue)") %>%
  html_text()

#Page 2 to 29
for(i in 2:29) {
  #Get the correct CSS Selector for each page
  element <- paste('input[value="x"]')
  element <- stringr::str_replace(element, "x", as.character(i))
  
  #Click on page i button
  remDr$findElement(using = "css", element) -> clickthis
  clickthis$clickElement()
  
  #Scrape the names
  names <- c(names, 
             remDr$getPageSource() %>%
               magrittr::extract2(1) %>%
               read_html() %>%
               html_nodes("div .text-left.h4:not(.blue)") %>%
               html_text()
  )
  
  names
  
}
```

And here we have it! 286 names! 


```r
head(names)
```

Let's clean them quickly, for completness' sake:


```r
names %>%
  stringr::str_replace("Name:", "") %>%
  tail()
```

## Final Showcase: Capturing Names and Biographical Information

So far the small tutorial, of which I hope it was easy enough for any readers to follow along. Now, I want to illustrate some more serious applications: some of you might have noticed that the names also contain links to personalized pages of the MP's, which in turn contains `<div>`'s with personal (biographical) information. I want to do this in 3 steps:

1. I gather all the links of the MP's over the 10 pages.
2. I go to each of those 286 links and extract the information
3. I clean the data obtained in step 2. 

## Step 1: Gather all links

In this step, I use `RSelenium` to browse through each of the ten pages, and extract the hyperlink for each politician on a particular page (check out the CSS Selector that I use). 


```r
remDr$navigate("https://en.parliran.ir/eng/en/10th%20Term")
links <- NULL

for(i in 1:29){
  
  #Get the correct CSS Selector for each page
  element <- paste('input[value="x"]')
  element <- stringr::str_replace(element, "x", as.character(i))
  
  #Click on page i button
  remDr$findElement(using = "css", element) -> clickthis
  clickthis$clickElement()
  
  
  #Extract all the hyperlinks to politician's pages on page i
  links <- c(links, 
             remDr$getPageSource() %>%
                magrittr::extract2(1) %>%
                read_html() %>%
                html_nodes('div.col-lg-10 a[target="_blank"]') %>%
                html_attr("href")
  )
  
  links
  
}
```

And there they are!


```r
head(links)
```

## Step 2: Go to the Links and Extract Information

In this step, I will go through each of the 286 obtained links, and extract the necessary information.


```r
info <- list()
for(i in 1:length(links)){
  info[[i]] <- read_html(links[i]) %>%
    html_nodes("div.col-lg-7 p") %>%
    html_text() %>%
    stringr::str_trim(side = "both") %>%
    .[. != ""] 
}
```


## Step 3: Cleaning the Data

Finally, I can do some cleaning exercises, to make sure the data can be used easily by myself and others. You can download the obtained data [here](/iranianmps.csv)!


```r
iranianmps <- lapply(info, data.frame) %>%
  lapply(setNames, "var") %>%
  lapply(tidyr::separate, var, sep = ":", into = c("var", "val")) %>%
  lapply(tidyr::pivot_wider, names_from = "var", values_from = "val") %>%
  purrr::reduce(dplyr::bind_rows)
```

## Conclusion

In this blog post, I demonstrated how to install and use RSelenium in the context of scraping information about Iranian Members of Parliament. I hope it was useful to some of you aiming to learn RSelenium, and tears down some barriers to first usage. Anyway, after you're done, you can close the connection with the Selenium server in R with:


```r
remDr$close()
```

And if you want to shut down your Selenium server in Docker, go to command prompt:

```{}
$ docker kill [CONTAINER_ID]
```

where [CONTAINER_ID] is a string corresponding to the CONTAINDER_ID box of your server. Thank you for reading, and if you have any questions, you can always [contact me](mailto:a.h.machielsen@uu.nl). 
