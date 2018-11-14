#mv ~/Downloads/mt_2_results.csv .
library(tidyverse)
library(dplyr)
library(knitr)
library(fs)
library(janitor)
library(scales)
library(stringr)

js <- read_csv("mt_2_results.csv")
js <- js %>% 
  unite("statedistrict", c("state", "district"), sep ="")



download.file(url = "https://goo.gl/ZRCBda",
                            destfile = "master.zip",
                            quiet = TRUE,
                            mode = "wb")

filenames <- dir_ls("2018-live-poll-results-master/data/")

house <- map_dfr(filenames, read_csv, .id = "source")

house <- house %>% 
  filter(! str_detect(source, pattern = "gov"),
         ! str_detect(source, pattern = "sen")) %>% 
  separate(source, c("a", "b", "c", "d", "e", "f", "g", "h", "statedistrict", "wave", "k")) %>% 
  select(-a, -b, -c, -d, -e, -f, -g, -h, -k) %>% 
  filter(wave == "3")
house$statedistrict <- str_to_upper(house$statedistrict)


combined <- left_join(house, js, by = "statedistrict")
combined
