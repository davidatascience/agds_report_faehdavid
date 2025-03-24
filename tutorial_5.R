#---- Libraries ----
library(ggplot2)
library(readr)
library(lubridate)
library(dplyr)

#---- Code gemäss Skript ----

half_hourly_fluxes <- readr::read_csv("./data/FLX_CH-Lae_FLUXNET2015_FULLSET_HH_2004-2006_CLEAN.csv")

plot(half_hourly_fluxes$TIMESTAMP_START, half_hourly_fluxes$GPP_NT_VUT_REF, type = "l")

ggplot(data = half_hourly_fluxes, aes(x = TIMESTAMP_START, y = GPP_NT_VUT_REF)) +
  geom_line()

# prepare plot data
plot_data <- half_hourly_fluxes |> 
  dplyr::slice(24000:25000)

# plot figure
plotme <- ggplot(
  data = plot_data,
  aes(x = TIMESTAMP_START, y = GPP_NT_VUT_REF)) +
  geom_line() +
  labs(title = "Gross primary productivity", 
       subtitle = "Site: CH-Lae",
       x = "Time", 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

plotme

# read in demo daily data
# as saved in the previous chapter
daily_fluxes <- read_csv("./data/daily_fluxes.csv")

# Aggregate to monthly
mdf <- daily_fluxes |> 
  dplyr::mutate(month = month(date, label = TRUE)) |> 
  dplyr::group_by(month) |> 
  dplyr::summarise(GPP_NT_VUT_REF = mean(GPP_NT_VUT_REF))

# Bar plot
plot_1 <- ggplot(
  data = mdf,
  aes(x = month, y = GPP_NT_VUT_REF)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(title = "Bar plot",
       x = "Month", 
       y =expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")))

# Custom plot
plot_2 <- ggplot(
  data = mdf,
  aes(x = month, y = GPP_NT_VUT_REF)) +
  geom_segment(aes(x = month, xend = month, y = 0, yend = GPP_NT_VUT_REF), 
               size = 3, color = "grey40") +
  geom_point(aes(x = month, y = GPP_NT_VUT_REF), size = 8, color = "tomato") +
  geom_text(aes(x = month, y = GPP_NT_VUT_REF, label = format(GPP_NT_VUT_REF, digits = 2)),
            size = 3, color = "white") +
  theme_classic() +
  labs(title = "Custom plot",
       x = "Month", 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  scale_y_continuous(limits = c(0, 8.75), expand = c(0, 0)) +
  coord_flip()

# combine plots
cowplot::plot_grid(plot_1, plot_2)


# subset plot data and count occurences of bad data (NEE_VUT_REF_QC == 0)
df_count <- half_hourly_fluxes |> 
  dplyr::filter(NEE_VUT_REF_QC == 0) |> 
  dplyr::group_by(NIGHT) |> 
  dplyr::summarise(count = n())

# separate aggregation  
plot_1 <-ggplot(
  data = df_count,
  aes(x = NIGHT, y = count)) +
  geom_bar(stat = "identity") +
  labs(subtitle = "Count via 'summarise' and 'stat = identiy'") +
  theme_classic()

# prepare data (not summarizing counts)
half_hourly_fluxes_bad <- half_hourly_fluxes |> 
  dplyr::filter(NEE_VUT_REF_QC == 0)

# implicit aggregation by 'stat'
plot_2 <- ggplot(
  data = half_hourly_fluxes_bad,
  aes(x = NIGHT)) +
  geom_bar(stat = "count") +
  labs(subtitle = "Count directly via 'stat = count'") +
  theme_classic()

# combine plots
cowplot::plot_grid(plot_1, plot_2)

ggplot(
  data = half_hourly_fluxes,
  aes(x = GPP_NT_VUT_REF, y = ..density..)
) +
  geom_histogram(fill = "grey70", color = "black") +
  geom_density(color = "red") +  # we can overlay multiple plot layers!
  labs(title = "Histogram and density", 
       x = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

# prepare plot data
set.seed(1985)  # for random number reproducibility in sample_n() and jitter
half_hourly_fluxes_subset <- half_hourly_fluxes |> 
  sample_n(300) |> 
  mutate(Night = ifelse(NIGHT == 1, TRUE, FALSE))

# Boxplot 
plot_1 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = Night, y = VPD_F)) +
  geom_boxplot(fill = "grey70") +
  labs(title = "Boxplot") +
  labs(y = "VPD (hPa)") +
  theme_classic()

# Box plot + jittered points
plot_2 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = Night, y = VPD_F)) +
  geom_boxplot(fill = "grey70", outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.3) +
  labs(title = "Boxplot + jitter points") +
  labs(y = "VPD (hPa)") +
  theme_classic()

# Violin plot
plot_3 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = Night, y = VPD_F)) +
  geom_violin(fill = "grey70") +
  labs(title = "Violin plot") +
  labs(y = "VPD (hPa)") +
  theme_classic()

