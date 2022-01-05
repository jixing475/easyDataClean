#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param obj PARAM_DESCRIPTION
#' @param type PARAM_DESCRIPTION, Default: 'rds' other is "feather"
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[readr]{read_rds}}
#'  \code{\link[arrow]{write_feather}}
#'  \code{\link[stringr]{str_glue}}
#' @rdname transfer.sh
#' @export 
#' @importFrom readr write_rds
#' @importFrom arrow write_feather
#' @importFrom stringr str_glue
transfer.sh <- function(obj, type = "rds") {
  # type: rds or feather
  
  if (type == "rds"){
    tmp_file <- tempfile() %>% paste0(".rds")
    readr::write_rds(obj, tmp_file)
  } else {
    tmp_file <- tempfile() %>% paste0(".feather")
    arrow::write_feather(obj, tmp_file)
  }
  
  download_url <- 
    stringr::str_glue('curl --upload-file {tmp_file} https://transfer.sh/`basename "{tmp_file}"` ') %>%
    system(intern = TRUE)
  
  return(download_url)
}
