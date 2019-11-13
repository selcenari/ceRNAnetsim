## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message= FALSE, warning=FALSE---------------------------------------
library(ceRNAnetsim)
library(png)

## ---- message=FALSE, warning= FALSE, eval=FALSE--------------------------
#  if (!requireNamespace("BiocManager", quietly = TRUE))
#      install.packages("BiocManager")
#  BiocManager::install("ceRNAnetsim")

## ---- fig.height=5, fig.width=6, warning=FALSE, message=FALSE, fig.show='hide'----
data("minsamp")

minsamp %>%
  priming_graph(competing_count = Competing_expression, 
                miRNA_count = miRNA_expression) %>%
  update_how("Gene4",2) %>%
  simulate_vis(title = "Minsamp: Common element as trigger", cycle = 15)


minsamp %>%
  priming_graph(competing_count = Competing_expression, 
                miRNA_count = miRNA_expression) %>%
  update_how("Gene4",2) %>%
  simulate(cycle = 5)

## ------------------------------------------------------------------------
data("midsamp")

midsamp

## ---- fig.height=5, fig.width=6, warning=FALSE, message=FALSE, fig.show='hide'----
midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_how("Gene17",2) %>%
  simulate_vis(title = "Midsamp: Gene with higher degree as trigger", 15)

## ------------------------------------------------------------------------
midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_how("Gene2",2) %>%
  simulate(50) %>% 
  find_iteration(limit=0)


## ------------------------------------------------------------------------
data("midsamp_new_counts")

midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_variables(current_counts = midsamp_new_counts) %>%
  simulate(50) %>% 
  find_iteration(limit=0)

## ---- fig.align='center', fig.width=5, fig.height=3, dpi= 120------------
midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_how("Gene17",2) %>%
  simulate(50) %>% 
  find_iteration(limit=0)


## ---- fig.height=5, fig.width=6, warning=FALSE, message=FALSE, fig.show='hide'----
midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_how("Gene17", 2) %>%
  simulate_vis(title = "Midsamp: Gene17 2 fold increase, 25 cycles", 25)

## ---- fig.align='center', fig.height=5, fig.width=6, warning=FALSE, message=FALSE, fig.show='hide'----

midsamp %>%
  priming_graph(Gene_expression, miRNA_expression) %>%
  update_how("Gene17", 2) %>%
  simulate_vis(title = "Midsamp: Gene17 2 fold increase, 6 cycles", 6, threshold = 1)


## ------------------------------------------------------------------------
midsamp %>%
  priming_graph(competing_count = Gene_expression, 
                miRNA_count = miRNA_expression,
                aff_factor = c(Energy,seeds), 
                deg_factor = targeting_region) %>%
  calc_perturbation("Gene17", 3, cycle = 30, limit = 0.1)

## ------------------------------------------------------------------------
primed_mid <- midsamp %>%
  priming_graph(competing_count = Gene_expression, 
                miRNA_count = miRNA_expression,
                aff_factor = c(Energy,seeds), 
                deg_factor = targeting_region)

## ---- eval=FALSE---------------------------------------------------------
#  # for parallel processing
#  # future::plan(multiprocess)
#  
#  seq(2,10) %>%
#    rlang::set_names() %>%
#    furrr::future_map_dfr(~ primed_mid %>% calc_perturbation("Gene17", .x, cycle = 30, limit = 0.1), .id="fold_change")

## ------------------------------------------------------------------------
midsamp %>%
  priming_graph(competing_count = Gene_expression,
                miRNA_count = miRNA_expression,
                aff_factor = c(Energy,seeds),
                deg_factor = targeting_region) %>%
  find_node_perturbation(how = 3, cycle = 4, limit = 0.1)%>%
  select(name, perturbation_efficiency, perturbed_count)

## ------------------------------------------------------------------------
midsamp %>%
  priming_graph(competing_count = Gene_expression,
                miRNA_count = miRNA_expression,
                aff_factor = c(Energy,seeds),
                deg_factor = targeting_region) %>%
  find_node_perturbation(how = 3, cycle = 4, limit = 0.1, fast=5)%>%
  select(name, perturbation_efficiency, perturbed_count)

## ----sessioninfo---------------------------------------------------------
sessionInfo()

