
# Source all the necessary functions
source("Metrics.R")
source("Methods.R")
source("DataGeneration.R")

# Make sure the packages are also installed
require(glmnet)
require(mnormt)
require(pls)

# Number of replications per model
nrep = 100

# Set up the parameters for the simulation setting (only for the illustration purpose)
n_train = 50
n_test = 50
p = 10
s = 10
sigma = 1
beta0 = 0
rho = 0.8 # 0 0.8
large_size = 4 # 4 2
small_size = 1 # 1 0.5

# This is the cluster initialization.
library(doParallel)
library(doRNG)
nworkers <- detectCores() 
cl <- makeCluster(nworkers)
registerDoParallel(cl)

# Set the seed. 
set.seed(12345)

# Perform replications using foreach (parallel for loop). Note that it is necessary to pass any packages that are needed through a special parameter .packages. In our case, the methods rely on glmnet, pls, etc., and data generation relies on mnormt, so those should be all listed
results <- foreach(i = 1:nrep, .packages = c('glmnet', "mnormt", "pls")) %dorng% {
  # Data generation
  # True beta
  true_beta <- generate_beta(p, s, large_size, small_size)
  # Training data
  data_train <- generate_Y_given_beta(n_train, p, sigma, beta0, beta = true_beta, rho)
  Y_train = data_train$Y
  X_train = data_train$X
  # Test data
  data_test <- generate_Y_given_beta(n_test, p, sigma, beta0, beta = true_beta, rho)
  Y_test = data_test$Y
  X_test = data_test$X
  
  # Create a place holder for the output, could be list or data.frame or matrix
  # Decided to do matrix for simplicity
  output = matrix(NA, 3, 2) # here 3 rows is the number of methods; 2 columns is the number of metrics
  rownames(output) = c("Ridge", "Lasso", "PCR")
  
  # Apply all 3 methods
  out_Ridge = applyRidge(Y_train, X_train)
  metrics_Ridge = evaluate(out_Ridge[[1]], out_Ridge[[2]], true_beta, Y_test, X_test)
  
  out_Lasso = applyLasso(Y_train, X_train)
  metrics_Lasso = evaluate(out_Lasso[[1]], out_Lasso[[2]], true_beta, Y_test, X_test)
  
  out_PCR = applyPCR(Y_train, X_train)
  metrics_PCR = evaluate(out_PCR[[1]], out_PCR[[2]], true_beta, Y_test, X_test)
  
  output[1, ] = unlist(metrics_Ridge)
  output[2, ] = unlist(metrics_Lasso)
  output[3, ] = unlist(metrics_PCR)
  colnames(output) = names(metrics_Ridge)
  
  # output is the only thing that is saved after each replication
  output
}
# stop cluster
stopCluster(cl)

# Save the resulting results list as the output of simulation. I usually have a separate script that loads the output, and produces figures/tables as needed.
filename.rdata = paste0("n", n_train, "p", p, ".Rdata") 
save(results, file = filename.rdata)


