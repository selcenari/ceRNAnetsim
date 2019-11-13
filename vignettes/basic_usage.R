## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----pressure, echo=FALSE, fig.align='center', fig.width=6, fig.height=5, dpi=120----

knitr::include_graphics("gifs/model_vignette.png")

## ----setup, message= FALSE, warning=FALSE--------------------------------
library(ceRNAnetsim)

## ----Installation, eval = FALSE------------------------------------------
#  if (!requireNamespace("BiocManager", quietly = TRUE))
#      install.packages("BiocManager")
#  BiocManager::install("ceRNAnetsim")

## ----echo=FALSE----------------------------------------------------------
data("minsamp")
minsamp %>% 
  select(1:4)

## ---- message= FALSE, warning=FALSE, echo=FALSE--------------------------
data("minsamp")
minsamp %>% 
  select(competing, Competing_expression) %>% 
  distinct() -> gene_expression

## ------------------------------------------------------------------------
gene_expression

## ---- message= FALSE, warning=FALSE, echo=FALSE--------------------------
minsamp %>% 
  select(miRNA, miRNA_expression) %>% 
  distinct() -> mirna_expression

## ------------------------------------------------------------------------
mirna_expression

## ---- message= FALSE, warning=FALSE, echo=FALSE--------------------------
minsamp %>% 
  select(competing, miRNA) -> interaction_simple

## ------------------------------------------------------------------------
interaction_simple

## ------------------------------------------------------------------------
interaction_simple %>%
  inner_join(gene_expression, by = "competing") %>%
  inner_join(mirna_expression, "miRNA") -> basic_data

basic_data

## ------------------------------------------------------------------------
#Convertion of dataset to graph.

priming_graph(basic_data, competing_count = Competing_expression, miRNA_count =miRNA_expression)

## ------------------------------------------------------------------------

priming_graph(basic_data, competing_count = Competing_expression, 
              miRNA_count =miRNA_expression) %>%
  update_how(node_name = "Gene2", how=2)


## ------------------------------------------------------------------------

priming_graph(basic_data, competing_count = Competing_expression, 
              miRNA_count =miRNA_expression) %>%
  update_how(node_name = "Gene2", how=2) %>%
  simulate(cycle = 5)


## ------------------------------------------------------------------------
priming_graph(basic_data, competing_count = Competing_expression, 
              miRNA_count =miRNA_expression) %>%
  update_how(node_name = "Gene2", how=2) %>%
  simulate(cycle = 5)%>%
  as_tibble()%>%
  select(name, initial_count, count_current)

## ------------------------------------------------------------------------

priming_graph(basic_data, competing_count = Competing_expression, 
              miRNA_count =miRNA_expression) %>%
  update_how(node_name = "Gene2", how=0) %>%
  simulate(cycle = 5)


## ------------------------------------------------------------------------
minsamp

## ------------------------------------------------------------------------
priming_graph(minsamp, 
              competing_count = Competing_expression, 
              miRNA_count = miRNA_expression,
              aff_factor = c(energy, seed_type), 
              deg_factor = region)

## ----results='hold'------------------------------------------------------
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   update_how(node_name = "Gene4", how = 2) %>% 
   activate(edges)%>%
   # following line is just for focusing on necessary
   # columns to see the change in edge data
   select(3:4,comp_count_pre,comp_count_current)

## ------------------------------------------------------------------------
data(new_counts) 
new_counts

## ------------------------------------------------------------------------
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   update_variables(current_counts = new_counts)


## ------------------------------------------------------------------------
minsamp %>%
  priming_graph(competing_count = Competing_expression, 
                miRNA_count = miRNA_expression,
                aff_factor = c(energy, seed_type), 
                deg_factor = region) %>%
  update_how("Gene4", how = 2) 

# OR
# minsamp %>%
#   priming_graph(competing_count = Competing_expression, 
#                 miRNA_count = miRNA_expression,
#                 aff_factor = c(energy, seed_type), 
#                 deg_factor = region) %>%
#   update_variables(current_counts = new_counts) 

## ----echo=FALSE, fig.align='center', fig.width=10, fig.height=8, dpi=120----
knitr::include_graphics("gifs/small_sample_chunk10.png")

## ------------------------------------------------------------------------
minsamp %>%
  priming_graph(competing_count = Competing_expression, 
                miRNA_count = miRNA_expression,
                aff_factor = c(energy, seed_type), 
                deg_factor = region) %>%
  update_how("Gene4", how = 2) %>%
  simulate(cycle=10) #threshold with default 0.

## ------------------------------------------------------------------------
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   update_how("Gene4", how = 2) %>%
   simulate(cycle=10) %>%
   activate(edges) %>%       #from tidygraph package 
   select(comp_count_list, mirna_count_list) %>%
   as_tibble()  

## ----echo=FALSE, warning=FALSE, message=FALSE----------------------------
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   update_how("Gene4", how = 2) %>%
   simulate(cycle=10) %>%
   activate(edges) %>%       #from tidygraph package 
   select(comp_count_list, mirna_count_list) %>%
   as_tibble() %>% 
   filter(from==4, to==7) %>% 
   pull(comp_count_list) %>% 
   .[[1]] %>% 
   round()


## ------------------------------------------------------------------------
minsamp %>%
  priming_graph(competing_count = Competing_expression, 
                miRNA_count = miRNA_expression,
                aff_factor = c(energy, seed_type), 
                deg_factor = region) %>%
  update_how("Gene4", how = 2) %>%
  simulate(cycle=3, threshold = 1)

## ---- fig.height=4, fig.width=5, warning=FALSE, dpi= 120, fig.align='center'----
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   vis_graph(title = "Minsamp initial Graph")

## ---- fig.height=4, fig.width=5, warning=FALSE, dpi= 120, fig.align='center'----
minsamp %>%
   priming_graph(competing_count = Competing_expression, 
                 miRNA_count = miRNA_expression,
                 aff_factor = c(energy, seed_type), 
                 deg_factor = region) %>%
   update_variables(current_counts = new_counts) %>%
   simulate(3) %>%
   vis_graph(title = "Minsamp Graph After 3 Iteration")

## ---- fig.height=4, fig.width=5, warning=FALSE, message=FALSE, eval=FALSE----
#  minsamp %>%
#     priming_graph(competing_count = Competing_expression,
#                   miRNA_count = miRNA_expression,
#                   aff_factor = c(energy, seed_type),
#                   deg_factor = region) %>%
#     update_variables(current_counts = new_counts) %>%
#     simulate_vis(3, title = "Minsamp Graph After Each Iteration")

## ----sessioninfo---------------------------------------------------------
sessionInfo()

