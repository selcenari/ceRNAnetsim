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

## ---- fig.height=4, fig.width=5, fig.show='animate', aniopts="controls,loop"----
data("minsamp")

minsamp%>%
   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
   update_nodes(once=TRUE)%>%
   update_how("Gene4",2)%>%
  update_nodes()%>%
   simulate_vis(title = "Minsamp: Common element as trigger", 15)


## ---- fig.height=4, fig.width=5, fig.show='animate', aniopts="controls,loop"----
data("midsamp")

midsamp

midsamp%>%
priming_graph(Gene_expression, miRNA_expression)%>%
  update_nodes(once = TRUE)%>%
  update_how("Gene17",2)%>%
  update_nodes()%>%
   simulate_vis(title = "Minsamp: Common element as trigger", 15)

## ------------------------------------------------------------------------
find_iteration(midsamp, Gene_expression, miRNA_expression, node_name = "Gene2", .iter= 50, how = 2, limit=0)

## ---- fig.align='center', fig.width=5, fig.height=3, dpi= 120------------
iteration_graph(midsamp, competing_count = Gene_expression, miRNA_count = miRNA_expression, node_name = "Gene17", .iter= 50, how = 2, limit=0 )

## ---- fig.height=4, fig.width=5, fig.show='animate', aniopts="controls,loop"----
midsamp%>%
priming_graph(Gene_expression, miRNA_expression)%>%
  update_nodes(once = TRUE)%>%
  update_how("Gene17",2)%>%
  update_nodes()%>%
   simulate_vis(title = "Minsamp: Common element as trigger", 25)

