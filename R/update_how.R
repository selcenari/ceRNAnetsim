#' Converts the count value of the given node.
#'
#' this function converts the count value of the given node.
#'
#' @importFrom igraph E "E<-"
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
#' data("minsamp")
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression)%>%
#'    update_how("Gene1",3)
#'
#'  priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_how("Gene1", 3)
#'
#'    priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'   update_how("Gene1", how=0, knockdown= TRUE)
#'
#'
#'
#' @export

update_how <- function (input_graph, node_name, how, knockdown= TRUE){

  if ( how < 0) stop("Fold change should not be less than zero.
                     Please use decimal values for decrease. e.g. 0.5 for 2-fold decrease",
                     call. = FALSE)

  if( how==0 & knockdown){

    return(input_graph%>%
           gene_knockdown(node_name)%>%
             update_nodes())
  }

  if(node_name %in% E(input_graph)$Competing_name){

    input_graph <- input_graph%>%
      tidygraph::activate(edges)%>%
      tidygraph::mutate(comp_count_current = ifelse(node_name == E(input_graph)$Competing_name, comp_count_current*how, comp_count_current))

  } else if(node_name %in% E(input_graph)$miRNA_name){

   input_graph <- input_graph%>%
     tidygraph::activate(edges)%>%
     tidygraph::mutate(mirna_count_current = ifelse(node_name == E(input_graph)$miRNA_name, mirna_count_current*how, mirna_count_current))

  } else{

    stop(paste("Given node name", node_name, "was not found! Please check it.", sep = " "))

  }

  return(input_graph%>%update_nodes())
}



#' Knocks down given node.
#'
#' @importFrom igraph E
#' @return the graph object.
#'
#' @details knocks down a given gene target.
#'
#' @param input_graph The graph object that processed in previous step/s.
#' @param node_name The name of the node whose count is to be knocked down.
#' @param knockdown default is TRUE
#'

gene_knockdown <- function (input_graph, node_name){

    input_graph <- input_graph%>%
      tidygraph::activate(edges)%>%
      tidygraph::mutate(comp_count_current = ifelse(node_name == E(input_graph)$Competing_name, 0, comp_count_current))

    return(input_graph%>% update_nodes())

}
