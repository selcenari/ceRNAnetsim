
## ceRNAnetsim

<!-- badges: start -->
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/selcenari/ceRNAnetsim/master?urlpath=rstudio) [![Travis build status](https://travis-ci.org/selcenari/ceRNAnetsim.svg?branch=master)](https://travis-ci.org/selcenari/ceRNAnetsim)
  [![Codecov test coverage](https://codecov.io/gh/selcenari/ceRNAnetsim/branch/master/graph/badge.svg)](https://codecov.io/gh/selcenari/ceRNAnetsim?branch=master)
<!-- badges: end -->


<p align="center">
  <img width="500" height="300" src="https://media.giphy.com/media/l0ErNdz1w5vt3YdZm/giphy.gif">
</p>

`ceRNAnetsim` helps to understanding complex miRNA:target interactions with the network based approach. It utilizes the amounts of miRNAs and their targets and interaction parameters optionally.


## Installation

Installation of `ceRNAnetsim`:

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ceRNAnetsim")

library(ceRNAnetsim)

```

## Example

```
data("minsamp")

minsamp

priming_graph(minsamp, 
                competing_count = Competing_expression, 
                miRNA_count = miRNA_expression)

```


## Local Files

The `ceRNAnetsim` provides various datasets for experimenting with package functions. These are:

- *minsamp* : the minimum sample consists of 2 miRNAs and 6 genes which are targeted by them. *new_counts* is a helper dataset for *minsamp*.
- *midsamp* : middle-sized sample is a network of 4 miRNAs and 20 competing target genes.
- *huge_example* : this dataset is comprised of a large network which incorporates three datasets: 
  - gene expression levels (RNA-Seq) retrieved from [TCGA-BRCA](https://portal.gdc.cancer.gov/projects?filters=%7B%22op%22%3A%22and%22%2C%22content%22%3A%5B%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22projects.project_id%22%2C%22value%22%3A%5B%22TCGA-BRCA%22%5D%7D%7D%5D%7D) breast cancer 
  - miRNA expression of a breast cancer patient (from TCGA)
  - and the miRNA:target dataset gathered from two different high-throughput experimental studies. ([CLASH](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3650559/) & [CLEAR-CLiP](https://www.nature.com/articles/ncomms9864) methods)
- The remaining datasets are used as reproducible example of methods shown as [Mirtarbase example](https://selcenari.github.io/ceRNAnetsim/articles/mirtarbase_example.html)

## Vignettes

The repository of ceRNAnetsim contents the vignettes that follow:

- [What does ceRNAnetsim do?](https://selcenari.github.io/ceRNAnetsim/articles/basic_usage.html)
- [How to calculate proper number of iterations for simulation of the network](https://selcenari.github.io/ceRNAnetsim/articles/convenient_iteration.html)
- [How does the system do in a real-world network?](https://selcenari.github.io/ceRNAnetsim/articles/mirtarbase_example.html)
- [Helper functions for users.](https://selcenari.github.io/ceRNAnetsim/articles/auxiliary_commands.html)

Also see [package webpage](https://selcenari.github.io/ceRNAnetsim/)


## Issues

Contact us for any issue or bug via:

- [Issues](https://github.com/selcenari/ceRNAnetsim/issues)
- [Alper Yilmaz](mailto:alperyilmaz@gmail.com)
- [Selcen Ari](mailto:selcenarii@gmail.com)

