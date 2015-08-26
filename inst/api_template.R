library(rdigits)
library(data.table)
# a <- digits  # TODO: add digits api functions

#' @get /jobs
jobs <- function() {
  list.files('{{server_path}}')
}

#' @get /data
#' data.table::rbindlist(httr::content(httr::GET('http://localhost:8000/data?job=job1')))
data <- function(job) {  # data => input data
  txt_file <- function(x) file.path('{{server_path}}', job, paste0(x, '.txt'))
  read_job_file <- function(type, col.names = c('path', 'label_seq_id')) {
    if (file.exists(txt_file(type))) {
      res <- data.table::fread(txt_file(type))
      colnames(res) <- col.names
      res <- cbind(type = type, res)

      res
    } else NULL
  }

  # read data
  x <- data.table::rbindlist(lapply(c('train', 'val', 'test'), read_job_file))
  # replace label nums with label text
  labels <- read_job_file('labels', col.names = 'label')
  labels$label_seq_id <- 1:nrow(labels) - 1
  labels <- subset(labels, select = c('label', 'label_seq_id'))
  data <- merge(x, labels, by = c('label_seq_id'))
  # print(head(data))
  data
}
