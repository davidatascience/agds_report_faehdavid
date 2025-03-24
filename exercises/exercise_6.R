
#---- Exercise 6 ----

# Libraries
library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)
library("jsonlite")

# load URL's
url_1 <- "https://raw.githubusercontent.com/geco-bern/agds_book/refs/heads/main/book/data/demo_1.csv"
url_2 <- "https://raw.githubusercontent.com/geco-bern/agds_book/refs/heads/main/book/data/demo_2.csv"
url_3 <- "https://raw.githubusercontent.com/geco-bern/agds_book/refs/heads/main/book/data/demo_3.csv"

# read data from URL's
demo_1 <- read.table(
  url_1,
  header = TRUE,
  sep = ","
)

demo_2 <- read.table(
  url_2,
  header = TRUE,
  sep = " "
)

demo_3 <- read.table(
  url_3,
  header = TRUE,
  sep = ";", 
  comment = "|"
)

# combine tables
demo_combined <- bind_rows(demo_1, demo_2, demo_3)

# save in temporary directory
write.table(
  x = demo_combined,
  file = file.path(tempdir(), "demo_combined.csv"),
  sep = ",",
  row.names = FALSE
)

# save as csv
demo_1_csv <- read.table(
  file.path(tempdir(), "demo_combined.csv"),
  header = TRUE,
  sep = ","
)

# write new JSON file 
jsonlite::write_json(
  x = demo_1_csv,
  path = "demo_combined.json"
)
