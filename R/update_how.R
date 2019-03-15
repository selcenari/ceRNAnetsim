#' @title update_how
#'
#' @description  update_how converts the count value of the given node.
#'
#' @return the graph object.
#'
#' @details update_how function calculates the current value of given mirna or gene node on the graph object. User must specify current value as fold change.
#'
#' @param input_graph The graph object that processed in previous step/s.
#' @param node_name The name of the node whose count is to be changed.
#' @param how The change in terms of fold change.
#'
#' @examples
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_nodes(once = TRUE)%>%
#'    update_how("Gene1", 3)
#'
#' @export

update_how <- function (input_graph, node_name, how){


  if(node_name %in% E(input_graph)$Competing_name){

    input_graph <- input_graph%>%
      activate(edges)%>%
      mutate(comp_count_current = ifelse(node_name == E(input_graph)$Competing_name, comp_count_current*how, comp_count_current))

  } else if(node_name %in% E(input_graph)$miRNA_name){

   input_graph <- input_graph%>%
     activate(edges)%>%
      mutate(mirna_count_current = ifelse(node_name == E(input_graph)$miRNA_name, mirna_count_current*how, mirna_count_current))

  } else{

    stop("Given node name was not found! Please check it.")

  }

  return(input_graph)
}

