# This function calls mapScript to map out a pipeline.
# Input: a directory with pipeline scripts
# Output: a data frame with script inputs and outputs
#' @export

mapPipeline <-
  function(pipeline_directory_path,
           file_extensions = c(".r",".rmd",".qmd")){

    # clean the pipeline path
    pipeline_path_end <-
      substr(x     = pipeline_directory_path,
             start = nchar(pipeline_directory_path),
             stop  = nchar(pipeline_directory_path))

    if(pipeline_path_end != "/"){
      pipeline_directory_path <-
        paste0(pipeline_directory_path,"/")
    }

    # vector of script names in target directory
    pipeline_scripts <-
      list.files(pipeline_directory_path)

    # reformat file extensions to work with grep
    file_extensions <-
      gsub("\\.","\\\\.",file_extensions)

    # keep only target file types
    pipeline_scripts <-
      pipeline_scripts[grepl(paste(file_extensions,collapse = "|"),
                             pipeline_scripts,
                             ignore.case = TRUE)]

    # container for flow information
    project_flow <-
      list()

    # map each script in the pipeline
    for(script in pipeline_scripts){

      project_flow[[script]] <-
        mapScript(paste0(pipeline_directory_path,
                         script))
    }

    # compile into a single data frame with NAs for scripts without tags
    flow_df <-
      do.call(rbind.data.frame,
              project_flow)

    flow_df$file <-
      paste(flow_df$file_path,
            flow_df$file)

    flow_df$script <-
      paste(flow_df$script_path,
            flow_df$script)

    # return compiled data frame
    return(flow_df)
  }
