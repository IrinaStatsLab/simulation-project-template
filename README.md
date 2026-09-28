# Simulation project template
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23022141.svg)](https://doi.org/10.5281/zenodo.23022141)

A worked simulation study, structured as a starting point for your own. It
compares ridge regression, lasso, and principal component regression under a
linear model with correlated covariates.

**To start your own project:** click **Use this template** above to create your
own copy, then clone it and open `simulation-project-template.Rproj` in RStudio.

Accompanies [Designing and Reporting Simulation Studies](https://github.com/IrinaStatsLab/structured-research-experience/blob/main/simulation-studies/simulation-guidelines.pdf),
which explains the reasoning behind this structure and how to adapt it.

## Structure

| File | Role |
|---|---|
| `DataGeneration.R` | Generate `X` and `Y`; generate a sparse `beta` |
| `Methods.R` | `applyRidge`, `applyLasso`, `applyPCR` — all with the same interface |
| `Metrics.R` | `MSE`, `L1EstimationError`, and a master `evaluate()` |
| `n50_p10_parallel_replications.R` | The experiment; parallel via `doRNG`, saves `n50p10.Rdata` |
| `Visualize_results.R` | Loads saved output, produces boxplots and a summary table |
| `n50p10.Rdata` | Saved raw per-replication output |
| `Boxplots_comparison.pdf` | The resulting figure |

The three function files contain definitions only; the two scripts do the
calling. To adapt: swap in your own data-generating mechanisms, method wrappers,
and performance measures, keeping the input/output contracts uniform within each
file. The replication and analysis scripts should then need almost no change.

## Running

Open the `.Rproj` file first, so relative paths resolve correctly. Then:

```r
source("n50_p10_parallel_replications.R")   # runs the simulation, saves results
source("Visualize_results.R")               # produces the figure and table
```

Requires `glmnet`, `mnormt`, `pls`, `doParallel`, `doRNG`, `dplyr`, `tidyr`,
`tidyverse`, `xtable`.

## License

© Irina Gaynanova, licensed [CC BY 4.0](LICENSE.md). Suggested attribution:
"Adapted from the Simulation Project Template by Irina Gaynanova, CC BY 4.0."
