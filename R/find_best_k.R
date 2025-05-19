find_best_k <- function(results_dataframe){
  
  # find best k
  best_k <- results_dataframe[which.min(results_dataframe$MAE_test), ]
  
  # select only columns k and MAE_test
  best_k <- best_k |> select(k, MAE_test)
  
  # Return the result as data frame
  return(best_k)
  
}
