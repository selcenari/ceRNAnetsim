#' @title prepare_rhs_once
#'
#' @description  Carries the variables from edge to node.
#'
#' @details The function is a helper function for processing of graph object with update_nodes function.
#'
#' @param input_graph Processed graph object in previous step.
#'


prepare_rhs_once <- function(input_graph){

  bind_rows((as_tibble(input_graph%>%
                         activate(edges)%>%
                         dplyr::select(comp_count_current, comp_count_pre))%>%
               mutate(initial_count = comp_count_pre)%>%
               dplyr::select(id = from, initial_count, count_pre = comp_count_pre,  count_current = comp_count_current)%>%
               dplyr::distinct()),
            (as_tibble(input_graph%>%
                         activate(edges)%>%
                         dplyr::select(mirna_count_current, mirna_count_pre))%>%
               mutate(initial_count = mirna_count_pre)%>%
               dplyr::select(id = to, initial_count, count_pre = mirna_count_pre,  count_current = mirna_count_current)%>%
               dplyr::distinct()))


}

#' @title prepare_rhs
#'
#' @description  Carries the variables from edge to node.
#'
#' @details The function is a helper function for processing of graph object with update_nodes function.
#'
#' @param input_graph Processed graph object in previous step.
#'


prepare_rhs <- function(input_graph){

  bind_rows((as_tibble(input_graph%>%
                         activate(edges))%>%
               dplyr::select(id = from, count_current = comp_count_current)%>%
               dplyr::distinct()),
            (as_tibble(input_graph%>%
                         activate(edges))%>%
               dplyr::select(id= to,  count_current = mirna_count_current)%>%
               dplyr::distinct()))
}

#' @title update_nodes
#'
#' @description  The function carries variables from edge to node.
#'
#' @return the graph object.
#'
#' @param input_graph Processed graph object in previous step.
#' @param once The argument is about when the carrying process runs.
#'
#' @details If the carrying process performs after priming_graph function, the argument must be TRUE.
#'     The function helps to visualisation of processed graph object, especially that includes too many nodes.This step makes it easily to follow the processes.
#'
#' @examples
#'
#' minsamp%>%
#' priming_graph(Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_nodes(once = TRUE)
#'
#' @export

update_nodes <- function(input_graph, once = FALSE){
  if( once ) {
    rhs_table <- prepare_rhs_once(input_graph)
  } else {
    rhs_table <- prepare_rhs(input_graph)
  }
  if (!once){
    input_graph <- input_graph%N>%
      dplyr::select(-count_pre)%>%
      dplyr::select(name, type, node_id, initial_count, count_pre = count_current)
  }

  input_graph <- input_graph%>%
    tidygraph::activate(nodes)%>%
    left_join(rhs_table, by=c("node_id"="id"))%>%
    mutate(changes_variable = ifelse( count_current-count_pre != 0, "Down", type), changes_variable = ifelse(count_current-count_pre > 0, "Up", changes_variable))

  input_graph
}
