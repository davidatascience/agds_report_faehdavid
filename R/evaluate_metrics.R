evaluate_metrics <- function(mod, df_train, df_test){
  
  # add predictions to the data frames
  df_train <- df_train |> 
    drop_na()
  df_train$fitted <- predict(mod, newdata = df_train)
  
  df_test <- df_test |> 
    drop_na()
  df_test$fitted <- predict(mod, newdata = df_test)
  
  # get metrics tables
  metrics_train <- df_train |> 
    yardstick::metrics(GPP_NT_VUT_REF, fitted)
  
  metrics_test <- df_test |> 
    yardstick::metrics(GPP_NT_VUT_REF, fitted)
  
  # extract values from metrics tables
  mae_train <- metrics_train |> 
    filter(.metric == "mae") |> 
    pull(.estimate)
  rsq_train <- metrics_train |> 
    filter(.metric == "rsq") |> 
    pull(.estimate)
  
  mae_test <- metrics_test |> 
    filter(.metric == "mae") |> 
    pull(.estimate)
  rsq_test <- metrics_test |> 
    filter(.metric == "rsq") |> 
    pull(.estimate)
  
  # Store results in a data frame
  results <- data.frame(
    RSQ_train = rsq_train,
    MAE_train = mae_train,
    RSQ_test = rsq_test,
    MAE_test = mae_test)
  
  # Return the results as a data frame
  return(results)
}
