#' @title simulate
#'
#' @description  simulate function uses the change in expression value/s as triggering.
#'
#' @return The graph.
#'
#' @details The steady-state conditions of the system are disturbed after the change in the graph (with update_how or update_variables). In this case, the system tend to be steady state again. The arrangement of competetive profiles of the targets continue until all nodes are updated and steady-state nearly.
#'
#' @param input_graph The graph object that processed in previous steps.
#' @param cycle Optimal iteration number for gaining steady-state.
#'
#' @examples
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_nodes(once = TRUE)%>%
#'    update_variables(new_counts)%>%
#'    simulate(cycle = 3)
#'
#' @export

simulate <- function(input_graph, cycle=1){

  for(i in seq_along(1:cycle)){

    input_graph%E>%
      group_by(to)%>%
      mutate(mirna_count_per_comp = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_comp = ifelse(is.na(mirna_count_per_comp), 0, mirna_count_per_comp))%>%
      ungroup()%>%
      mutate(effect_pre = effect_current, effect_current = mirna_count_per_comp*degg_factor)%>%
      group_by(from)%>%
      mutate(comp_count_pre = ifelse(comp_count_current< 0, 1, comp_count_current), comp_count_current = comp_count_pre - (sum(effect_current)-sum(effect_pre)), comp_count_current = ifelse(comp_count_current< 0, 1, comp_count_current))%>%
      ungroup()%>%
      mutate(comp_count_list = pmap(list(comp_count_list, comp_count_current), c), effect_list = pmap(list(effect_list, effect_current), c), mirna_count_list = pmap(list(mirna_count_list, mirna_count_current), c))%N>%
      update_nodes()-> input_graph
  }
  input_graph
}
