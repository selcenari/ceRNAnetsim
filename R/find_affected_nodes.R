#' Finds top affected nodes for perturbation 
#' from a particular node
#'
#'
#' @importFrom tidygraph as_tibble
#'
#' @return It gives a tibble form dataset that includes perturbation node, 
#' affected nodes and changes of them.
#'
#' @details Lists the most affected nodes after perturbation 
#' initiated from a particular node. In the background, 
#' it compares the calculated values after
#' the simulation with their initial values.
#'
#' @param input_graph The graph object that was processed with priming_graph function.
#' @param node_name The node to trigger perturbations.
#' @param how The change of count (expression) of the given node in terms of fold change.
#' @param cycle The iteration of simulation.
#' @param limit The minimum fold change which can be taken into account for
#' perturbation calculation on all nodes in terms of percentage.
#' @param top Determines how many nodes most affected will be listed.
#'
#' @examples
#'
#' data('midsamp')
#' 
#' midsamp%>%
#' priming_graph(competing_count = Gene_expression, 
#'               miRNA_count = miRNA_expression)%>%
#' find_affected_nodes(node_name = "Gene1", 
#'                     how = 2, 
#'                     cycle = 2, 
#'                     top = 2)
#'
#'
#' @export



find_affected_nodes<- function(input_graph, node_name, how = 1, cycle = 1,
                               limit = 0, top = 5) {
  res <- input_graph %>% 
    update_how(node_name, how) %>% 
    simulate(cycle) %>%
    tidygraph::as_tibble() %>% 
    dplyr::filter(name != node_name)  
  
  top_nodes <- res%>%
    arrange(desc(abs(count_current - initial_count)))%>%
    head(top)%>%
    select(name)%>%
    as.list()
  
  initial_exp <- res%>%
    arrange(desc(abs(count_current - initial_count)))%>%
    head(top)%>%
    select(initial_count)%>%
    as.list()
  
  final_exp <- res%>%
    arrange(desc(abs(count_current - initial_count)))%>%
    head(top)%>%
    select(count_current)%>%
    as.list()
  
  top_changed <- res%>%
    arrange(desc(abs(count_current - initial_count)))%>%
    mutate(change = ifelse(count_current - initial_count < 0, "downregulated", "upregulated"),
           change = ifelse(count_current - initial_count == 0, "Not changed", change))%>%
    head(top)%>%
    select(change)%>%
    as.list()
  
  
  tibble(source = node_name, top_nodes = top_nodes, change = top_changed, initial_exp = initial_exp, final_exp=final_exp)%>%
    unnest(cols = c(source, top_nodes, change, initial_exp, final_exp))->res
  
  return(res)
  
}

