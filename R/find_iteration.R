#'  Finds the iteration which provides maximum affected node number
#'
#'  searches the iteration that provides maximum affected node number.
#'  The user defines a symbolic iteration with .iter. The function
#'  calculates the number of affected nodes for each iteration and
#'  then selects the iteration that has maximum affected nodes' number.
#'
#' @importFrom ggplot2 ggplot xlab geom_line ylab aes
#' @importFrom purrr map_dbl
#' @return It gives an iteration number to use in simulate() function.
#'
#' @param df A tbl graph that includes the miRNA and competing targets
#' triggered and simulated for number of cycles.
#' @param limit The minimum amount of change of any node.
#' @param plot If TRUE, returns a plot.
#'
#' @examples
#'
#' data('midsamp')
#'
#' midsamp %>%
#'   priming_graph(Gene_expression, miRNA_expression) %>%
#'   update_how('Gene2',2) %>%
#'   simulate(10) %>%
#'   find_iteration(limit=0)
#'
#' @export

find_iteration <- function(df, limit = 0.1, plot = FALSE) {

  len <- df %>% tidygraph::activate(edges) %>% tidygraph::as_tibble() %>%
    .$comp_count_list %>% .[[1]] %>% length()
  iteration <- data.frame(iter = seq(1, len - 1, 1), effect = rep(0))

  for (i in seq_len((len - 1))) {

    iteration$effect[i] <- df %>% tidygraph::activate(edges) %>% tidygraph::as_tibble() %>%
      dplyr::select(from, comp_count_list) %>% dplyr::mutate(dif = (abs(map_dbl(comp_count_list,
                                                                                i + 1)) - abs(map_dbl(comp_count_list, i)))) %>% dplyr::select(-comp_count_list) %>%
      dplyr::distinct() %>% dplyr::mutate(non_zero = ifelse(abs(dif) >
                                                              limit, 1, 0)) %>% dplyr::summarise(per = sum(non_zero) * 100/n()) %>%
      pull()

  }

  if (plot) {
    return(iteration %>% ggplot(aes(y = effect, x = iter)) + geom_line() +
             xlab("Iteration") + ylab("(%) The Disturbed Element"))

  } else {
    return((iteration %>% dplyr::filter(effect == max(effect)))[1,
                                                                1])
  }
}
