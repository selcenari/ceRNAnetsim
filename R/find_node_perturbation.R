#' @title find_node_perturbation
#'
#' @description  calculates the mean of expression changes of all  nodes and finds the perturbed node count for all nodes in system.
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
#'
#' @examples
#'
#' minsamp%>%
#'    priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression, aff_factor = c(energy,seed_type), deg_factor = region)%>%
#'    find_node_perturbation(how = 3, cycle = 4)
#'
#' @export

find_node_perturbation <- function(input_graph, how = 2, cycle=1, limit= 0){

  input_graph%N>%
    mutate(eff_count =future_map(V(input_graph)$name, ~calc_perturbation(input_graph, .x, how, cycle, limit)))%>%
    as_tibble()-> result

  result%>%
    unnest(eff_count)%>%
    group_by(name) %>%
    mutate(col=seq_along(name)) %>%
    spread(key=col, value=eff_count)%>%
    ungroup()%>%
    dplyr::rename(perturbation_efficiency= "1", perturbed_count = "2") -> result

  return(result)
}
