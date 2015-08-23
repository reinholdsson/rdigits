DigitsConnection <- R6Class("Digits Connection",
  public = list(
    host = 'localhost',
    port = 5000L,
    initialize = function(host, port) {
      if (!missing(host)) self$host <- host
      if (!missing(port)) self$port <- port

      self$greet()
    },
    greet = function() {
      message('Connected to digits server ...')
    },
    #' Classify one image
    classify_one = function(job_id, image_url) {
      res <- POST(
        sprintf('%s:%s/models/images/classification/classify_one.json?job_id=%s', self$host, self$port, job_id),
        body = list(image_url = image_url)
      )

      x <- content(res)

      st_code <- status_code(res)
      if (st_code != 200) {
        warning(st_code, ', ', x$error$type, ': ', x$error$message, '\n => ', image_url)
        output <- data.frame(label = NA, value = NA)
      } else {
        output <- do.call('rbind', lapply(x$predictions, function(i) data.frame(label = i[[1]], value = i[[2]])))
      }
      output <- cbind(path = image_url, output)
      return(output)
    },

    #' Classify image(s)
    #'
    #' Classify one or multiple images. Provide url or file path on server.
    #'
    #' @param ... arguments passed on to classify_one(...)
    #'
    #' @export
    classify = function(job_id, image_url) {
      do.call('rbind', pblapply(1:length(image_url), function(i) {
        cbind(seq_id = i, self$classify_one(job_id, image_url[[i]]))
      }))
    },

    create_dataset = function(
      dataset_name,
      images,
      labels,
      encoding = 'png',
      resize_width = '256',
      resize_height = '256',
      resize_mode = 'squash',
      p = .8,
      trainIndex = NULL
    ) {
      # TODO: make use of match.call() to get all arguments?
      stopifnot(length(images) == length(labels))

      if (is.null(trainIndex)) {
        trainIndex <- sample(1:length(images), floor(p*length(images)))
      }

      unique_levels <- sort(unique(labels))
      labels_num <- sapply(labels, function(i) grep(i, un_lvl) - 1)  # seq starting from 0

      # browser()
      data <- data.frame(images, labels_num)
      file_train <- temp_file(data[trainIndex,])
      file_test <- temp_file(data[-trainIndex,])
      file_labels <- temp_file(unique_levels)

      url <- sprintf('%s:%s/datasets/images/classification', self$host, self$port)
      body <- list(
        dataset_name = dataset_name,
        folder_train = '',
        textfile_use_val = 'y',
        method = 'textfile',
        textfile_train_images = upload_file(file_train),
        textfile_val_images = upload_file(file_test),
        textfile_labels_file = upload_file(file_labels),
        csrf_token = 'None',
        resize_channels = '3',
        encoding = encoding,
        resize_width = resize_width,
        resize_height = resize_height,
        resize_mode = resize_mode,
        folder_pct_val = '25',
        folder_pct_test = '0',
        textfile_val_folder = '',
        textfile_shuffle = '1',
        'create-dataset' = 'Create'
      )

      r <- POST(url, body = body, encode = "multipart") # "form"
      # r  # it works! :) (even if I get 405 Method Not Allowed, the job is created)
      # content(r)
      return('RETURN JOB ID IF SUCCESS')
    }
  )
)

#' Digits connection
#'
#' ...
#'
#' @export
digits <- function(...) DigitsConnection$new(...)

temp_file <- function(df) {
  f <- tempfile(fileext = '.txt')
  write.table(df, f, col.names = F, row.names = F, quote = F, sep = '\t')
  return(f)
}
