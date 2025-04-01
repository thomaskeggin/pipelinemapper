#' Extract input and output files from a pipeline script.
#'
#' @param script_path The path to the target script as a character string.
#' @param input_tag A character tag for input paths within the target script.
#' @param output_tag A character tag for output paths within the target script.
#' @returns A data frame containing five columns: input/output file name, input/output path, script name, script path, and direction (in or out)
#' @examples
#' example_script <- system.file("dummy_pipeline/01_load_data.R", package = "pipelinemapper")
#' mapScript(example_script,input_tag  = "#input",output_tag = "#output")
#'
#' @export

mapScript <-
  function(script_path,
           input_tag  = "#input",
           output_tag = "#output"){

    # read the script
    file <-
      readLines(script_path,
                warn = FALSE)

    # extract inputs and outputs
    in_out <- list()

    # extract inputs
    if(length(file[grepl(input_tag,file)]) > 0){
      in_out$inputs <-
        data.frame(line = grep(input_tag,file),
                   direction = "in",
                   file = file[grepl(input_tag,file)])
    }

    # extract outputs
    if(length(file[grepl(output_tag,file)]) > 0){
      in_out$outputs <-
        data.frame(line = grep(output_tag,file),
                   direction = "out",
                   file = file[grepl(output_tag,file)])
    }

    # check for broken paths (one full path per line)
    in_out_df <-
      do.call(rbind.data.frame,in_out)

    for(i in 1:dim(in_out_df)[1]){

      # extract line for error messages
      line <- in_out_df$line[i]

      # check tagged string
      tagged_line_path <-
        qdapRegex::rm_between(in_out_df$file[i],
                              left = '"',right = '"',
                              extract = TRUE) |>
        unlist()

      # check for multiple strings on a single line
      if(length(tagged_line_path) > 1){

        stop(paste("There are multiple strings on line",line,"in file",script_path,".\n
                   Tagged lines can only contain one string."))
      }

      # check for missing strings
      if(is.na(tagged_line_path)){

        line <- in_out_df$line[i]

        stop(paste("There is a missing path string on line",line," in file",script_path,".\n
                   Tagged lines must contain a single string."))
      }
    }

    # store information
    if(length(in_out) > 0){
      flow_df <-
        do.call(rbind.data.frame,in_out) |>
        dplyr::mutate(file = unlist(lapply(file,
                                           qdapRegex::rm_between,
                                           left = '"',right = '"',
                                           extract = TRUE))) |>
        dplyr::mutate(script_directory = dirname(script_path),
                      script_basename  = basename(script_path),
                      file_directory   = dirname(file),
                      file_basename    = basename(file)) |>
        dplyr::relocate(file_basename, .after = file_directory) |>
        dplyr::select(-file)

      return(flow_df)
    }else{
      return(NA)
    }

  }
