#' @title find_iteration
#'
#' @description find_iteration searches the iteration that provides maximum affected node number. The user defines a symbolic iteration with .iter. The function calculates the number of affected nodes for each iteration and than selects the iteration that has maximum affected nodes' number.
#'
#' @return It gives an iteration number to use in simulate() function.
#'
#' @param df A data frame that includes the miRNA and competing targets.
#' @param competing_count The counts (expression) of competing elements of the dataset.
#' @param miRNA_count The counts (expression) of repressive element (miRNA) of the dataset.
#' @param aff_factor The parameter/s of binding between miRNA and targets.
#' @param deg_factor The parameter/s for degradation of bound miRNA:target complex.
#' @param node_name The name f node that is used as trigger.
#' @param how The change of count (expression) of the given node in terms of fold change.
#' @param .iter The maximum iteration prescribed by the user.
#' @param limit The minimum amount of change of any node.
#'
#' @details
#'
#' @examples
#'
#' find_iteration(minsamp, Competing_expression, miRNA_expression, aff_factor = energy, deg_factor = region, node_name = "Gene2", how= 3)
#'
#' @export


find_iteration <- function(df, competing_count, miRNA_count, aff_factor=dummy, deg_factor=dummy, node_name, how, .iter = 100, limit= 0.1){

  competing_exp <- enquo(competing_count)
  mirna_exp <- enquo(miRNA_count)
  affinity <- enquos(aff_factor)
  degradation <- enquos(deg_factor)

  iteration <- data.frame(iter = seq(1,.iter, 1), effect= rep(0))

  df <- df%>%
    dplyr::mutate(competing = df[,1], miRNA= df[,2], Competing_name = df[,1], miRNA_name= df[,2], dummy=1)%>%
    dplyr::select(competing, miRNA, Competing_name, miRNA_name, !!competing_exp, !!mirna_exp, !!!affinity, !!!degradation, dummy)


  df%>%
    dplyr::group_by(miRNA)%>%
    dplyr::mutate_at(vars(!!!affinity), list(anorm= ~normalize))%>%
    dplyr::mutate_at(vars(!!!degradation), list(dnorm = ~normalize))%>%
    dplyr::ungroup()%>%
    dplyr::mutate(afff_factor = dplyr::select(., ends_with("anorm"))%>%reduce (`*`, .init = 1),
                  degg_factor = dplyr::select(., ends_with("dnorm"))%>%reduce (`*`, .init =1))%>%
    as_tbl_graph()%N>%
    tidygraph::mutate(type = ifelse(str_detect(name, paste(c("mir", "miR", "Mir","MiR", "hsa-"), collapse="|")), "miRNA", "Competing"), node_id = 1:length(.N()$name))%E>%
    tidygraph::mutate(comp_count_list = as.list(!!competing_exp), comp_count_pre = !!competing_exp, comp_count_current = !!competing_exp, mirna_count_list = as.list(!!mirna_exp), mirna_count_pre = !!mirna_exp, mirna_count_current = !!mirna_exp)%>%
    tidygraph::group_by(to)%>%
    tidygraph::mutate(mirna_count_per_dep = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_dep = ifelse(is.na(mirna_count_per_dep), 0, mirna_count_per_dep))%>%
    tidygraph::ungroup()%>%
    tidygraph::mutate(effect_current = mirna_count_per_dep*degg_factor, effect_pre = effect_current, effect_list = as.list(effect_current))%>%
    tidygraph::select(-ends_with("norm"), dummy)%>%
    update_nodes(once = TRUE)%>%
    update_how(node_name, how)%N>%
    simulate(cycle = .iter)->result_100


     for(i in 1:.iter){

     result_100%E>%
      as_tibble()%>%
      dplyr::select(from, comp_count_list)%>%
      mutate(dif= (abs(map_dbl(comp_count_list,i+1)) - abs(map_dbl(comp_count_list,i))))%>%
      dplyr::select(-comp_count_list)%>%
      distinct()%>%
      mutate(non_zero = ifelse(abs(dif)>limit, 1, 0))%>%
      summarise(per= sum(non_zero)*100/n())%>%pull() -> iteration$effect[i]

  }

  return((iteration%>%
           filter(effect== max(effect)))[1,1])
}




