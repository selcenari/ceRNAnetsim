## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----message= FALSE, warning=FALSE---------------------------------------
library(ceRNAnetsim)

## ---- eval=FALSE---------------------------------------------------------
#  if (!requireNamespace("BiocManager", quietly = TRUE))
#      install.packages("BiocManager")
#  BiocManager::install("ceRNAnetsim")

## ---- warning= FALSE, message=FALSE--------------------------------------
data("mirtarbasegene")
head(mirtarbasegene)

## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_normal")
head(TCGA_E9_A1N5_normal)

## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_tumor")
head(TCGA_E9_A1N5_tumor)

## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_mirnatumor")
head(TCGA_E9_A1N5_mirnatumor)

## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_mirnanormal")
head(TCGA_E9_A1N5_mirnanormal)

## ------------------------------------------------------------------------
TCGA_E9_A1N5_mirnanormal %>%
  inner_join(mirtarbasegene, by= "miRNA") %>%
  inner_join(TCGA_E9_A1N5_normal, 
             by = c("Target"= "external_gene_name")) %>%
  select(Target, miRNA, total_read, gene_expression) %>%
  distinct() -> TCGA_E9_A1N5_mirnagene

## ---- echo=FALSE---------------------------------------------------------

TCGA_E9_A1N5_mirnagene%>%
  group_by(Target, miRNA)%>%
  count()%>%
  filter(n==2)

TCGA_E9_A1N5_mirnagene %>%    
  group_by(Target) %>%        
  mutate(gene_expression= max(gene_expression)) %>%
  distinct() %>%
  ungroup() -> TCGA_E9_A1N5_mirnagene


## ------------------------------------------------------------------------
head(TCGA_E9_A1N5_mirnagene)

## ------------------------------------------------------------------------
TCGA_E9_A1N5_mirnagene%>%
  filter(gene_expression > 10)->TCGA_E9_A1N5_mirnagene

## ---- warning=FALSE, eval=FALSE------------------------------------------
#  
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read) %>%
#    update_how(node_name = "HIST1H3H", how =30) %>%
#    simulate(20) %>%
#    find_iteration(plot=TRUE)
#  

## ---- eval=FALSE---------------------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read) %>%
#    update_how("HIST1H3H", 30) %>%
#    simulate(20)%>%
#    as_tibble()%>%
#    mutate(FC= count_current/initial_count)%>%
#    arrange(desc(FC))

## ---- eval=FALSE---------------------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read)%>%
#    calc_perturbation(node_name= "HIST1H3H", cycle=20, how= 30,limit = 0.1)
#  

## ---- warning=FALSE, eval=FALSE------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read) %>%
#    update_how(node_name = "ACTB", how =1.87) %>%
#    simulate(20) %>%
#    find_iteration(plot=TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read) %>%
#    update_how("ACTB", 1.87) %>%
#    simulate(20)%>%
#    as_tibble()%>%
#    mutate(FC= count_current/initial_count)%>%
#    arrange(desc(FC))

## ---- eval=FALSE---------------------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read)%>%
#    calc_perturbation(node_name= "ACTB", cycle=20, how= 1.87,limit = 0.1)

## ---- eval=FALSE---------------------------------------------------------
#  TCGA_E9_A1N5_mirnagene %>%
#    priming_graph(competing_count = gene_expression,
#                  miRNA_count = total_read)%>%
#    calc_perturbation(node_name= "ACTB", cycle=20, how= 30,limit = 0.1)

## ---- message=FALSE, warning=FALSE---------------------------------------
data("huge_example")
head(huge_example)

## ------------------------------------------------------------------------
huge_example %>%
  add_count(competing) %>%
  filter(n > 5) %>%
  select(-n) -> filtered_example

head(filtered_example)

## ---- eval=FALSE---------------------------------------------------------
#  filtered_example %>%
#    priming_graph(competing_count = competing_counts,
#                  miRNA_count = mirnaexpression_normal,
#                  aff_factor = Energy) %>%
#    update_how("GAPDH", 5) %>%
#    vis_graph(title = "Distribution of GAPDH gene node")

## ---- fig.height=5, fig.width=6, fig.align='center', warning=FALSE, eval=FALSE----
#  filtered_example %>%
#    priming_graph(competing_count = competing_counts,
#                  miRNA_count = mirnaexpression_normal,
#                  aff_factor = Energy) %>%
#    update_how("GAPDH", 5) %>%
#    simulate_vis(title = "GAPDH over expression in the real dataset", 3)

## ---- eval=FALSE---------------------------------------------------------
#  
#  huge_example%>%
#    priming_graph(competing_count = competing_counts, miRNA_count = mirnaexpression_normal)%>%
#    find_node_perturbation(how=5, cycle=3, fast = 3)%>%
#    select(name, perturbation_efficiency, perturbed_count)

## ---- eval=FALSE---------------------------------------------------------
#  huge_example%>%
#    priming_graph(competing_count = competing_counts, miRNA_count = mirnaexpression_normal)%>%
#    find_node_perturbation(how=5, cycle=3, fast = 3)%>%
#    filter(!is.na(perturbation_efficiency), !is.na(perturbed_count))%>%
#    select(name, perturbation_efficiency, perturbed_count)

## ----sessioninfo---------------------------------------------------------
sessionInfo()

