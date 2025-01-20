# This function converts a pipeline data frame into a graph object
# input: pipeline data frame
# output: pipeline graph object
#' @export

graphPipeline <-
  function(pipeline_dataframe){

    # wrangle
    ins <-
      pipeline_dataframe |>
      dplyr::filter(direction == "in") |>
      dplyr::rename(from = file, to = script) |>
      dplyr::select(-direction)

    outs <-
      pipeline_dataframe |>
      dplyr::filter(direction == "out") |>
      dplyr::rename(from = script, to = file) |>
      dplyr::select(-direction)

    edge_df <-
      rbind.data.frame(ins,outs) |>
      na.omit()

    vertex_in <-
      ins |>
      tidyr::pivot_longer(cols = c(from,to),
                   names_to = "direction",
                   values_to = "name") |>
      dplyr::mutate(type = ifelse(direction == "from","file","script")) |>
      dplyr::select(-c(direction))

    vertex_out <-
      outs |>
      tidyr::pivot_longer(cols = c(from,to),
                   names_to = "direction",
                   values_to = "name") |>
      dplyr::mutate(type = ifelse(direction == "to","file","script")) |>
      dplyr::select(-c(direction))

    vertex_df <-
      rbind.data.frame(vertex_in,vertex_out) |>
      #mutate(dir_path = ifelse(type == "file",NA,dir_path)) |>
      dplyr::relocate(name) |>
      dplyr::select(-contains("path")) |>
      dplyr::distinct()

    # convert
    flow_graph <-
      igraph::graph_from_data_frame(edge_df, directed=TRUE, vertices=vertex_df)

    # return an igraph object
    return(flow_graph)

  }


