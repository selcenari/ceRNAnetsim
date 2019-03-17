#' @title normalize
#'
#' @description normalizes the values according to maximum values inside a group. The helper function of priming_graph.
#'
#' @param x The variable name that is normalized.
#'
#' @return NULL
#'


normalize <- function(x){abs(x)/max(abs(x))}

#' @title priming_graph
#'
#' @description The function converts the given dataframe using first variable as competing and the second as miRNA. If user defines interaction factors as affinity or degradation, the factors are taken into account.
#'
#' @return the graph object.
#'
#' @param df A data frame that includes the miRNA and competing targets.
#' @param competing_count The counts (or expression) of competing elements of the dataset.
#' @param miRNA_count The counts (or expression) of repressive element (miRNA) of the dataset.
#' @param aff_factor The parameter/s of binding between miRNA and targets.
#' @param deg_factor The parameter/s for degradation of bound miRNA:target complex.
#'
#' @details priming_graph provides grouping of competing targets and evaluation of targets within the groups taking into account miRNA:target, target:total target, interaction and degradation parameters. The target groups are determined according to miRNAs. If the factors that are important in target interactions are specified as arguments, the factors also are evaluated separately within each group.
#' priming_graph also calculates the miRNA efficiency in steady-state conditions. It is assumed that quantity of competing targets and miRNAs are shown in the steady-state system after the miRNAs exhibit repressive efficiency.
#'
#' @examples
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)
#'
#' @export

priming_graph <- function(df, competing_count, miRNA_count, aff_factor=dummy, deg_factor=dummy){


  competing_exp <- enquo(competing_count)
  mirna_exp <- enquo(miRNA_count)
  affinity <- enquos(aff_factor)
  degradation <- enquos(deg_factor)

  df <- df%>%
    mutate(competing = df[,1], miRNA= df[,2], Competing_name = df[,1], miRNA_name= df[,2], dummy=1)%>%
    select(competing, miRNA, Competing_name, miRNA_name, !!competing_exp, !!mirna_exp, !!!affinity, !!!degradation, dummy)


  df%>%
    group_by(miRNA)%>%
    mutate_at(vars(!!!affinity), list(anorm= ~normalize))%>%
    mutate_at(vars(!!!degradation), list(dnorm = ~normalize))%>%
    ungroup()%>%
    mutate(afff_factor = select(., ends_with("anorm"))%>%reduce (`*`, .init = 1),
           degg_factor = select(., ends_with("dnorm"))%>%reduce (`*`, .init =1))%>%
    as_tbl_graph()%N>%
    mutate(type = ifelse(str_detect(name, paste(c("(?i)-mir", "hsa-"), collapse="|")), "miRNA", "Competing"), node_id = 1:length(.N()$name))%E>%
    mutate(comp_count_list = as.list(!!competing_exp), comp_count_pre = !!competing_exp, comp_count_current = !!competing_exp, mirna_count_list = as.list(!!mirna_exp), mirna_count_pre = !!mirna_exp, mirna_count_current = !!mirna_exp)%>%
    group_by(to)%>%
    mutate(mirna_count_per_dep = mirna_count_current*comp_count_current*afff_factor/sum(comp_count_current*afff_factor), mirna_count_per_dep = ifelse(is.na(mirna_count_per_dep), 0, mirna_count_per_dep))%>%
    ungroup()%>%
    mutate(effect_current = mirna_count_per_dep*degg_factor, effect_pre = effect_current, effect_list = as.list(effect_current))%>%
    select(-ends_with("norm"), dummy)-> input_graph

  warning("First variable processes as competing and the second as miRNA.
")

  input_graph

}

