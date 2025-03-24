#---- Libraries ----

library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(stringr)
library(purrr)


#---- Code nach Skript ----

half_hourly_fluxes <- readr::read_csv("./data/FLX_CH-Lae_FLUXNET2015_FULLSET_HH_2004-2006.csv") # load data
half_hourly_fluxes

half_hourly_fluxes <- select( # select variables of intrest
  half_hourly_fluxes,
  starts_with("TIMESTAMP"),
  ends_with("_F"),
  GPP_NT_VUT_REF,
  NEE_VUT_REF_QC,
  starts_with("SWC_F_MDS_"),
  -contains("JSB"),
  NIGHT
)

as.character(half_hourly_fluxes$TIMESTAMP_START[[1]]) # timestamps are considered by R as a numeric variable with 12 digits

half_hourly_fluxes <- half_hourly_fluxes |> 
  mutate(across(starts_with("TIMESTAMP_"), ymd_hm)) # convert timestamps into date-time objects

half_hourly_fluxes["TIMESTAMP_START"]

plot(
  half_hourly_fluxes[1:(2*24),]$TIMESTAMP_START, 
  half_hourly_fluxes[1:(2*24),]$SW_IN_F,
  type = "l"
)

plot(
  half_hourly_fluxes[1:(365*2*24),]$TIMESTAMP_START,
  half_hourly_fluxes[1:(365*2*24),]$SW_IN_F,
  type = "l"
)

daily_fluxes <- half_hourly_fluxes |> 
  mutate(date = as_date(TIMESTAMP_START)) |>   # converts time object to a date object
  group_by(date) |> 
  summarise(GPP_NT_VUT_REF = mean(GPP_NT_VUT_REF, na.rm = TRUE),
            n_datapoints = n(), # counts the number of observations per day
            n_measured = sum(NEE_VUT_REF_QC == 0), # counts the number of actually measured data (excluding gap-filled and poor quality data)
            SW_IN_F = mean(SW_IN_F, na.rm = TRUE),  # we will use this later
            .groups = 'drop' # to un-group the resulting data frame
  ) |> 
  mutate(f_measured = n_measured / n_datapoints) # calculate the fraction of measured values over total observations
write_csv(daily_fluxes, file = "data/daily_fluxes.csv")
daily_fluxes

plot(daily_fluxes[1:365,]$date, daily_fluxes[1:365,]$SW_IN_F, type = "l") # plot daily fluxes within one year

half_hourly_fluxes <- half_hourly_fluxes |>   # converts -9999 to NA
  mutate(across(where(is.numeric), ~na_if(., -9999)))

half_hourly_fluxes |>  # demonstrates the change from -9999 to NA
  select(TIMESTAMP_START, starts_with("SWC_F_MDS_")) |> 
  head()

half_hourly_fluxes |>  # picks data where NEE is based on actual measurement or good quality gap-filling
  mutate(GPP_NT_VUT_REF = ifelse(NEE_VUT_REF_QC %in% c(0,1), GPP_NT_VUT_REF, NA))

half_hourly_fluxes |>  # drops rows containing NA
  drop_na()

write_csv(half_hourly_fluxes, file = "data/FLX_CH-Lae_FLUXNET2015_FULLSET_HH_2004-2006_CLEAN.csv")

current_wd()
