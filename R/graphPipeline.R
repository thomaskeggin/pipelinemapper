
#' Convert a pipeline input/output data frame into an igraph object.
#'
#' @param pipeline_dataframe An input/output data frame returned by [mapPipeline()].
#'
#' @returns A directional igraph describing the workflow of the mapped
#' pipeline.
#'
#' @export
#'
#' @examples
#' example_directory <- system.file("dummy_pipeline", package = "pipelinemapper")
#' pipeline_dataframe <- mapPipeline(example_directory)
#' graphPipeline(pipeline_dataframe)
#'
#'

graphPipeline <-
  function(pipeline_dataframe){

    # Define graph edges -------------------------------------------------------
    # Create directional data frame for inputs
    ins <-
      pipeline_dataframe |>
      dplyr::filter(direction == "in") |>
      dplyr::rename(from = file, to = script) |>
      dplyr::select(from,to,script_directory,file_directory)

    # Create directional data frame for outputs
    outs <-
      pipeline_dataframe |>
      dplyr::filter(direction == "out") |>
      dplyr::rename(from = script, to = file)|>
      dplyr::select(from,to,script_directory,file_directory)

    # Combine directional data frames into a data frame containing all
    # graph edges.
    edge_df <-
      rbind.data.frame(ins,outs) |>
      stats::na.omit()

    # Define graph vertices ----------------------------------------------------
    # create a data frame defining input files
    vertex_in <-
      ins |>
      tidyr::pivot_longer(cols = c(from,to),
                          names_to = "direction",
                          values_to = "name") |>
      dplyr::mutate(type = ifelse(direction == "from","file","script")) |>
      dplyr::select(name,type)

    # create a data frame defining output files
    vertex_out <-
      outs |>
      tidyr::pivot_longer(cols = c(from,to),
                          names_to = "direction",
                          values_to = "name") |>
      dplyr::mutate(type = ifelse(direction == "to","file","script")) |>
      dplyr::select(name,type)

    # Compile input and output vertices into a single data frame
    vertex_df <-
      rbind.data.frame(vertex_in,vertex_out) |>
      dplyr::distinct()

    # Convert edge and vertex data frames into a directional graph -------------
    pipeline_graph <-
      igraph::graph_from_data_frame(edge_df,
                                    directed=TRUE,
                                    vertices=vertex_df)

    # return an igraph object --------------------------------------------------
    return(pipeline_graph)

  }


