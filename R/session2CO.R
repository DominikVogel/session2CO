#' Convert sessionInfo to Code Ocean
#'
#' Converts the output of sessionInfo() in lines of RUN Rscript code for Code Ocean
#' @param sess Stored sessionInfo
#' @param path A path and filename for to store the reuslts
#' @keywords sessionInfo, Code Ocean, Docker
#' @return Writes a file with RUN Rscript lines per package
#' @export session2CO
#' @examples
#' sess <- sessionInfo()
#' session2CO(sess = sess, path = "session2CO.txt")

session2CO <- function(sess = NULL, path = paste0(getwd(), "/session2CO.txt")) {
  # sess <- sessionInfo()
  sess_df <- n2kanalysis::session_package(sess)

  # Remove System and R version
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(.*)+(Windows >\\=)(.*)+", Description)==FALSE)
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(.*)+(macOS )(.*)+", Description)==FALSE)
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(R)$", Description)==FALSE)

  # Create Rscript code
  sess_df <-
    dplyr::mutate(sess_df,
                  code = paste0("RUN Rscript -e \'options(warn=2); devtools::install_version(\"",
                                Description,
                                "\", version = \"",
                                Version,
                                "\")\'"))

  code <- sess_df$code

  # Write code to txt
  readr::write_lines(code, path = path)

  # Return info
  return(print(paste0("Output saved in ", path)))
}
