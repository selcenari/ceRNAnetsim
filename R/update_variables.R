#' Replaces new values with previous values of
#' competing or miRNA counts.
#'
#' This function replaces new values with previous
#' values of competing or miRNA counts.
#'
#' @importFrom igraph E 'E<-'
#' @return the graph object.
#'
#' @details update_variables function provides updating edge
#' variables to current values. If the microRNA or competing
#' expression (or both) change (decreasing or increasing),
#' this function switches the values that are found in a new
#' dataset provided by user. But the current value dataset
#' must be equal with initial dataset in terms of node name.
#'
#' @param input_graph The processed graph object.
#' @param current_counts The additional df that provided by user.
#'
#' @examples
#'
#' data('minsamp')
#' data('new_counts')
#'
#'  minsamp%>%
#'  priming_graph(Competing_expression, miRNA_expression,
#'      aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_variables(new_counts)
#'    #new_counts includes the current counts of nodes.
#'
#' @export

update_variables <- function(input_graph, current_counts) {

  if (isTRUE(all.equal(current_counts$Competing, E(input_graph)$Competing_name))) {

    E(input_graph)$comp_count_current[match(current_counts$Competing,
                                            E(input_graph)$Competing_name)] <- current_counts$Competing_count
  } else {
    stop("Current values include one or more different node name!",
         call. = FALSE)

  }

  if (isTRUE(all.equal(current_counts$miRNA, E(input_graph)$miRNA_name))) {

    E(input_graph)$mirna_count_current[match(current_counts$miRNA,
                                             E(input_graph)$miRNA_name)] <- current_counts$miRNA_count
  } else {
    stop("Current values include one or more different node name!",
         call. = FALSE)

  }

  return(input_graph %>% update_nodes())

}
