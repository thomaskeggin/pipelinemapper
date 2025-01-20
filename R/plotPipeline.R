# this function plots a pipeline graph using ggraph
# input: an igraph pipeline object
# output: a ggprah pplot object
#' @export

plotPipeline <-
  function(pipeline_graph){

    ggraph::ggraph(pipeline_graph,
                   layout = "sugiyama", #"tree" "sugiyama"
                   circular = FALSE) +

      # nodes
      ggraph::geom_node_point(ggplot2::aes(colour = type)) +
      ggraph::geom_node_label(repel = TRUE,
                              ggplot2::aes(#label = str_wrap(name, width = 10),
                                label = sub(".*? ", "", name),
                                fill = type)) +

      # edges
      ggraph::geom_edge_diagonal(arrow = ggplot2::arrow(length = ggplot2::unit(4, 'mm'),type = "closed"),
                                 start_cap = ggraph::circle(10, 'mm'),
                                 end_cap = ggraph::circle(10, 'mm'),
                                 #edge_width = 1.5,
                                 edge_alpha = 1,
                                 edge_color = "grey") +
      #geom_edge_diagonal(aes(start_cap = label_rect(node1.name),
      #                       end_cap = label_rect(node2.name)),
      #                   arrow = arrow(length = unit(4, 'mm')),
      #                   edge_width = 1.5,
      #                   edge_alpha = 0.5) +

      #coord_flip() +
      #scale_y_reverse() +
      ggplot2::scale_fill_manual(values = c("lightgrey","#88CCEE")) +
      ggplot2::scale_colour_manual(values = c("black","#88CCEE")) +
      ggplot2::theme_void()



  }
