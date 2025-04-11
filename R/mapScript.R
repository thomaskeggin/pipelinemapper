#' Extract tagged input and output paths from a script.
#'
#' mapScript() extracts tagged input and output paths from a script. The target script is
#' read into memory and queried for the user-specified input and output tags.
#' Character strings on these tagged lines are assumed to be file paths, are
#' extracted, split into their respective directory paths ([dirname()]) and base
#' names ([basename()]), then compiled into a data frame as detailed below.
#'
#' @param script_path The path to the target script as a character string.
#' @param input_tag A character tag for input paths within the target script.
#' @param output_tag A character tag for output paths within the target script.
#' @returns A data frame containing the following columns describing the target
#'  script's input and and output paths.
#'
#'  \item{line}{integer. The line the path is present on within the script.}
#'  \item{direction}{character. Values are either "in" or "out" to differentiate input or output files.}
#'  \item{script_directory}{character. The path to the script's directory.}
#'  \item{script_basename}{character. The script's basename.}
#'  \item{file_directory}{character. The path to the input or output file's directory.}
#'  \item{file_basename}{character. The input or output file's basename.}
#'  \item{file}{character. The input or output file's full path.}
#'  \item{script}{character. The script's full path.}
#'
#' @examples
#' example_script_path <-
#'   system.file("dummy_pipeline/01_load_data.R",
#'               package = "pipelinemapper")
#'
#' mapScript(example_script_path,
#'           input_tag = "#input",
#'           output_tag = "#output")
#'
#' @export
#' @importFrom rlang .data

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

    # stop if no tags at all are found
    if(length(in_out) > 0){

      # combine inputs and outputs
      in_out_df <-
        do.call(rbind.data.frame,in_out) |>

        # and convert ' to "
        dplyr::mutate(file = gsub("'",'"',.data$file))

      # check for broken paths
      for(i in 1:dim(in_out_df)[1]){

        # extract line for error messages
        line <- in_out_df$line[i]

        # check tagged string
        tagged_line_path <-
          qdapRegex::rm_between(in_out_df$file[i],
                                left = '"',
                                right = '"',
                                extract = TRUE) |>
          unlist()

        # check for multiple strings on a single line
        if(length(tagged_line_path) > 1){

          stop(paste("There are multiple strings on line",
                     line,"in file",script_path,
                     ".\nTagged lines can only contain one string."))
        }

        # check for missing strings
        if(is.na(tagged_line_path)){

          line <- in_out_df$line[i]

          stop(paste("There is a missing path string on line",
                     line," in file",script_path,
                     ".\nTagged lines must contain a single string."))
        }
      }

      # store information
      flow_df <-
        in_out_df |>
        dplyr::mutate(file = unlist(lapply(file,
                                           qdapRegex::rm_between,
                                           left = '"',
                                           right = '"',
                                           extract = TRUE))) |>
        dplyr::mutate(script_directory = dirname(script_path),
                      script_basename  = basename(script_path),
                      file_directory   = dirname(.data$file),
                      file_basename    = basename(.data$file)) |>
        dplyr::relocate("file_basename", .after = "file_directory") |>
        dplyr::select(-"file") |>
        dplyr::mutate(file = paste(.data$file_directory,
                                   .data$file_basename,
                                   sep = "/"),
                      script = paste(.data$script_directory,
                                     .data$script_basename,
                                     sep = "/"))

      return(flow_df)
    }else{
      return(NA)
    }
  }


