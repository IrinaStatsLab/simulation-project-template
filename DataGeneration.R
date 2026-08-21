#' Data generation when assumptions are correct
#'
#' @param n - sample size
#' @param p - number of covariates
#' @param sigma - standard deviation of the noise
#' @param beta0 - intercept, scalar
#' @param beta - vector of coefficients, same dimension as p
#' @param rho - correlation level of covariates in X (scalar between -1 and 1)
#'
#' @return Y and X, where Y is n-dimensional vector; X is n by p matrix of covariates
generate_Y_given_beta <- function(n, p, sigma, beta0, beta, rho){
  # Generate X with pairwise correlations rho 
  library(mnormt)
  cov_matrix = matrix(rho, p, p) + diag(rep(1 - rho, p))
  X = rmnorm(n = n, mean = rep(0, p), varcov = cov_matrix)
  # Generate epsilon (n-dimensional vector) from normal with standard deviation sigma 
  epsilon <- rnorm(n, mean = 0, sd = sigma) # rnorm(n, mean = 0, sd = 1) * sigma
  # Form Y using X, epsilon, beta0 and beta 
  # Linear model formula
  Y = beta0 + X %*% beta + epsilon
  # return Y and X 
  return(list(Y = Y, X = X))
}

#' Generate beta with given sparsity level s
#'
#' @param p - full dimension
#' @param s - number of non-zeros, number of coefficients in beta that are not zero
#' @param large_size - size in absolute values of large coefficients (scalar)
#' @param small_size - size in absolute values of small coefficients (scalar)
#'
#' @return beta, p-dimensional vector
generate_beta <- function(p, s, large_size, small_size){
  # Allocate space for p - dimensional vector
  beta = rep(0, p)
  # Initialize the s elements as non-zero 
  # Reference - https://stackoverflow.com/questions/29219878/how-to-generate-random-number-between-0-and-1-without-0-and-1-in-r/29219923
  for (i in 1:s){
    if (i %% 2 == 0){
      # around half being large size
      beta[i] = runif(1, min = small_size, max = large_size)
    }else{
      # around half being small size
      beta[i] = runif(1, min = 0, max = small_size)
    }
  }
  # And random sign 
  signs = sample(c(1,-1), size = p, replace = TRUE)
  beta = beta * signs
  # Return beta
  beta = sample(beta)
  return('beta' = beta)
}

