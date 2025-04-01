test_that("mapScript() works", {

  # run script now
  observed <-
    mapScript(system.file("dummy_pipeline/01_load_data.R",
                          package = "pipelinemapper"),
              input_tag  = "#input",
              output_tag = "#output")

  # tidy directory
  observed$script_directory <-
    gsub(".*pipelinemapper/","./inst/",observed$script_directory)

  # load in expected result
  expected <-
    readRDS(system.file("expected_outputs/mapScript.rds",
                        package = "pipelinemapper"))

  # compare the two
  expect_equal(observed, expected)
})
