test_that("mapGraph() works", {

  # run script now
  pipeline_dataframe <-
    mapPipeline(system.file("dummy_pipeline",
                            package = "pipelinemapper"))

  # tidy directories
  pipeline_dataframe$script_directory <-
    gsub(".*pipelinemapper/","./inst/",pipeline_dataframe$script_directory)
  pipeline_dataframe$script <-
    gsub(".*pipelinemapper/","./inst/",pipeline_dataframe$script)

  # observed graph
  observed_graph <-
    graphPipeline(pipeline_dataframe)

  # load in expected result
  expected_graph <-
    readRDS(system.file("expected_outputs/graphPipeline.rds",
                        package = "pipelinemapper"))

  # Each time a graph is generated, a new ID is assigned making them not
  # directly comparable. Instead we only check the edges and vertices.
  observed <-
    list(vertices = igraph::V(observed_graph) |> names(),
         edges    = igraph::as_edgelist (observed_graph))

  expected <-
    list(vertices = igraph::V(expected_graph) |> names(),
         edges    = igraph::as_edgelist (expected_graph))


  # compare the two
  expect_equal(observed, expected)
})
