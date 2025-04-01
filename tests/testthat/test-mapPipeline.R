test_that("mapPipeline() works", {

  # run script now
  observed <-
    mapPipeline(system.file("dummy_pipeline",
                          package = "pipelinemapper"))

  # tidy directories
  observed$script_directory <-
    gsub(".*pipelinemapper/","./inst/",observed$script_directory)
  observed$script <-
    gsub(".*pipelinemapper/","./inst/",observed$script)

  # load in expected result
  expected <-
    readRDS(system.file("expected_outputs/mapPipeline.rds",
                        package = "pipelinemapper"))

  # compare the two
  expect_equal(observed, expected)
})
