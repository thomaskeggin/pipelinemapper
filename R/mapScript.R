#' Extract input and output files from a pipeline script.
#'
#' @param script_path The path to the target script as a character string.
#' @param input_tag A character tag for input paths within the target script.
#' @param output_tag A character tag for output paths within the target script.
#' @returns A data frame containing five columns: input/output file name, input/output path, script name, script path, and direction (in or out)
#' @examples
#' 1 + 1
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
        data.frame(file = file[grepl(input_tag,file)],
                   direction = "in")
    }

    # extract outputs
    if(length(file[grepl(output_tag,file)]) > 0){
      in_out$outputs <-
        data.frame(file = file[grepl(output_tag,file)],
                         direction = "out")
    }

    # store information
    if(length(in_out) > 0){
      flow_df <-
        do.call(rbind.data.frame,in_out) |>
        dplyr::mutate(file        = unlist(lapply(file,
                                                  qdapRegex::rm_between,
                                                  left = '"',right = '"',
                                                  extract = TRUE))) |>
        dplyr::mutate(script      = basename(script_path),
                      script_path = dirname(script_path),
                      file_path   = dirname(file),
                      file        = basename(file))

      return(flow_df)
    }else{
      return(NA)
    }

  }
