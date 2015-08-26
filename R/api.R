#' Start File Server API
#'
#' ...
#'
#' @param host digits server host, e.g. localhost
#' @param port digits server port, e.g. 5000
start_api <- function(server_path = '~/Desktop/digits', host = 'localhost', port = 5000) {
  require(plumber)
  require(whisker)
  file_tmpl <- file.path(system.file(package = 'rdigits'), 'api_template.R')
  tmpl <- readChar(file_tmpl, file.info(file_tmpl)$size)

  api_text <- whisker.render(tmpl, mget(names(formals()),sys.frame(sys.nframe())))
  api_file <- tempfile(fileext = '.R')

  fileConn <- file(api_file)
  writeLines(api_text, fileConn)
  close(fileConn)

  r <- plumb(api_file)
  r$run(port = 8000)
}
