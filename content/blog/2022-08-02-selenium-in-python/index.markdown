---
title: Selenium in Python
author: 'Bas Machielsen'
date: '2020-07-15'
draft: false
excerpt: Introducing how to use Selenium in a Python inferface.
layout: single
series: null
subtitle: ""
tags: null
---





## Introduction

This is a small user guide to getting Selenium to work in Python (on a MacOS). In my experience, the Python-Selenium combo works a little bit more smoothly than the R variant. Python seems to be a little bit faster, but the real advantage comes from not having to use Docker: your system will just load a browser (which you can see), and then program, using a `for` loop, for instance. 

Throughout this guide, I also make use of `reticulate`, a package to enable Python in R (as I'm writing this in RMarkdown). First, we start with a small setup. 

## Setup in R

Getting Python to work in an RStudio environment is very easy. You need the package `reticulate`, and depending on your OS, and your version of Python, you can 'load in' Pyton by executing either:



```r
library(reticulate)
use_python("path/to/pythoninstallation")
```

which comes down to the following in my case (I use the Anaconda Python distribution):


```r
library(reticulate)
use_python("/opt/anaconda3/bin/python3")
```

You can check whether a Python distribution is available on your system by executing (Macs have a version of Python installed by default, or so I understand): 


```r
py_available()
```

The cool thing about this is that you can access Python-objects in R, and R objects in Python, as demonstrated [here](https://rstudio.github.io/reticulate/articles/r_markdown.html) for example. 

## Setup of Selenium in Python

Now, let's get back to business. I've done another guide of Selenium in R, and the `RSelenium` package, R's Selenium client, insists (kind of) that we use Docker. This is nice, but not for the uniniated. Selenium in Python can be used without it, and I prefer that, as I can keep an eye on what happens and do some debugging on the spot. 

First, we need a couple of libraries: the `webdriver` part is the equivalent to R's `RSelenium`, and gives us a few commands (which differ sharply from R's Selenium interface!) to instruct the driver what to do. I also need `time`, to give the browser some time to load, after performing various steps. Finally, I need `BeautifulSoup` and `pandas` for webscraping and data-tidying, respectively. 


```python
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException   

import time
import os 

from bs4 import BeautifulSoup
import pandas as pd
```

I also need a selenium driver for the browser I want to use. I have opted for Firefox, which uses a driver called geckodriver, but you can any browser that provides a selenium-driver. A short overview can be found in the table on [this page](https://www.selenium.dev/documentation/en/webdriver/driver_requirements/). 


```python
#os.chdir("/Users/basmachielsen/")

browser = webdriver.Firefox(executable_path='./geckodriver')
```

At this point, a browser window opens! We can 'control' this browser window the way we are used to, but of course, the point of selenium is to write a program that controls this systematically for you. Let's demonstrate this briefly using the website [Thuisbezorgd](www.thuisbezorgd.nl), the largest Dutch food delivery website. 

## Short Demonstration

First, I navigate to the website, and search for a location, e.g. Utrecht Centraal station. Note that I use `time.sleep` to give the browser enough time to load. It is very easy to find elements and click them, as demonstrated by: 
- finding them by CSS selector,
- entering something (or not)
- and then clicking them. 


```python
browser.delete_all_cookies()

browser.get("http://www.thuisbezorgd.nl")
time.sleep(2)
try: 
    browser.find_element_by_xpath('//button[text()="OK"]').click()
except:
    print("Geen cookies meer")

elem = browser.find_element_by_xpath('//input')
elem.clear()
elem.send_keys("Utrecht Centraal", Keys.RETURN)

time.sleep(2)
elem.send_keys(Keys.DOWN, Keys.RETURN, Keys.RETURN)
```

I end up on a page with all available restaurants in the neighbourhood. I save the html-code for this page: 


```python
time.sleep(5)
content = browser.page_source
```

Next, I want to extract the names of these restaurants. I can do that by making a list, and then using beautifulSoup's `findAll` method to find all elements that meet certain criteria:


```python
time.sleep(2)
soup = BeautifulSoup(content)

names = list()
for a in soup.findAll('h3', href=False, attrs={'data-qa':'restaurant-info-name'}):
    names.append(a.text.strip())

# Print the names
print(names[:10])
```

```
## ['Wagamama', "The Ice Cream Shop - Ben & Jerry's en Magnum ijs", 'Hola Empanadas', 'Eazie', 'Cafetaria Ten Beste', 'Left Eat Right', 'Itoshii HC', 'Krishna Vilas Utrecht', "O'Tacos", 'Ritos - Fresh Mex en Pokébowls']
```

Now I have a list with names of restaurants. Now, let's do two more things: first, some restaurants have been extracted twice (because, for some reason, they feature on the page twice), so let's correct that. 


```python
restos = list(set(names))
```

And secondly, let's extract the rating for all of those restaurants by using a `for` loop around all restaurants. This consists of a couple of parts:

We find the name of the restaurant on this page, click it, wait for a second, and click on 'Beoordelingen' (Ratings). 


```python
elem = browser.find_element_by_partial_link_text(names[0]) #Example restaurant
time.sleep(2)
elem.send_keys(Keys.RETURN)

time.sleep(3)

elem = browser.find_element_by_xpath('//span[contains(.,"Beoordelingen")]')
elem.click()
```

We put the page in html, and find the `<div>` in which the rating is located:


```python
content = browser.page_source
soup = BeautifulSoup(content)

thediv = soup.findAll('div', attrs={"data-qa":"card-element"})
```

We find the `<span>` inside the div in which the rating is stored, and store the object together with the name of the restaurant in a list, which we append in each iteration. 


```python
time.sleep(5)
rating = browser.find_element_by_xpath('//div[@data-qa="heading"]').text
 
restaurating = list()
restaurating.append((names[0], rating))
```


```python
print(restaurating)
```

```
## [('Wagamama', '3')]
```
Finally, we go back to the main page:


```python
browser.back()
browser.back()
```

## Everything together

Let's do the same thing in a `for` loop, adding a few tweaks that improve the robustness of the code in case of failures, and allowing for a few sleeps to prevent request overload:


```python
def scroll_down(spt = 0.7):
  SCROLL_PAUSE_TIME = spt
  # Get scroll height
  last_height = browser.execute_script("return document.body.scrollHeight")
  while True:
    # Scroll down to bottom
    browser.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    # Wait to load page
    time.sleep(SCROLL_PAUSE_TIME)
    # Calculate new scroll height and compare with last scroll height
    new_height = browser.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
      break
    last_height = new_height
```


```python
def go_to_main_page():
  
  browser.delete_all_cookies()
  browser.get("http://www.thuisbezorgd.nl")
  time.sleep(2)
  try: 
    browser.find_element_by_xpath('//button[text()="OK"]').click()
  except:
    print("Geen cookies meer")
  elem = browser.find_element_by_xpath('//input')
  elem.clear()
  elem.send_keys("Utrecht Centraal", Keys.RETURN)
  time.sleep(3)
  elem.send_keys(Keys.DOWN, Keys.RETURN, Keys.RETURN)
  time.sleep(4)
  scroll_down()
  time.sleep(2)
```


```python
restaurating = list()

for i in restos[:7]: #Remember, in restos, all names of restaurants are stored
    #Get to the restaurant page
    go_to_main_page()
    try:
      elem = browser.find_element_by_partial_link_text(i)
      time.sleep(1)
      elem.click()
      time.sleep(3)
      elem = browser.find_element_by_xpath('//span[contains(.,"Beoordelingen")]')
      time.sleep(1)
      elem.click()
      time.sleep(2.5)
      #Find the location of the rating element on the web page
      rating = browser.find_element_by_xpath('//div[@data-qa="heading"]').text
      #Put the name and the retrieved rating in a tuple in a list
      restaurating.append((i, rating))
      
    except NoSuchElementException:
      continue

    time.sleep(1)
```

This is what happens on your screen while the code is executing: your browser is *actually* visiting all those pages, extracts the HTML code, and finds the appropriate number to extract!

![](/Jul-15-2020 20-04-13.gif)


```python
restaurating
```

```
## [('Schnitzel Utreg', '4,4'), ('La Fortuna', '2,8'), ('Dogma', '4'), ('Torii Sushi', '4,3'), ('Studio Sugar Snap', '4,8'), ('Deluxe', '3,9')]
```

Finally, after all this is done, we close the browser. (You can verify this by observing that the browser actually closes on your screen :) )


```python
browser.close()
```

## Conclusion

In this post, I have attempted to explain how to use Selenium in Python, and *en passant*, how to use Python in RStudio. I hope you enjoyed reading this, and please [feel free to get in touch](mailto:a.h.machielsen@uu.nl) if you have any questions or remarks. 
