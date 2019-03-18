## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=FALSE, message= FALSE, warning=FALSE--------------------------
library(dplyr)
library(readr)
library(tidyr)
library(stringr)
library(stringi)
library(tidygraph)
library(igraph)
library(ggraph)
library(tidyverse)
library(ggplot2)
library(svglite)
library(devtools)


## ---- warning= FALSE-----------------------------------------------------
#install regulationSimulatoR

library(regulationSimulatoR)

## ------------------------------------------------------------------------
data("mirtarbasegene")

head(mirtarbasegene)

## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_normal")
head(TCGA_E9_A1N5_normal)


data("TCGA_E9_A1N5_tumor")
head(TCGA_E9_A1N5_tumor)


## ------------------------------------------------------------------------
data("TCGA_E9_A1N5_mirnatumor")

head(TCGA_E9_A1N5_mirnatumor)

data("TCGA_E9_A1N5_mirnanormal")

head(TCGA_E9_A1N5_mirnanormal)


## ------------------------------------------------------------------------

TCGA_E9_A1N5_mirnanormal%>%
  inner_join(mirtarbasegene, by= "miRNA")%>%
  inner_join(TCGA_E9_A1N5_normal, by = c("Target"= "external_gene_name"))%>%
  select(Target, miRNA, total_read, gene_expression)%>%
  distinct()->TCGA_E9_A1N5_mirnagene


TCGA_E9_A1N5_mirnagene%>%
  group_by(Target)%>%
  mutate(gene_expression= max(gene_expression))%>%
  distinct()%>%
  ungroup()->TCGA_E9_A1N5_mirnagene

## ------------------------------------------------------------------------

TCGA_E9_A1N5_tumor%>%
  inner_join(TCGA_E9_A1N5_normal, by= "external_gene_name")%>%
  select(patient = patient.x, external_gene_name, tumor_exp = gene_expression.x, normal_exp = gene_expression.y)%>%
  distinct()%>%
  inner_join(TCGA_E9_A1N5_mirnagene, by = c("external_gene_name"= "Target"))%>%
  filter(tumor_exp != 0, normal_exp != 0)%>%
  mutate(FC= tumor_exp/normal_exp)%>%
  arrange(desc(FC))

#HIST1H3H : non-isolated gene. 30 FC.

## ---- fig.height=4, fig.width=5, fig.align='center', warning=FALSE-------
iteration_graph(as.data.frame(TCGA_E9_A1N5_mirnagene), competing_count = gene_expression, miRNA_count = total_read, node_name = "HIST1H3H", .iter = 10, how = 30)

## ------------------------------------------------------------------------
as.data.frame(TCGA_E9_A1N5_mirnagene)%>%
  priming_graph(competing_count = gene_expression, miRNA_count = total_read)%>%
  update_nodes(once = TRUE)%>%
  update_how("HIST1H3H", 30)%>%
  update_nodes()%>%
  simulate(10)


## ------------------------------------------------------------------------

TCGA_E9_A1N5_tumor%>%
  inner_join(TCGA_E9_A1N5_normal, by= "external_gene_name")%>%
  select(patient = patient.x, external_gene_name, tumor_exp = gene_expression.x, normal_exp = gene_expression.y)%>%
  distinct()%>%
  inner_join(TCGA_E9_A1N5_mirnagene, by = c("external_gene_name"= "Target"))%>%
  filter(tumor_exp != 0, normal_exp != 0)%>%
  mutate(FC= tumor_exp/normal_exp)%>%
  arrange(desc(normal_exp))

# ACTB 1.87 fold

## ---- fig.height=4, fig.width=5, fig.align='center', warning=FALSE-------
iteration_graph(as.data.frame(TCGA_E9_A1N5_mirnagene), competing_count = gene_expression, miRNA_count = total_read, node_name = "ACTB", .iter = 10, how = 1.87)

## ------------------------------------------------------------------------
as.data.frame(TCGA_E9_A1N5_mirnagene)%>%
  priming_graph(competing_count = gene_expression, miRNA_count = total_read)%>%
  update_nodes(once = TRUE)%>%
  update_how("ACTB", 1.87)%>%
  update_nodes()%>%
  simulate(10)