# combine plots
cowplot::plot_grid(plot_1, plot_2, plot_3, ncol = 3)

# prepare plot data
half_hourly_fluxes_subset <- half_hourly_fluxes |>
  sample_n(1000)

# a
plot_1 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF)) +
  geom_point(size = 0.75) +
  geom_smooth(method = "lm", color = "red") +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")), 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

# b
plot_2 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF, color = NIGHT)) +
  geom_point(size = 0.75) +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")), 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

# c
plot_3 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF, color = as.factor(NIGHT))) +
  geom_point(size = 0.75) +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")), 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

# d
plot_4 <- ggplot(
  data = half_hourly_fluxes_subset,
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF, color = TA_F)) +
  geom_point(size = 0.75) +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")),
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic() +
  scale_color_viridis_c()

# combine plots
cowplot::plot_grid(plot_1, plot_2, plot_3, plot_4, ncol = 2, labels = "auto")

# prepare data
daily_fluxes <- daily_fluxes |>
  dplyr::mutate(month = month(date, label = TRUE))

ggplot(
  data = daily_fluxes,
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF, color = month)) +
  geom_point(alpha = 0.5) +
  geom_smooth(formula = y ~ x + 0, method = "lm", se = FALSE) +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")), 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")) ) +
  theme_classic() +
  scico::scale_color_scico_d(palette = "romaO")

ggplot(
  data = daily_fluxes, # reusing the previously subset data (see above)
  aes(x = SW_IN_F, y = GPP_NT_VUT_REF)) +
  geom_point(alpha = 0.4) +
  geom_smooth(formula = y ~ x + 0, method = "lm", color = "red", se = FALSE) +
  labs(x = expression(paste("Shortwave radiation (W m"^-2, ")")), 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")) ) +
  facet_wrap(~month)

ggplot(
  data = daily_fluxes,
  aes(x = date, y = GPP_NT_VUT_REF)) +
  geom_line() +
  labs(title = "Line plot", 
       x = "Time", 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  theme_classic()

ggplot(
  data = daily_fluxes,
  aes(x = date, y = GPP_NT_VUT_REF)) +
  geom_line() +
  geom_point(aes(color = f_measured), size = 0.9) +
  labs(x = "Time", 
       y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")"))) +
  scale_color_viridis_c(direction = -1) + # inverse color scale is more intuitive here
  theme_classic()

# prepare plot data
daily_mean_fluxes <- daily_fluxes |>
  mutate(doy = yday(date)) |> 
  group_by(doy) |> 
  summarise(GPP_NT_VUT_REF = mean(GPP_NT_VUT_REF))

# seasonal cycle, cartesian
plot_1 <- ggplot(
  data = daily_mean_fluxes,
  aes(doy, GPP_NT_VUT_REF)) + 
  geom_line() + 
  labs(y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")),
       x = "Day of year")

# seasonal cycle, polar
plot_2 <- ggplot(
  data = daily_mean_fluxes,
  aes(doy, GPP_NT_VUT_REF)) + 
  geom_line() +
  coord_polar() + 
  labs(y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")),
       x = "Day of year")

# prepare plot data (diurnal step)
daily_mean_hourly_fluxes <- half_hourly_fluxes |>
  mutate(month = month(TIMESTAMP_START)) |> 
  filter(month == 6) |>  # taking only June data
  mutate(hour = hour(TIMESTAMP_START)) |> 
  dplyr::group_by(hour) |> 
  dplyr::summarise(GPP_NT_VUT_REF = mean(GPP_NT_VUT_REF))

# diurnal cycle, cartesian
plot_3 <- ggplot(
  data = daily_mean_hourly_fluxes,
  aes(hour, GPP_NT_VUT_REF)) + 
  geom_line() + 
  labs(y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")),
       x = "Hour of day")

# diurnal cycle, polar
plot_4 <- ggplot(
  data = daily_mean_hourly_fluxes,
  aes(hour, GPP_NT_VUT_REF)) + 
  geom_line() +
  coord_polar() + 
  labs(y = expression(paste("GPP (", mu,"mol CO"[2], " m"^-2, "s"^-1, ")")),
       x = "Hour of day")

# combine plots
cowplot::plot_grid(plot_1, plot_2, plot_3, plot_4, ncol = 2, labels = "auto")

plotme
ggsave("./figures/plot_gpp.pdf")
