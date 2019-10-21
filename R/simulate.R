#' Utilizes the change in expression value/s as triggering.
#'
#' simulate function uses the change in expression value/s as triggering.
#' @import dplyr tidygraph
#' @importFrom purrr pmap
#' @return The graph.
#'
#' @details The steady-state conditions of the system are disturbed after the change in the graph (with update_how or update_variables). In this case, the system tend to be steady state again. The arrangement of competetive profiles of the targets continue until all nodes are updated and steady-state nearly. Note that, If `how` argument is specified as `0`, *simulate()* and *update_how()* functions process the variables to knockdown of specified gene with default `knockdown = TRUE` and knocked down competing RNA is kept at zero. However, if `knockdown= FALSE` argument is applied, competing RNA which has initial expression level of zero is allowed to increase or fluctuate during calculations.
#'
#' @param input_graph The graph object that processed in previous steps.
#' @param cycle Optimal iteration number for gaining steady-state.
#' @param threshold absolute minimum amount of change required to be considered as up/down regulated element
#' @param knockdown specifies gene knockdown with default TRUE
#'
#' @examples
#'
#' data("minsamp")
#'
#' ## new_counts, the dataset that includes the current counts of nodes.
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression)%>%
#'   update_variables(new_counts)%>%
#'   simulate()
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, 
#'        aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'   update_variables(new_counts)%>%
#'   simulate(cycle = 3)
#'
#' @export

simulate <- function(input_graph, cycle=1, threshold= 0, knockdown= TRUE){

  # seq_along causes unwanted behavor for 1:-2, so check no of cycles
  if ( cycle < 1 ) stop("number of cycles should be more than 1", call. = FALSE)

  if(knockdown){

    for(i in seq_along(1:cycle)){

      input_graph%>%
        tidygraph::activate(edges)%>%
        tidygraph::group_by(to)%>%
        tidygraph::mutate(mirna_count_per_comp = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_comp = ifelse(is.na(mirna_count_per_comp), 0, mirna_count_per_comp))%>%
        tidygraph::ungroup()%>%
        tidygraph::mutate(effect_pre = effect_current, effect_current = mirna_count_per_comp*degg_factor)%>%
        tidygraph::group_by(from)%>%
        tidygraph::mutate(comp_count_pre = ifelse(comp_count_current < 0, 1, comp_count_current), comp_count_current = ifelse(comp_count_pre==0, 0, comp_count_pre - (sum(effect_current)-sum(effect_pre))), comp_count_current = ifelse(comp_count_current< 0, 1, comp_count_current))%>%
        tidygraph::ungroup()%>%
        tidygraph::mutate(comp_count_list = pmap(list(comp_count_list, comp_count_current), c), effect_list = pmap(list(effect_list, effect_current), c), mirna_count_list = pmap(list(mirna_count_list, mirna_count_current), c))%>%
        tidygraph::activate(nodes)%>%
        update_nodes(limit = threshold) ->input_graph
    }
    return(input_graph)

  }


    for(i in seq_along(1:cycle)){

    input_graph%>%
        tidygraph::activate(edges)%>%
        tidygraph::group_by(to)%>%
        tidygraph::mutate(mirna_count_per_comp = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_comp = ifelse(is.na(mirna_count_per_comp), 0, mirna_count_per_comp))%>%
        tidygraph::ungroup()%>%
        tidygraph::mutate(effect_pre = effect_current, effect_current = mirna_count_per_comp*degg_factor)%>%
        tidygraph::group_by(from)%>%
        tidygraph::mutate(comp_count_pre = ifelse(comp_count_current< 0, 1, comp_count_current), comp_count_current = comp_count_pre - (sum(effect_current)-sum(effect_pre)), comp_count_current = ifelse(comp_count_current< 0, 1, comp_count_current))%>%
        tidygraph::ungroup()%>%
        tidygraph::mutate(comp_count_list = pmap(list(comp_count_list, comp_count_current), c), effect_list = pmap(list(effect_list, effect_current), c), mirna_count_list = pmap(list(mirna_count_list, mirna_count_current), c))%>%
        tidygraph::activate(nodes)%>%
      update_nodes(limit = threshold)-> input_graph
  }
  return(input_graph)
    }


