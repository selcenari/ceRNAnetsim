#' Carries the variables from edge to node.
#'
#' Carries the variables from edge to node.
#'
#' @details The function is a helper function for processing of graph object with update_nodes function.
#'
#' @param input_graph Processed graph object in previous step.
#' @return tibble object
#'


prepare_rhs_once <- function(input_graph){

  dplyr::bind_rows((tidygraph::as_tibble(input_graph%>%
                                          tidygraph::activate(edges)%>%
                                          tidygraph::select(Competing_name, comp_count_current, comp_count_pre))%>%
                      tidygraph::mutate(initial_count = comp_count_pre)%>%
                      tidygraph::select(id = Competing_name, initial_count, count_pre = comp_count_pre,  count_current = comp_count_current)%>%
                      tidygraph::distinct()),
            (tidygraph::as_tibble(input_graph%>%
                                   tidygraph::activate(edges)%>%
                                   tidygraph::select(miRNA_name, mirna_count_current, mirna_count_pre))%>%
               tidygraph::mutate(initial_count = mirna_count_pre)%>%
               tidygraph::select(id = miRNA_name, initial_count, count_pre = mirna_count_pre,  count_current = mirna_count_current)%>%
               tidygraph::distinct()))


}

#' Carries the variables from edge to node
#'
#' Carries the variables from edge to node.
#'
#' @details The function is a helper function for processing of graph object with update_nodes function.
#'
#' @param input_graph Processed graph object in previous step.
#' @return tibble object
#'


prepare_rhs <- function(input_graph){

  dplyr::bind_rows((tidygraph::as_tibble(input_graph%>%
                                          tidygraph::activate(edges))%>%
               dplyr::select(id = Competing_name, count_current = comp_count_current)%>%
                 dplyr::distinct()),
            (tidygraph::as_tibble(input_graph%>%
                                    tidygraph::activate(edges))%>%
               dplyr::select(id= miRNA_name,  count_current = mirna_count_current)%>%
               dplyr::distinct()))
}

#' Carries variables from edge to node.
#'
#' This function carries variables from edge to node and should be used
#' after `update_how` or `update_variables` functions
#'
#' @return the graph object.
#'
#' @param input_graph Processed graph object in previous step.
#' @param once The argument is about when the carrying process runs (internal use only)
#' @param limit absolute minimum amount of change required to be considered as up/down regulated element
#'
#' @details If the carrying process performs after priming_graph function, the argument must be TRUE.
#'     The function helps to visualisation of processed graph object, especially that includes too many nodes.This step makes it easily to follow the processes.
#'
#' @examples
#'
#' data("minsamp")
#'
#' minsamp %>%
#'   priming_graph(Competing_expression, miRNA_expression) %>%
#'   update_how("Gene2",2)
#'
#' @export

update_nodes <- function(input_graph, once = FALSE, limit = 0){
  if( once ) {
    rhs_table <- prepare_rhs_once(input_graph)
  } else {
    rhs_table <- prepare_rhs(input_graph)
  }
  if (!once){
    input_graph <- input_graph%>%
      tidygraph::activate(nodes)%>%
      tidygraph::select(-count_pre)%>%
      tidygraph::select(name, type, node_id, initial_count, count_pre = count_current)
  }

  input_graph <- input_graph%>%
    tidygraph::activate(nodes)%>%
    tidygraph::left_join(rhs_table, by=c("name"="id"))%>%
    tidygraph::mutate(changes_variable = ifelse( count_current-count_pre < -limit, "Down", type),
               changes_variable = ifelse(count_current-count_pre > limit, "Up", changes_variable))

  input_graph
}
