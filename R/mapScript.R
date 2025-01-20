# This function reads a script and extracts input and output paths tagged with
# something like "#input" or "#output" (it can be anything).
# Hope it's useful!
# Thomas Keggin
# thomaskeggin@hotmail.com

mapScript <-
  function(script_path,
           input_tag  = "#input",
           output_tag = "#output"){

    # read the script
    file <-
      readLines(script_path,
                warn = FALSE)

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
        data.frametibble(file = file[grepl(output_tag,file)],
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
