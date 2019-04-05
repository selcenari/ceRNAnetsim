

## What does the `regulationSimulatoR` do?

<p align="center">
  <img width="500" height="300" src="https://media.giphy.com/media/l0ErNdz1w5vt3YdZm/giphy.gif">
</p>
`regulationSimulatoR` helps understanding complex miRNA:target interactions with the network based approach. It utilizes the amounts of miRNAs and their targets and interaction parameters optionally.


## Table of contents

<!--ts-->

   * [Installation](#installation)
   * [Local Files](#local-files)
   * [Vignettes](#vignettes)
   * [License](#license)
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

The `regulationSimulatoR` provides various datasets for experimenting with package functions. These are:

- *minsamp* : the minimum sample consists of 2 miRNAs and 6 genes which are targeted by them. *new_counts* is a helper dataset for *minsamp*.
- *midsamp* : middle-sized sample is a network of 4 miRNAs and 20 competing target genes.
- *huge_example* : this dataset is comprised of a large network which incorporates three datasets: 
  - gene expression levels (RNA-Seq) retrieved from [TCGA-BRCA](https://portal.gdc.cancer.gov/projects?filters=%7B%22op%22%3A%22and%22%2C%22content%22%3A%5B%7B%22op%22%3A%22in%22%2C%22content%22%3A%7B%22field%22%3A%22projects.project_id%22%2C%22value%22%3A%5B%22TCGA-BRCA%22%5D%7D%7D%5D%7D) breast cancer 
  - miRNA expression of a breast cancer patient (from TCGA)
  - and the miRNA:target dataset gathered from two different high-throughput experimental studies. (Link?)
- The remaining datasets are used as reproducible example of methods shown as [Mirtarbase example](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/mirtarbase_example.html)


## Vignettes

The repository of regulationSimulatoR contents the vignettes that follow:

- [Small example demonstrating the approach and the method](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/small_sample.html)
- [How to calculate proper number of iterations for simulation of the network](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/convenient_iteration.html)
- [How to determine most effective node of network in equal conditions](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/perturbation_sample.html)
- [How does the system work only when the amounts of expression are taken into account?](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/mirtarbase_example.html)
- [How does the system behave in the presence of interaction factors?](https://github.com/selcenari/regulationSimulatoR/blob/master/doc/realexample.html)


## License

see the [LICENCE.md](https://github.com/selcenari/regulationSimulatoR/blob/master/LICENSE) file for details.

## Issues

Contact us for any issue or bug via:

- [Issues](https://github.com/selcenari/regulationSimulatoR/issues)
- [Alper Yilmaz](mailto:alperyilmaz@gmail.com)
- [Selcen Ari](mailto:selcenarii@gmail.com)
