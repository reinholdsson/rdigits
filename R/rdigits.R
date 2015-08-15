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
        return(NULL)
      }

      x <- do.call('rbind', lapply(x$predictions, function(i) data.frame(label = i[[1]], value = i[[2]])))
      x <- cbind(path = image_url, x)
      return(x)
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
    }
  )
)

#' Digits connection
#'
#' ...
#'
#' @export
digits <- function(...) DigitsConnection$new(...)
