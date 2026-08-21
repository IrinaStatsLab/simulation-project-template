
# Load saved results
n = 50
p = 10
filename.rdata = paste0("n", n, "p", p, ".Rdata") 
load(filename.rdata)

# Organize them into a data frame for later plotting
library(dplyr) 
library(tidyr)
# Init method names & master space holders for all Rdata
methods.names = rownames(results[[1]])
nrep = length(results)
pred_data = data.frame()
# Extract out each method and 
for (i in 1: length(methods.names)){
  # Combine arguments & Metric Performance for ith method
  pred_data_ith = data.frame(method = rep(methods.names[i], nrep),
                             n = rep(n, nrep), 
                             p = rep(p, nrep), 
                             t(sapply(results, function(x) x[i, 1:ncol(results[[1]])])))
  #Store into master data
  pred_data = rbind(pred_data, pred_data_ith)
}
pred_data.long = pivot_longer(pred_data, cols = c(4:5), names_to = "metric", values_to = "error")


# Create beautiful plot
library(tidyverse)
p = pred_data.long %>% ggplot(aes(x = method, y = error, fill = method)) +
  geom_boxplot() +
  facet_grid(~metric)


pdf(file = "Boxplots_comparison.pdf", width = 10, height = 6)
print(p)
dev.off()

# Create beautiful table

# Organize a table in R with the help of tidyverse and dplyr
data_table = pred_data.long %>%
  dplyr::group_by(method, metric) %>%
  dplyr::summarize(mean = mean(error), se = sd(error)/10)

# Get latex syntax using xtable
library(xtable)
latex_table = xtable(data_table)
print(latex_table, include.rownames = FALSE)