#' @title iteration_graph
#'
#' @description The function calculates the number of disturbed nodes for each iteration and than gives the plot that is ratio of iteration and affected node  in terms of percentage. .
#'
#' @return It gives the plot.
#'
#' @param df A data frame that includes the miRNA and competing targets.
#' @param competing_count The counts (expression) of competing elements of the dataset.
#' @param miRNA_count The counts (expression) of repressive element (miRNA) of the dataset.
#' @param aff_factor The parameter/s of binding between miRNA and targets.
#' @param deg_factor The parameter/s for degradation of bound miRNA:target complex.
#' @param node_name The name f node that is used as trigger.
#' @param how The change of count (expression) of the given node in terms of fold change.
#' @param .iter The maximum iteration prescribed by the user.
#' @param limit The minimum amount of change of any node.
#'
#' @details
#'
#' @examples
#'
#' find_iteration(minsamp, Competing_expression, miRNA_expression, aff_factor = energy, deg_factor = region, node_name = "Gene2", how= 3)
#'
#' @export

iteration_graph <- function(df, competing_count, miRNA_count, aff_factor=dummy, deg_factor=dummy, node_name, how, .iter = 100, limit= 0.2){

  competing_exp <- enquo(competing_count)
  mirna_exp <- enquo(miRNA_count)
  affinity <- enquos(aff_factor)
  degradation <- enquos(deg_factor)

  iteration <- data.frame(iter = seq(1,.iter, 1), effect= rep(0))

  df <- df%>%
    dplyr::mutate(competing = df[,1], miRNA= df[,2], Competing_name = df[,1], miRNA_name= df[,2], dummy=1)%>%
    dplyr::select(competing, miRNA, Competing_name, miRNA_name, !!competing_exp, !!mirna_exp, !!!affinity, !!!degradation, dummy)


  df%>%
    dplyr::group_by(miRNA)%>%
    dplyr::mutate_at(vars(!!!affinity), list(anorm= ~normalize))%>%
    dplyr::mutate_at(vars(!!!degradation), list(dnorm = ~normalize))%>%
    dplyr::ungroup()%>%
    dplyr::mutate(afff_factor = dplyr::select(., ends_with("anorm"))%>%reduce (`*`, .init = 1),
                  degg_factor = dplyr::select(., ends_with("dnorm"))%>%reduce (`*`, .init =1))%>%
    as_tbl_graph()%N>%
    tidygraph::mutate(type = ifelse(str_detect(name, paste(c("mir", "miR", "hsa-"), collapse="|")), "miRNA", "Competing"), node_id = 1:length(.N()$name))%E>%
    tidygraph::mutate(comp_count_list = as.list(!!competing_exp), comp_count_pre = !!competing_exp, comp_count_current = !!competing_exp, mirna_count_list = as.list(!!mirna_exp), mirna_count_pre = !!mirna_exp, mirna_count_current = !!mirna_exp)%>%
    tidygraph::group_by(to)%>%
    tidygraph::mutate(mirna_count_per_dep = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_dep = ifelse(is.na(mirna_count_per_dep), 0, mirna_count_per_dep))%>%
    tidygraph::ungroup()%>%
    tidygraph::mutate(effect_current = mirna_count_per_dep*degg_factor, effect_pre = effect_current, effect_list = as.list(effect_current))%>%
    tidygraph::select(-ends_with("norm"), dummy)%>%
    update_nodes(once = TRUE)%>%
    update_how(node_name, how)%N>%
    simulate(cycle = .iter)->result_100

  for(i in 1:.iter){

    result_100%E>%
      as_tibble()%>%
      dplyr::select(from, comp_count_list)%>%
      mutate(dif= (abs(map_dbl(comp_count_list,i+1)) - abs(map_dbl(comp_count_list,i))))%>%
      dplyr::select(-comp_count_list)%>%
      distinct()%>%
      mutate(non_zero = ifelse(abs(dif)>limit, 1, 0))%>%
      summarise(per= sum(non_zero)*100/n())%>%pull() -> iteration$effect[i]

  }

  return(iteration%>%
           ggplot(aes(y=effect, x=iter))+
           geom_line()+
           xlab("Iteration")+
           ylab("(%) The Disturbed Element"))

}
