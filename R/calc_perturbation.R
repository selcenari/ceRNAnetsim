#' @title calc_perturbation
#'
#' @description  calculates mean of expression changes of all  nodes and finds the perturbed node count for a given node.
#'
#' @return gives a vector about the perturbation efficiency and number of perturbed nodes.
#'
#' @details calc_perturbation calculates mean expression changes of elements after the change in the network in terms of percentage. It also calculates the number of nodes that have expression changes after the change occur in the network.
#'  The function determines the perturbation efficiency and number of perturbed nodes after given change with how, cycle and limit parameter.
#'
#' @param input_graph the graph object that was processed with priming graph in previous step.
#' @param node_name The node that is trigger for simulation.
#' @param how The change of count of the given node in terms of fold change.
#' @param cycle The iteration of simulation.
#' @param limit The minimum fold change which can be taken into account for perturbation calculation on all nodes in terms of percentage.
#'
#' @examples
#'
#' minsamp%>%
#'    priming_graph(competing_count = Competing_expression, miRNA_count = miRNA_expression, aff_factor = c(energy,seed_type), deg_factor = region)%>%
#'    calc_perturbation("Gene6",3, cycle = 4)
#'
#'
#' @export


calc_perturbation <- function(input_graph, node_name, how=1 , cycle=1, limit=0){

  input_graph%>%
    update_nodes(once=TRUE)%>%
    update_how(node_name, how)%>%
    simulate(cycle)%>%
    as_tibble()-> res

  as.double((res%>%summarise(mean(abs(count_current-initial_count)*100/initial_count)))[[1]])-> perturbation_eff

  as.double((res%>%filter((abs(count_current-initial_count)*100/initial_count) > limit)%>%count())[[1]])->perturbed_count

  return(c(perturbation_efficiency= perturbation_eff, perturbed_count = perturbed_count))
}
