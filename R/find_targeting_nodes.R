#' Finds potential affecting node for given particular target.
#'
#' @importFrom furrr future_map future_map_dfr
#' @importFrom future plan
#' @importFrom rlang set_names
#' @importFrom igraph gsize degree V 'V<-'
#' @importFrom purrr map_dbl
#' @importFrom tidyr unnest
#'
#' @return It gives a tibble form dataset that includes parturbation node (source) and
#' change in count of targeting node 
#'
#' @details Lists potential targeting nodes by running 
#' find_affected_nodes function for all nodes in network.
#'
#' @param input_graph The graph object that was processed with priming_graph function.
#' @param how The change of count (expression) of the given node in terms of fold change.
#' @param cycle The iteration of simulation.
#' @param limit The minimum fold change which can be taken into account for
#' perturbation calculation on all nodes in terms of percentage.
#' @param fast specifies percentage of affected target in target expression.
#' For example, if fast = 1, the nodes that are affected from miRNA repression
#' activity more than one percent of their expression is determined as subgraph.
#' @param top Determines how many nodes most affected will be evaluated.
#' @param target The target node in which is being investigated.
#'
#' @examples
#'
#' data('midsamp')
#' 
#' midsamp%>%
#' priming_graph(competing_count = Gene_expression, 
#'               miRNA_count = miRNA_expression)%>%
#' find_targeting_nodes(how = 2, 
#'                      cycle = 2, 
#'                      target = "Gene1", 
#'                      top = 2)
#'
#'
#' @export


find_targeting_nodes <- function(input_graph, how = 2, cycle = 1, limit = 0, fast = 0, top = 5, target = NULL) {
  

  empty_result <- list(dplyr::tibble(top_nodes = NA, change = NA, initial_exp = NA, final_exp=NA))
  
  if (fast == 0) {
    
    result <- input_graph %>% 
      activate(nodes) %>% 
      tidygraph::mutate(eff_count = future_map(V(input_graph)$name,~find_affected_nodes(input_graph, .x, how, cycle, limit, top))) %>%
      tibble::as_tibble() %>% 
      unnest(eff_count)
  }
  
  if (fast != 0) {
    
    result <- input_graph %>% 
      tidygraph::activate(edges) %>% 
      tidygraph::mutate(fast = ifelse(100 * effect_current/comp_count_current > fast, TRUE, FALSE)) %>%
      tidygraph::morph(to_subgraph, fast) %>%
      { if( igraph::gsize(crystallise(.)$graph[[1]])==0) stop("Your argument fast removed all nodes. Please try lower fast argument")   else .  }%>%
      tidygraph::activate(nodes) %>%
      tidygraph::mutate(degree = tidygraph::centrality_degree(mode = "all")) %>%
      tidygraph::filter(degree > 0) %>% 
      tidygraph::mutate(eff_count = tidygraph::map_bfs(node,.f = function(graph, node, ...) {
        find_affected_nodes(graph, V(graph)$name[node], how, cycle,limit, top)})) %>% 
      tidygraph::unmorph() %>% 
      tidygraph::mutate(len = map_dbl(eff_count, length), eff_count = ifelse(len == 0, empty_result, eff_count)) %>%
      tidygraph::as_tibble() %>% 
      unnest() %>% 
      dplyr::select(-degree, -len)
    
  }
  
  if (is.null(target)){
    
    result <- result%>%
      select(source, top_nodes, change, initial_exp, final_exp)%>%
      unnest(cols = c(top_nodes, change, initial_exp, final_exp))%>%
      rename("targeting_node" = "source")
  }
  
  else{
    
    result <- result%>%
      select(source, top_nodes, change, initial_exp, final_exp)%>%
      unnest(cols = c(top_nodes, change, initial_exp, final_exp))%>%
      filter(top_nodes == target)%>%
      rename("targeting_node" = "source")
    
    
    
  }
  
  return(result)
}
