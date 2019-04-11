#' @title simulate_vis
#'
#' @description  simulate_vis provides visualisation of the graph in addition to simulate function.
#'
#' @details simulate_vis gives the last graph object and each iterations' image.
#'
#' @return It gives a graph and the images of states in each iteration until the end of the simulation.
#'
#' @param input_graph The graph object that processed in previous steps.
#' @param cycle Optimal iteration number for gaining steady-state.
#' @param Competing_color The color of competing elements on the graph with "green" default.
#' @param mirna_color The color of miRNAs on the graph with "orange" default.
#' @param Upregulation The color of Upregulated elements on the graph with "red" default.
#' @param Downregulation The color of Downregulated elements on the graph with "blue" default.
#' @param title Title of the given graph.
#' @param layout The layout that will be used for visualisation of the graph.
#'
#' @examples
#'
#' # When does the system gain steady-state conditions again?
#'
#' ## new_counts, the dataset that includes the current counts of nodes.
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = c(region))%>%
#'    update_nodes(once = TRUE)%>%
#'    update_variables(new_counts)%>%
#'    update_nodes()%>%
#'    simulate_vis(cycle = 12)
#'
#' @export


simulate_vis <- function(input_graph, cycle=1, Competing_color = "green", mirna_color = "orange", Upregulation = "red", Downregulation = "blue", title = "GRAPH", layout= "kk"){

  for(i in seq_along(1:cycle)){

    input_graph%E>%
      group_by(to)%>%
      mutate(mirna_count_per_comp = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_comp = ifelse(is.na(mirna_count_per_comp), 0, mirna_count_per_comp))%>%
      ungroup()%>%
      mutate(effect_pre = effect_current, effect_current = mirna_count_per_comp*degg_factor)%>%
      group_by(from)%>%
      mutate(comp_count_pre = ifelse(comp_count_current< 0, 1, comp_count_current), comp_count_current = comp_count_pre - (sum(effect_current)-sum(effect_pre)), comp_count_current = ifelse(comp_count_current< 0, 1, comp_count_current))%>%
      ungroup()%>%
      mutate(comp_count_list = pmap(list(comp_count_list, comp_count_current), c), effect_list = pmap(list(effect_list, effect_current), c), mirna_count_list = pmap(list(mirna_count_list, mirna_count_current), c))%N>%
      update_nodes()-> input_graph

    vis_graph(input_graph, Competing_color, mirna_color, Upregulation, Downregulation, title = paste(title, "-",i), layout)-> graph_vis

    ggsave(paste(title, ".png", sep = ""))

    print(graph_vis)
  }
  input_graph

}
