

# Web scraping introduction
# Hugo Cosh April 2020

# what's it for?
# what are the pitfalls?  (hard to get CSS classes; website might change CSS classes)

# help for using rvest package for web scraping
# http://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/

# rvest for web scraping
library(rvest)

# magrittr for piping %>% 
library(magrittr)


############
# Original example

# scrape the BBC news website
bbc_headlines <- read_html("https://www.bbc.co.uk/news")

# what's the main BBC news headline today?
bbc_headlines %>% html_node(".gs-c-promo-heading__title") %>% html_text()

############



# Step 1: use 'read_html' function (xml2 package) to grab all the HTML data from a website
bbc_headlines <- read_html("https://www.bbc.co.uk/news")

# Step 2: use 'html_node' function (rvest package) to extract a piece from the HTML data
the_bit_we_want <- html_node(bbc_headlines, ".gs-c-promo-heading__title")

# Step 3: use 'html_text' function (rvest package) to turn the piece of HTML data into text
html_text(the_bit_we_want)


# Shortcut method: all three steps in one go, using piping
bbc_headlines %>% html_node(".gs-c-promo-heading__title") %>% html_text()

# Try the shortcut method for the 'LIVE' headline
bbc_headlines %>% html_node(".lx-c-dynamic-promo__title") %>% html_text()


# Advantage of this, obviously, is that once you know the 'box' you are referencing
# on the website of interest, you can automatically get data from there without
# going to the website:

# what's the Sun newspaper headline today?
read_html("https://www.thesun.co.uk/") %>% html_node(".teaser__subdeck") %>% html_text()
