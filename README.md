

## What does the `regulationSimulatoR` do?

<p align="center">
  <img width="500" height="300" src="https://media.giphy.com/media/l0ErNdz1w5vt3YdZm/giphy.gif">
</p>

`regulationSimulatoR` helps to understanding whole miRNA:target interactions with the network based approach. It uses the amounts of miRNAs and their targets and interaction parameters optionally.


## Table of contents

<!--ts-->
 
   * [Installation](#installation)
   * [Local Files](#local-files)
   * [Vignettes](#vignettes)
   * [Tests](#tests)
   * [Issues[(#issues)
   
 <!--te-->

## Installation

Installation of `regulationSimulatoR`:

```
install.packages("devtools")
devtools::install_github("...../regulationSimulatoR")


library(regulationSimulatoR)

```

## Local Files

The `regulationSimulatoR` provides various datasets for examination of method. These are:

- *minsamp* contents 2 miRNAs and 6 genes which are targeted by them. *new_counts* is a helper dataset for *minsamp*.
- *midsamp* includes 4 miRNAs and 20 competing target genes.
- *huge_example* dataset was obtained by integration of three datasets: NGS-gene expression and miRNA expression of a breast cancer patient and  the mirna target dataset which is had from combined of two different high-throughput experimental studies.
- The other datasets are used to reproducible example of methods shown as [mirtarbase_example](



## Vignettes



## Tests



## Issues

