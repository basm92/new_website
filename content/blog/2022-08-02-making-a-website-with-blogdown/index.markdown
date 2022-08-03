---
title: Making a website with blogdown
author: 'Bas Machielsen'
date: '2020-05-17'
draft: false
excerpt: A blog post about how to make a website using R in a few simple steps.
layout: single
series: null
subtitle: ""
tags: null
---



## Introduction

This is the first blog post on my own website. I've decided to make this website using the R package `blogdown`. The website looks very nice now (in my humble opinion), but it was tedious to make. When attempting to create the website, I first tried out a couple of themes before I settled on the basic "lithium" theme, because it was by far the easiest theme to wrap your head around. I want to summarize some difficulties I experienced while making the website, thereby (possibly) helping people who run into the same or similar problems. 

## Good things

First of all, I think it pays to go over the good things of `blogdown`. You can literally create a site in seconds, by executing:


```r
install.packages('blogdown')

library(blogdown)

# If you haven't done so yet:
blogdown::install_hugo()

blogdown::new_site(theme = "githubrepo/theme") 
# It will pick this 'lithium' theme as the default.
```

RStudio will start up a new directory with a .Rproj file, and you can start filling out some information in the `config.toml` file, which is very intuitive, and you can create some posts by executing `blogdown::new_post()` and your blog is up and running (albeit off-line :) ). You can preview your website by running `blogdown::serve_site()`, in which case it will pop up in your viewer. You also have the possibility to preview your site in your browsers by clicking the 3rd icon on the left (in the viewer). So far the easy part: picking a theme is the first tedious aspect. 

## Picking A Theme

