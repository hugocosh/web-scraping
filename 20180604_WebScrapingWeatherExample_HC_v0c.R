
# Web scraping of weather forecasting websites

# help for using rvest package for web scraping
# http://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/

# rvest for web scraping
library(rvest)

# magrittr for piping %>% 
library(magrittr)

# set up list of dates for the week to come
date0 <- Sys.Date()
dates <- c(date0 +1, date0 +2, date0 +3, date0 +4, date0 +5, date0 +6, date0 +7)
dates <- format(dates, format = "%a %d %b")





### BBC forecast data 
#################################################################


# get data from BBC weather web page
bbc_weather <- read_html("https://www.bbc.co.uk/weather/2653822")

# tricky bit is using developer tools (F12) in the browser to find the right CSS classes to "grab"

## get daily temps

# rather than running this command for day0, day1 etc, turn into a function:

# original command:
bbc_weather %>% html_node("#daylink-3 .wr-value--temperature--c") %>% html_text()

# turns into this function:
fn_temp_bbc <- function(x){
  bbc_weather %>% html_node(paste0("#daylink-", x, " .wr-value--temperature--c")) %>% html_text()
}

# run function for days 0 to 6
bbc_temps <- lapply(0:6, fn_temp_bbc)

# turn results from list to vector
bbc_temps <- unlist(bbc_temps)



## get daily description

# rather than running this command for day0, day1 etc, turn into a function

# original command:
bbc_weather %>% html_node("#daylink-1 .wr-day__weather-type-description-container") %>% html_text()

# turns into this function:
fn_desc_bbc <- function(x){
  bbc_weather %>% html_node(paste0("#daylink-", x, " .wr-day__weather-type-description-container")) %>% html_text()
}

# run function for days 0 to 6
bbc_desc <- lapply(0:6, fn_desc_bbc)

# turn results from list to vector
bbc_desc <- unlist(bbc_desc)





### Met office forecast data
#################################################################

# get data from Met office web page 
metoffice_weather <- read_html("https://www.metoffice.gov.uk/weather/forecast/gcjszmp44")

## get daily temps

# rather than running this command for day0, day1 etc, turn into a function

# original command:
metoffice_weather %>%  html_node("#tabDay0 .tab-temp-high") %>%  html_text()

# turns into this function:
fn_temp_met <- function(x){
  metoffice_weather %>%  html_node(paste0("#tabDay", x, " .tab-temp-high")) %>%  html_text()
}

# run function for days 0 to 6
met_temps <- lapply(0:6, fn_temp_met)

# turn results from list to vector
met_temps <- unlist(met_temps)



## get daily description

# rather than running this command for day0, day1 etc, turn into a function

# original command:
day1met_desc <- metoffice_weather %>%  html_node("#tabDay0 .summary-text.hide-xs-only") %>% html_text()
day1met_desc <- substr(day1met_desc, 2, nchar(day1met_desc)-2)

# turns into this function:
fn_desc_met <- function(x){
  desc <- metoffice_weather %>%  html_node(paste0("#tabDay", x, " .summary-text.hide-xs-only")) %>%  html_text()
  desc <- substr(desc, 2, nchar(desc)-2)
  return(desc)
  }

# run function for days 0 to 6
met_desc <- lapply(0:6, fn_desc_met)

# turn results from list to vector
met_desc <- unlist(met_desc)



# Now create dataset incorporating BBC and Met office forecasts
week_forecast <- data.frame(dates, bbc_temps, bbc_desc, met_temps, met_desc)
colnames(week_forecast) <- c("date", "BBC temp", "BBC description", "Met office temp", "Met office description")

week_forecast


