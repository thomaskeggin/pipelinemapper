
#' Plots a pipeline graph
#'
#' This is a default way of plotting the igraph object returned by [graphPipeline()]
#' using ggraph and ggplot2. If you would like to customise the plot, it is
#' probably easier to refer directly to igraph, ggraph, and ggplot2
#' documentation.
#'
#' @param pipeline_graph A pipeline igraph object returned by [graphPipeline()].
#' @param use_full_paths Whether or not full file paths should be displayed.
#'  use_full_paths = FALSE only displays the file basenames.
#'
#' @returns A ggraph plot object
#' @export
#'
#' @examples
#' example_directory <- system.file("dummy_pipeline", package = "pipelinemapper")
#' pipeline_dataframe <- mapPipeline(example_directory)
#' pipeline_graph <- graphPipeline(pipeline_dataframe)
#' plotPipeline(pipeline_graph, use_full_paths = TRUE)
#'

plotPipeline <-
  function(pipeline_graph,
           use_full_paths = TRUE){

    # remove full paths if specified
    if(use_full_paths == FALSE){

      pipeline_graph <-
        igraph::set_vertex_attr(pipeline_graph, "name",
                                value = basename(names(igraph::V(pipeline_graph))))
    }

    # generate plot
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

      ggplot2::scale_fill_manual(values = c("lightgrey","#88CCEE")) +
      ggplot2::scale_colour_manual(values = c("black","#88CCEE")) +
      ggplot2::theme_void()


  }
