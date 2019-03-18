## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----pressure, echo=FALSE, fig.align='center', fig.width=4, fig.height=3, dpi=120----
knitr::include_graphics("model_vignette.png")

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
data("minsamp")

minsamp

## ------------------------------------------------------------------------
priming_graph(minsamp, competing_count = Competing_expression, miRNA_count = miRNA_expression,
              aff_factor = c(energy, seed_type), deg_factor = region)

## ------------------------------------------------------------------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)

## ------------------------------------------------------------------------
data(new_counts) #The Competing_count of Gene2 node is changed to two fold.)

new_counts


## ------------------------------------------------------------------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_variables(current_counts = new_counts)

## ------------------------------------------------------------------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_how(node_name = "Gene3", how = 2)


## ------------------------------------------------------------------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_variables(current_counts = new_counts)%>%
   update_nodes()

#or

minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_how("Gene2", how = 2)%>%
   update_nodes()


## ------------------------------------------------------------------------

minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_variables(current_counts = new_counts)%>%
   update_nodes()%>%
   simulate(cycle=10)


## ------------------------------------------------------------------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_variables(current_counts = new_counts)%>%
   update_nodes()%>%
   simulate(cycle=10)%>%
   activate(edges)%>%       #from tidygraph package 
   select(comp_count_list, mirna_count_list)

## ---- fig.width=5, fig.height=4, dpi= 120, fig.align='center'------------
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   vis_graph(title = "Minsamp initial Graph")



## ---- fig.height=4, fig.width=5, fig.show='animate', aniopts="controls,loop"----
minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), deg_factor = region)%>%
   update_nodes(once=TRUE)%>%
   update_variables(current_counts = new_counts)%>%
   update_nodes()%>%
   simulate_vis(3, title = "Minsamp Graph After Each Iteration")

