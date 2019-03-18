## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- message=FALSE------------------------------------------------------
library(regulationSimulatoR)

## ---- echo=FALSE, message= FALSE-----------------------------------------
library(rlang)
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)
library(tidyverse)
library(ggplot2)
library(tidygraph)
library(igraph)
library(ggraph)
library(purrr)
library(future)
library(furrr)
library(png)

## ------------------------------------------------------------------------
data("midsamp")

midsamp

## ------------------------------------------------------------------------
midsamp%>%
priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression, 
              aff_factor = c(Energy,seeds), deg_factor = targeting_region)%>%
    calc_perturbation("Gene17",3, cycle = 30, limit = 0.1)

## ------------------------------------------------------------------------
midsamp%>%
priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression, 
              aff_factor = c(Energy,seeds), deg_factor = targeting_region)%>%
find_node_perturbation(how = 3, cycle = 4, limit = 0.1) 
# each elements in the dataset increases to two fold, and runs 4 iteration. 
#The `limit` symbolizes the percentage of minimum change of node expressions.


