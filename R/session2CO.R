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
  # Transform sessionInfo to data.frame
  sess_df <- n2kanalysis::session_package(sess)

  # Remove System and R version
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(.*)+(Windows >\\=)(.*)+", sess_df$Description)==FALSE)
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(.*)+(macOS )(.*)+", sess_df$Description)==FALSE)
  sess_df <- dplyr::filter(sess_df,
                    grepl("^(R)$", sess_df$Description)==FALSE)

  # Only packages from CRAN
  sess_df_cran <- dplyr::filter(sess_df, sess_df$Origin == "CRAN")

  # Create Rscript code for CRAN packages
  sess_df_cran <-
    dplyr::mutate(sess_df_cran,
                  code = paste0("RUN Rscript -e \'options(warn=2); devtools::install_version(\"",
                                sess_df_cran$Description,
                                "\", version = \"",
                                sess_df_cran$Version,
                                "\")\'"))

  # Only packages from GitHub
  sess_df_github <-
    dplyr::filter(sess_df, grepl("^(Github)(.*)+$", sess_df$Origin))

  sess_df_github <-
    dplyr::mutate(sess_df_github,
                  package = stringr::str_extract(sess_df_github$Origin,
                                                 "(?<=Github\\: )(.*)(?=@)"))

  sess_df_github <-
    dplyr::mutate(sess_df_github,
                  code = paste0("RUN Rscript -e \'devtools::install_github(\"",
                                sess_df_github$package,
                                "\", upgrade_dependencies = FALSE, ref = \"v",
                                sess_df_github$Version,
                                "\")\'"))

  # Combine CRAN and GitHub
  code_cran <- sess_df_cran$code
  code_github <- sess_df_github$code
  code <- c(code_cran, code_github)


  # Write code to txt
  readr::write_lines(code, path = path)

  # Return info
  return(print(paste0("Output saved in ", path)))
}
