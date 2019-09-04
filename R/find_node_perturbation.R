#' Calculates average expression changes of all (or specified) nodes except trigger and finds the perturbed node count for all (or specified) nodes in system.
#'
#'
#' @return It gives a tibble form dataset that includes node names, perturbation efficiency and perturbed count of nodes.
#'
#' @details find_node_perturbation calculates mean expression changes of elements after the change in the network in terms of percentage. It also calculates the number of nodes that have expression changes after the change occur in the network.
#'   The outputs of the function are the perturbation efficiency and perturbed count of nodes for each nodes.
#'
#' @param input_graph The graph object that was processed with priming_graph function.
#' @param how The change of count (expression) of the given node in terms of fold change.
#' @param cycle The iteration of simulation.
#' @param limit The minimum fold change which can be taken into account for perturbation calculation on all nodes in terms of percentage.
#' @param included specifies percentage of affected target in target expression. For example, if fast = 1, the nodes that are affected from miRNA repression activity more than one percent of their expression is determined as subgraph.
#'
#' @examples
#'
#' data("minsamp")
#' data("midsamp")
#'
#'  minsamp%>%
#'   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression)%>%
#'   find_node_perturbation()
#'
#'
#'  minsamp%>%
#'   priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression, aff_factor = c(energy,seed_type), deg_factor = region)%>%
#'   find_node_perturbation(how = 3, cycle = 4)
#'
#'  midsamp%>%
#'   priming_graph(competing_count = Gene_expression, miRNA_count = miRNA_expression)%>%
#'   find_node_perturbation(how = 2, cycle= 3, limit=1, fast = 5)
#'
#'
#' @export

find_node_perturbation <- function(input_graph, how = 2, cycle=1, limit= 0, fast = 0){

  empty_result<- list(dplyr::tibble(perturbation_efficiency= NA, perturbed_count = NA))

  if(fast==0){

  input_graph%>%
    activate(nodes)%>%
    tidygraph::mutate(eff_count =furrr::future_map(V(input_graph)$name, ~calc_perturbation(input_graph, .x, how, cycle, limit)))%>%
    tibble::as_tibble() %>%
    tidyr::unnest(eff_count) -> result
  }

  if(fast != 0){

    input_graph%E>%
      tidygraph::mutate(fast=ifelse(100*effect_current/comp_count_current>fast, TRUE, FALSE))%E>%
      tidygraph::morph(to_subgraph,fast)%N>%
      tidygraph::mutate(degree= centrality_degree(mode="all"))%>%
      tidygraph::filter(degree>0)%>%
      tidygraph::mutate(eff_count = tidygraph::map_bfs(node_is_center(), .f = function(graph, node, ...) {
        calc_perturbation(graph, V(graph)$name[node], how, cycle, limit)
      }))%>%
      tidygraph::unmorph()%>%
      tidygraph::mutate(len= map_dbl(eff_count, length),
             eff_count= ifelse(len==0, empty_result, eff_count))%>%
      tidygraph::as_tibble()%>%
      tidyr::unnest()%>%
      dplyr::select(-degree, -len)-> result


  }

  return(result)
}
