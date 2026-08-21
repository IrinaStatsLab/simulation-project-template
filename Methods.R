# Here we will be putting wrappers for implementing the methods
# Overall wrapper for each method should have the same form
# Input: vector Y, matrix X
# Output: estimated beta0 and beta


# Ridge regression 
# We will use glmnet package with alpha = 0

#' @return hatbeta0, hatbeta 
applyRidge <- function(Y, X){

  #Cross validation is applied to select the best lambda 
  cv.out <- cv.glmnet(X, Y, alpha = 0, nfold = 5)
  #This is extracting the best lambda
  bestlam = cv.out$lambda.min
  #Applying ridge regression with the best lambda that was selected  
  out <- glmnet(X, Y, alpha = 0, lambda = bestlam)
  #Getting the beta values
  ridge.coef <- as.vector(predict(out, type = "coefficients", s = bestlam)[1:(ncol(X)+1), ])
  #Extracting the beta values for better output format 
  hatbeta0 <- ridge.coef[1]
  hatbeta <- ridge.coef[2:length(ridge.coef)]
  
  return(list(hatbeta0 = hatbeta0, hatbeta = hatbeta))
}

# Lasso regression
# We will use glmnet package with alpha = 1

#' @return hatbeta0, hatbeta 

applyLasso <- function(Y, X){
  
  #Extracts tuning parameter bestlam
  cv.out <- cv.glmnet(X, Y, alpha = 1, nfold = 5)
  # Uses cross validation to find the tuning parameter

  bestlam = cv.out$lambda.min
  #Gets coefficients for hatbeta0 and hatbeta values and sets using bestlam
  out <- glmnet(X, Y, alpha = 1, lambda = bestlam)
  lasso.coef <- as.vector(predict(out, type = "coefficients", s = bestlam)[1:(ncol(X)+1), ])
  hatbeta0 <- lasso.coef[1]
  hatbeta <- lasso.coef[2:length(lasso.coef)]
  
  return(list(hatbeta0 = hatbeta0, hatbeta = hatbeta))
}


# PCR 
# We will use pls package function pcr with CV (have to set the folds)

# Reference- https://statisticaloddsandends.wordpress.com/2018/10/15/obtaining-the-number-of-components-from-cross-validation-of-principal-components-regression/

#' @return hatbeta0, hatbeta chose from PCR
applyPCR <- function(Y, X){
  
  #Finds the number of components by 5 fold cross validation
  pcr.validate <- pcr(Y ~ X, validation = "CV", segments = 5, scale = TRUE)
  lowest.error <- which.min(RMSEP(pcr.validate)$val[1,,]) - 1
  
  #Gets the coefficients of model with lowest cross validation error
  pcr.model <- pcr(Y ~ X, ncomp = lowest.error, scale = TRUE)
  hatbeta <- as.vector(coef(pcr.model, intercept = TRUE))
  
  hatbeta0 <- hatbeta[1]
  hatbeta <- hatbeta[2:length(hatbeta)]
  
  return(list(hatbeta0 = hatbeta0, hatbeta = hatbeta))
}
