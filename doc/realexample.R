## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- message=FALSE------------------------------------------------------
library(regulationSimulatoR)

## ---- echo=FALSE, message= FALSE, warning=FALSE--------------------------
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
data("huge_example")


head(huge_example)


## ------------------------------------------------------------------------
huge_example%>%
  group_by(competing)%>%
  count()%>%
  filter(n > 5)%>%
  inner_join(huge_example, by = "competing")%>%
  select(-n)%>%
  distinct()%>%
  as.data.frame()-> clear_example

head(clear_example)

## ---- fig.height=4, fig.width=5, fig.align='center', warning=FALSE-------

clear_example%>%
  priming_graph(competing_count = competing_counts, miRNA_count = mirnaexpression_normal, aff_factor = Energy)%>%
  update_nodes(once = TRUE)%>%
  update_how("GAPDH", 5)%>%
  update_nodes()%>%
  vis_graph(title = "Disturbtion of GAPDH gene node")


## ---- fig.height=4, fig.width=5, fig.align='center', warning=FALSE-------
clear_example%>%
  priming_graph(competing_count = competing_counts, miRNA_count = mirnaexpression_normal, aff_factor = Energy)%>%
  update_nodes(once = TRUE)%>%
  update_how("GAPDH", 5)%>%
  update_nodes()%>%
  simulate_vis(title = "GAPDH over expression in the real dataset", 3)


