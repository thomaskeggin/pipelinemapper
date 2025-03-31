
#' Generates a data frame of file inputs and outputs for scripts within a pipeline directory.
#'
#'This script loops [mapScript()] through all scripts within a target directory
#' containing the specified file extensions. The inputs and outputs are compiled
#' into a single output data frame.
#'
#'
#' @param pipeline_directory_path The path to the pipeline directory.
#' @param file_extensions A character vector containing all file extensions to be considered.
#'
#' @returns A data frame containing five columns: input/output file name,
#' input/output path, script name, script path, and direction (in or out).
#' @export
#'
#' @examples
#'
#' 1 + 1
#'
#'

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
    pipeline_dataframe <-
      do.call(rbind.data.frame,
              project_flow)

    pipeline_dataframe$file <-
      paste(pipeline_dataframe$file_path,
            pipeline_dataframe$file)

    pipeline_dataframe$script <-
      paste(pipeline_dataframe$script_path,
            pipeline_dataframe$script)

    # return compiled data frame
    return(pipeline_dataframe)
  }
