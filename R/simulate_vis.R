#' Provides visualisation of the graph in addition to simulate function.
#'
#' simulate_vis provides visualisation of the graph in addition to simulate function.
#'
#' @importFrom purrr pmap
#' @importFrom ggplot2 ggsave
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
#' @param threshold absolute minimum amount of change required to be considered as up/down regulated element
#'
#' @examples
#'
#' # When does the system gain steady-state conditions again?
#'
#' ## new_counts, the dataset that includes the current counts of nodes.
#'
#' data("minsamp")
#' data("new_counts)
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression)%>%
#'   update_variables(new_counts)%>%
#'   simulate_vis()
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, 
#'     aff_factor = c(seed_type,energy), deg_factor = c(region))%>%
#'   update_variables(new_counts)%>%
#'   simulate_vis(cycle = 12)
#'
#' @export


simulate_vis <- function(input_graph, cycle=1, threshold = 0, save = FALSE, Competing_color = "green", mirna_color = "orange", Upregulation = "red", Downregulation = "blue", title = "GRAPH", layout= "kk"){



  for(i in seq_len(cycle)){


    input_graph%>%
      tidygraph::activate(edges)%>%
      tidygraph::group_by(to)%>%
      tidygraph::mutate(mirna_count_per_comp = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_comp = ifelse(is.na(mirna_count_per_comp), 0, mirna_count_per_comp))%>%
      tidygraph::ungroup()%>%
      tidygraph::mutate(effect_pre = effect_current, effect_current = mirna_count_per_comp*degg_factor)%>%
      tidygraph::group_by(from)%>%
      tidygraph::mutate(comp_count_pre = ifelse(comp_count_current< 0, 1, comp_count_current), comp_count_current = comp_count_pre - (sum(effect_current)-sum(effect_pre)), comp_count_current = ifelse(comp_count_current< 0, 1, comp_count_current))%>%
      tidygraph::ungroup()%>%
      tidygraph::mutate(comp_count_list = pmap(list(comp_count_list, comp_count_current), c), effect_list = pmap(list(effect_list, effect_current), c), mirna_count_list = pmap(list(mirna_count_list, mirna_count_current), c))%>%
      tidygraph::activate(nodes)%>%
      update_nodes(limit = threshold)-> input_graph

    vis_graph(input_graph, Competing_color, mirna_color, Upregulation, Downregulation, title = paste(title, "-",i), layout)-> graph_vis

    print(graph_vis)
    
    if(save){
      
      ggsave(paste(title, ".png", sep = ""))
    }
  }
  input_graph

}
