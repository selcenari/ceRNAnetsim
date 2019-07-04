#' Finds the iteration which provides maximum affected node number
#'
#' searches the iteration that provides maximum affected node number. The user defines a symbolic iteration with .iter. The function calculates the number of affected nodes for each iteration and than selects the iteration that has maximum affected nodes' number.
#'
#' @return It gives an iteration number to use in simulate() function.
#'
#' @param df A tbl graph that includes the miRNA and competing targets triggered and simulated for number of cycles.
#' @param limit The minimum amount of change of any node.
#' @param plot If TRUE, returns a plot.
#'
#' @examples
#'
#' data("minsamp")
#'
#' find_iteration(minsamp, Competing_expression, miRNA_expression, node_name = "Gene2", how =2)
#'
#' find_iteration(minsamp, Competing_expression, miRNA_expression, aff_factor = energy, deg_factor = region, node_name = "Gene2", how= 3)
#'
#' @export

find_iteration <- function(df,  limit= 0.1, plot=FALSE){
  len <- df %E>% as_tibble() %>% .$comp_count_list %>% .[[1]] %>%  length()
  iteration <- data.frame(iter = seq(1,len-1, 1), effect= rep(0))

  for(i in 1:(len-1)){

    df%>%
      tidygraph::activate(edges)%>%
      tibble::as_tibble()%>%
      dplyr::select(from, comp_count_list)%>%
      mutate(dif= (abs(map_dbl(comp_count_list,i+1)) - abs(map_dbl(comp_count_list,i))))%>%
      dplyr::select(-comp_count_list)%>%
      distinct()%>%
      mutate(non_zero = ifelse(abs(dif)>limit, 1, 0))%>%
      summarise(per= sum(non_zero)*100/n())%>%pull() -> iteration$effect[i]

  }
  if (plot){
    return(iteration%>%
             ggplot(aes(y=effect, x=iter))+
             geom_line()+
             xlab("Iteration")+
             ylab("(%) The Disturbed Element"))

  } else{
    return((iteration%>%
              filter(effect== max(effect)))[1,1])
  }
}