There are a variety of Hugo themes available [**here**](https://themes.gohugo.io/). To reiterate, you can install any one of those themes with `blogdown` by entering `blogdown::new_site(theme = "alex-shpak/hugo-book")` to pick just one random example. As soon as you do that, your website will look exactly like this one:

<img src="https://www.rostrum.blog/post/2019-09-05-blogdown-author-tags-and-categories_files/lithium-default.png" width="450" />

And you can start changing the .toml header to include your own preferences. If you want to keep to the basics, this is pretty much all there is to create a site.

But.

It seems that the way themes are configured internally differs greatly among themes. So themes have wildly different built-in possibilities, and some themes facilitate doing some thing (e.g., creating a timeline of blog posts), whereas others facilitate doing something else (e.g. make an overview of pictures on some page), while making it _very_ difficult to do the other thing.

## Academic

One of the most popular themes seems to be 'Academic'. Whereas I like the look of it (check it out [here](https://themes.gohugo.io//theme/academic/courses/)), I also thought it was completely overwhelming to somebody just starting with `blogdown` and hugo. First of all, the file structure in the basic theme is mind-boggling, so you don't really know where you should start, and second of all, not all basic options are included in the standard config.toml file. That means that if you want to change, for example, your name and profession, you have to find some other way. 

Secondly, one of the things I didn't like about Academic is that you basically have one large `/index/` page, and if you use the menu, it just redirects you to a differrent position on the page. I realize that's more of a subjective thing, but anyway. I don't like scrolling, and I thought it might be nicer to have multiple pages instead of one long one. I'm sure Academic provides the tools and the possibilities to do this, but in that case, you would have to spend a lot of time on familiarizing yourself with the Hugo language, and if you aren't already, with html. 

## Changing your favicon

The next thing which I insisted on doing was to change the icon of my website in your browser to my custom `bas_m` icon. The standard icon is the symbol of the chemical element Lithium, and I thought that wasn't _that_ appropriate for my website. After a while, I figured out the thing is called a _favicon_, and if you have a picture, you can generate free _favicons_ on, for example, [this website](https://favicon.io/). Any other website you find with a Google search will also do. The website will give you a couple of _favicons_ as output, of which you can select the most appropriate, and place it in the `/static/img/` folder of your website. At least, this is the case in the `Lithium` theme which I use. It might be supposed that the _favicon_ should end up somewhere else in a different theme, which illustrate the point that I was trying to get across before: there is a large heterogeneity in configurations among Hugo themes, which does not contribute to user-friendliness, especially for the uninitiated in web development. 

By the way, if you're looking for a nice _favicon_, you can generate one using the R package `hexSticker`. The package's [**github page**](https://github.com/GuangchuangYu/hexSticker) provides some nice examples you can get started with. You might have to install some new fonts, first on your system, and then in R using:


```r
library(extrafont)
font_import(pattern="Roboto")
```

Anyway, that's basically it: you're set-up with your own website, and you got rid of the most annoying features of the standard theme. Next, I address some of the layout which I wanted to get done, and because of which I had to deviate from the standard theme. 

## Html code

One advantage of `blogdown` and similar tools is that you don't have to manually code huge chunks of .html and .css yourself: you can just build a website practically without any knowledge of html or css. However, one of the things that I wanted to get done is including some of my contact information next to the introduction on my [home page](https://bas-m.netlify.app). As far as I know, I could do this in two ways:

- create a custom .html layout for my home page supported by some .css in separate files (I'll talk about this later)
- make use of the possibility that Markdown supports html code, and create a separate `<div>` for my contact info, and wrap my introduction text around it. 

As you hopefully noticed, I opted for the second choice, although the first one would have been possible. The point that I'm trying to make is: if you're looking for even the slightest bit of customization, you _will_ end up having to make some changes in the html or css files of the theme. If you don't want to do that, Hugo and `blogdown` is probably not the best option. If you do, a Hugo website works just great! You don't have to apply _that_ many changes, and you will still end up with a website with a unique flavor, which looks, in my opinion, nicer than a Google or Wordpress website. 


## Arranging the site and blog

Lastly, I wanted to get one more thing done. The Lithium-theme comes with a blog integration, and the Hugo/javascript backend makes it such that as soon as you make a new blog post, a link to the title and the date end up on the index page. I didn't want that. I wanted my index page to be just my own text, and I wanted to relegate my blogs to appear on the page 'Blogs'! As you've guessed, I worked that out, but I thought it was quite tricky, and I ended up finding the solution using my own common sense: the Hugo documentation and searching the fora provided no significant help. 

(To be fair, I know nothing about the Hugo language, but I thought its documentation and fora weren't that accessible either.)

So what I did was the following: I created a new folder in the root directory called `layouts` (this I got from the forums), a subfolder called `_default`, which allows the user to include page-specific layouts that differ from the default, and I copied the first part of the 'list' default layout to a new file called `index.html`: 

```
{{ partial "header.html" . }}

<main class="content" role="main">

  {{ if .Content }}
  <article class="article">
    {{ if .Title }}
    <h1 class="article-title">{{ .Title }}</h1>
    {{ end }}
    <div class="article-content">
      {{ .Content }}
    </div>
  </article>
  {{ end }}

</main>
{{ partial "footer.html" . }}
```

As far as I understand, this gives me an index page with _just_ a header, the content with the appropriate `<h1>, <h2>`'s, etc., and a footer. That worked for the index page. 

Next, I wanted to relegate the blog widget to the blogs page. This was a little more confusing, but what I did was the following: 

1. I created a new .html file in the same /layouts/ folder called **blogs.html**, and I pasted the entire content of the default layout's `list.html` (the default layout, in the Lithium theme, can be found under /themes/hugo-lithium/layouts/_default, but don't change them) to a new page in the `~/layouts/_default` folder. 

2. This didn't work yet. After some initial testing, I found that the Blogs-page wasn't responding at all to changes in the layout file, so I had to do some Googling to find out that I was supposed to explicitly include in the YAML-header of my `Blogs.Rmd` file the item: `layout: blogs` (`blogs` because my layout file was also called blogs.html). After doing that, I found that the layout was responsive to changes, but I still struggled to get the widget to appear. 

3. Finally, what solved the issue was the following: the code of `list.html`, and up until this point, of my `blogs.html` looked like this:

```
{{ partial "header.html" . }}

<main class="content" role="main">

  {{ if .Content }}
  <article class="article">
    {{ if .Title }}
    <h1 class="article-title">{{ .Title }}</h1>
    {{ end }}
    <div class="article-content">
      {{ .Content }}
    </div>
  </article>
  {{ end }}
  <div class="archive">
    {{ $pages := .Pages }}
    {{ if .IsHome }}
    {{ $pages = .Site.RegularPages }}
    {{ end }}
    {{ range (where $pages "Section" "!=" "").GroupByDate "2006" }}
    <h2 class="archive-title">{{ .Key }}</h2>
    {{ range .Pages }}
    <article class="archive-item">
      <a href="{{ .RelPermalink }}" class="archive-item-link">{{ .Title }}</a>
      <span class="archive-item-date">
        {{ .Date.Format "2006-01-02" }}
      </span>
    </article>
    {{ end }}
    {{ end }}
  </div>

</main>

{{ partial "footer.html" . }}
```
4. Specifically, I started to pay attention to the `{{ if .IsHome}}` line, and I thought: "Given that my Blogs page isn't the homepage, shouldn't I change `{{ if .IsHome }}` to `{{ if not .IsHome }}`?" As soon as I did that, the issue was solved!
  
5. For the interested, I figured out that the upper part of the chunk is just Hugo telling us to place the normal content (e.g. introductory text) on the blog page, and then the lower part of the chunk tells us to fetch all the names and dates of the blog posts we've made and put them in a list. 

## Conclusion

After all, that didn't seem that difficult, but it was difficult enough to figure out the logic of Hugo, and in the end, I did end up having to read documentation about a system I was competely unfamiliar with. Anyway, I think it worked out great, and if I want, I can always change the css of the website to give it a more individual flavor. I have to think about that, though: I really like this default layout. Thanks for reading, and hope it helps!
