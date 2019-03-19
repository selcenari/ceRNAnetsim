

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
   * [Issues](#issues)
   
 <!--te-->

## Installation

Installation of `regulationSimulatoR`:

```
install.packages("devtools")
devtools::install_github("selcenari/regulationSimulatoR")


library(regulationSimulatoR)

```

## Local Files

The `regulationSimulatoR` provides various datasets for examination of method. These are:

- *minsamp* contents 2 miRNAs and 6 genes which are targeted by them. *new_counts* is a helper dataset for *minsamp*.
- *midsamp* includes 4 miRNAs and 20 competing target genes.
- *huge_example* dataset was obtained by integration of three datasets: NGS-gene expression and miRNA expression of a breast cancer patient and  the mirna target dataset which is had from combined of two different high-throughput experimental studies.
- The other datasets are used to reproducible example of methods shown as [Mirtarbase example](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/mirtarbase_example.html)


## Vignettes

The repository of regulationSimulatoR contents the vignettes that follow:

- [Small example of approach and explanation of method](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/small_sample.html)
- [How to find convenient iteration for simulation of the network](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/convenient_iteration.html)
- [How to determine most effective node of network in equal conditions](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/perturbation_sample.html)
- [How does the system do in the presence of interaction factors?](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/realexample.html)
- [How does the system work only when the amounts of elements are taken into account?](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/mirtarbase_example.html)


## Tests



## Issues

Contact us for any issue or bug via:

- [Issues](https://github.com/selcenari/regulationSimulatoR/issues)
- [Alper Yilmaz](mailto:alperyilmaz@gmail.com)
- [Selcen Ari](mailto:selcenarii@gmail.com)
