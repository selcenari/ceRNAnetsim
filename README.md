

## What does the `ceRNAnetsim` do?

<p align="center">
  <img width="500" height="300" src="https://media.giphy.com/media/l0ErNdz1w5vt3YdZm/giphy.gif">
</p>

`ceRNAnetsim` helps to understanding whole miRNA:target interactions with the network based approach. It uses the amounts of miRNAs and their targets and interaction parameters optionally.


## Table of contents

<!--ts-->
 
   * [Installation](#installation)
   * [Local Files](#local-files)
   * [Vignettes](#vignettes)
   * [Tests](#tests)
   * [License](#license)
   * [Issues](#issues)

   
 <!--te-->

## Installation

Installation of `ceRNAnetsim`:

```
install.packages("devtools")
devtools::install_github("selcenari/ceRNAnetsim")


library(ceRNAnetsim)

```

## Local Files

The `ceRNAnetsim` provides various datasets for examination of method. These are:

- *minsamp* contents 2 miRNAs and 6 genes which are targeted by them. *new_counts* is a helper dataset for *minsamp*.
- *midsamp* includes 4 miRNAs and 20 competing target genes.
- *huge_example* dataset was obtained by integration of three datasets: NGS-gene expression and miRNA expression of a breast cancer patient and  the mirna target dataset which is had from combined of two different high-throughput experimental studies.
- The other datasets are used to reproducible example of methods shown as [Mirtarbase example](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/mirtarbase_example.html)


## Vignettes

The repository of ceRNAnetsim contents the vignettes that follow:

- [Small example of approach and explanation of method](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/small_sample.html)
- [How to find convenient iteration for simulation of the network](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/convenient_iteration.html)
- [How to determine most effective node of network in equal conditions](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/perturbation_sample.html)
- [How does the system do in the presence of interaction factors?](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/realexample.html)
- [How does the system work only when the amounts of elements are taken into account?](https://github.com/selcenari/ceRNAnetsim/blob/master/documents/mirtarbase_example.html)


## Tests

To test package, should run the following:

```
devtools::test()
```

## License

see the [LICENCE.md](https://github.com/selcenari/ceRNAnetsim/blob/master/LICENSE) file for details.

## Issues

Contact us for any issue or bug via:

- [Issues](https://github.com/selcenari/ceRNAnetsim/issues)
- [Alper Yilmaz](mailto:alperyilmaz@gmail.com)
- [Selcen Ari](mailto:selcenarii@gmail.com)
