find_optimal_k <- function(k){
  
  # define data frame to store results
  mae_test_set <- data.frame(k = numeric(), MAE_test = numeric())
  
  for(i in seq(1, k)){
    
    # fit model 
    mod_knn <- caret::train(
      pp, 
      data = daily_fluxes_train |> drop_na(), 
      method = "knn",
      trControl = caret::trainControl(method = "none"),
      tuneGrid = data.frame(k = i),
      metric = "RMSE"
    )
    
    # add predictions to the data frames
    df_test <- daily_fluxes_test |> 
      drop_na()
    df_test$fitted <- predict(mod_knn, newdata = df_test)
    
    # get metrics tables
    metrics_test <- df_test |> 
      yardstick::metrics(GPP_NT_VUT_REF, fitted)
    
    # extract values from metrics tables
    mae_test <- metrics_test |> 
      filter(.metric == "mae") |> 
      pull(.estimate)
    
    # store results in data frame
    mae_test_set <- bind_rows(
      mae_test_set,
      data.frame(k = i, 
                 MAE_test = mae_test))
  }
  
  # find best k
  best_k <- mae_test_set[which.min(mae_test_set$MAE_test), ]
  
  # Return the result as data frame
  return(best_k)
}
