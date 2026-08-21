# One function for each metric that takes hatbeta0, hatbeta from the method; something from the data (depends on the metric), and returns the metric value
yhat <- function(hatbeta0, hatbeta, X) {
  yhat = hatbeta0 + X %*% hatbeta
  return(yhat)
}

# MSE 
MSE <- function(yhat, Y) {
  return(mean((yhat - Y) ^ 2))
}


# ell1 estimation error
L1EstimationError <- function(hatbeta, truebeta) {
  L1normVal <- sum(abs(truebeta - hatbeta))
  return(L1normVal)
} 


# master function, all metrics together
evaluate <- function(hatbeta0,
           hatbeta,
           truebeta,
           Y_test,
           X_test) {
    
    # Prediction metric
    yhat_test = yhat(hatbeta0, hatbeta, X_test)
    mse_test = MSE(yhat_test, Y_test)
    
    # Estimation metric
    l1norm = L1EstimationError(hatbeta, truebeta)
    
    return(
      list(
        "MSE Test" = mse_test,
        'L1 Norm' = l1norm
      )
    )
  }