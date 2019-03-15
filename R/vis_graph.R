#' @title vis_graph
#'
#' @description  vis_graph provides to visualisation of the graph.
#'
#' @return The graph object.
#'
#' @details vis_graph ensures the process to be followed.
#'
#' @param input_graph The graph object.
#' @param Competing_color The color of competing elements on the graph with "green" default.
#' @param mirna_color The color of miRNAs on the graph with "orange" default.
#' @param Upregulation The color of Upregulated elements on the graph with "red" default.
#' @param Downregulation The color of Downregulated elements on the graph with "blue" default.
#' @param title Title of the given graph.
#' @param layout The layout that will be used for visualisation of the graph.
#'
#' @examples
#'
#' # Visualisation of graph in steady-state.
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_nodes(once = TRUE)%>%
#'    vis_graph()
#'
#' # Visualisation of graph after the change.
#'
#' priming_graph(minsamp, Competing_expression, miRNA_expression, aff_factor = c(seed_type,energy), deg_factor = region)%>%
#'    update_nodes(once = TRUE)%>%
#'    update_variables(current_counts)%>%
#'    update_nodes()%>%
#'    vis_graph()
#'
#' @export

vis_graph <-function(input_graph, Competing_color = "green", mirna_color = "orange", Upregulation = "red", Downregulation = "blue", title = "GRAPH", layout= "kk"){

  sample_layout <- create_layout(graph = input_graph, layout = layout)

  if(missing(layout)){
    warning("Kamada-Kawai (kk) layout was used.
")
  }

  input_graph%>%
    ggraph("manual", node.position=sample_layout)+
    geom_edge_link(colour = "#838B8B" , alpha = 0.5)+
    geom_node_point(aes(filter= (changes_variable == "Competing"), color = "Competing", size= count_current), shape= 16)+
    geom_node_point(aes(filter= (changes_variable == "miRNA"), color = "miRNA"), shape= 16, size= 2)+
    geom_node_point(aes(filter= (changes_variable == "Up"), color= "Up", size= count_current), shape= 16)+
    geom_node_point(aes(filter= (changes_variable == "Down"), color= "Down", size= count_current), shape= 16)+
    scale_colour_manual(name= "Types", values=c("Competing"=Competing_color, "miRNA"=mirna_color, "Up"=Upregulation, "Down"= Downregulation))+
    ggtitle(title) +
    theme_graph()

}
