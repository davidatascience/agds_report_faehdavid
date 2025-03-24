#---- Libraries ----

library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)

# ---- Tabular data ----

# create a data frame with demo data
df <- data.frame(
  col_1 = c("a", "b", "c"),
  col_2 = c("d", "e", "f"),
  col_3 = c(1,2,3)
)

# write table as CSV to disk
write.table(
  x = df,
  file = file.path(tempdir(), "your_file.csv"),
  sep = ",",
  row.names = FALSE
)

# Read a CSV file
df <- read.table(
  file.path(tempdir(), "your_file.csv"),
  header = TRUE,
  sep = ","
)


#---- JSON data ----

# load the library
library("jsonlite")

# write the file to a temporary location
jsonlite::write_json(
  x = df,
  path = file.path(tempdir(), "your_json_file.json")
)

# read the freshly generated json file
df_json <- jsonlite::read_json(
  file.path(tempdir(), "your_json_file.json"),
  simplifyVector = TRUE
)

# check if the two data sets
# are identical (they should be)
identical(df, df_json)


#---- Online data sources ----

# define a URL with data of interest
# in this case annual mean CO2 levels at Mauna Loa
url <- "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_annmean_mlo.csv"

# read in the data directly from URL
df <- read.table(
  url,
  header = TRUE,
  sep = ","
)


#---- API's ----

# load the library
library("MODISTools")

# list all available products
products <- MODISTools::mt_products()

# print the first few lines
# of available products
print(head(products))

# download a demo dataset
# specifying a location, a product,
# a band (subset of the product)
# and a date range and a geographic
# area (1 km above/below and left/right).
# Data is returned internally and the
# progress bar of the download is not shown.
subset <- MODISTools::mt_subset(
  product = "MOD11A2",
  lat = 40,
  lon = -110,
  band = "LST_Day_1km",
  start = "2004-01-01",
  end = "2004-02-01",
  km_lr = 1,
  km_ab = 1,
  internal = TRUE,
  progress = FALSE
)

# print the dowloaded data
print(head(subset))


#---- GET ----

# set API URL endpoint
# for the total sand content
url <- "https://thredds.daac.ornl.gov/thredds/ncss/ornldaac/1247/T_SAND.nc4"

# formulate query to pass to httr
query <- list(
  "var" = "T_SAND",
  "south" = 32,
  "west" = -81,
  "east" = -80,
  "north" = 34,
  "disableProjSubset" = "on",
  "horizStride" = 1,
  "accept" = "netcdf4"
)

# download data using the
# API endpoint and query data
status <- httr::GET(
  url = url,
  query = query,
  httr::write_disk(
    path = file.path(tempdir(), "T_SAND.nc"),
    overwrite = TRUE
  )
)

# to visualize the data
# we need to load the {terra}
# library
library("terra")

sand <- terra::rast(file.path(tempdir(), "T_SAND.nc"))
terra::plot(sand)
