#--- Libraries ----

library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)

#---- Aufgabe 1 ----

half_hourly_fluxes <- read_csv("./data/FLX_CH-Lae_FLUXNET2015_FULLSET_HH_2004-2006.csv")

spurious_values <- half_hourly_fluxes |>
  select(GPP_NT_VUT_REF) |>
  duplicated()

half_hourly_fluxes <- half_hourly_fluxes |>
  mutate(spurious = spurious_values)

half_hourly_fluxes[spurious]




