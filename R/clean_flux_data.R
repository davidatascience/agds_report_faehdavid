clean_flux_data <- function(data){
  # select only the variables we are interested in
  data |> dplyr::select(TIMESTAMP,
                        GPP_NT_VUT_REF,    # the target
                        ends_with("_QC"),  # quality control info
                        ends_with("_F"),   # includes all all meteorological covariates
                        -contains("JSB")   # weird useless variable
  ) |>
    
    # convert to a nice date object
    dplyr::mutate(TIMESTAMP = lubridate::ymd(TIMESTAMP)) |>
    
    # set all -9999 to NA
    mutate(across(where(is.numeric), ~na_if(., -9999))) |> 
    
    # retain only data based on >=80% good-quality measurements
    # overwrite bad data with NA (not dropping rows)
    dplyr::mutate(GPP_NT_VUT_REF = ifelse(NEE_VUT_REF_QC < 0.8, NA, GPP_NT_VUT_REF),
                  TA_F           = ifelse(TA_F_QC        < 0.8, NA, TA_F),
                  SW_IN_F        = ifelse(SW_IN_F_QC     < 0.8, NA, SW_IN_F),
                  LW_IN_F        = ifelse(LW_IN_F_QC     < 0.8, NA, LW_IN_F),
                  VPD_F          = ifelse(VPD_F_QC       < 0.8, NA, VPD_F),
                  PA_F           = ifelse(PA_F_QC        < 0.8, NA, PA_F),
                  P_F            = ifelse(P_F_QC         < 0.8, NA, P_F),
                  WS_F           = ifelse(WS_F_QC        < 0.8, NA, WS_F)) |> 
    
    # drop QC variables (no longer needed)
    dplyr::select(-ends_with("_QC")) |>
    dplyr::select(-P_F) # drop P_F because for Laegern, the whole column is NA
}
