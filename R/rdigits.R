#' Classify one image
classify_one <- function(server_url, job_id, image_url) {
  x <- POST(
    sprintf('%s/models/images/classification/classify_one.json?job_id=%s', server_url, job_id),
    body = list(image_url = image_url)
  )
  x <- content(x)
  x <- do.call('rbind', lapply(x$predictions, function(i) data.frame(label = i[[1]], value = i[[2]])))
  x <- cbind(image_url, x)
  return(x)
}

#' Classify image(s)
#'
#' Classify one or multiple images. Provide url or file path on server.
#'
#' @param images image paths (either url or server path)
#' @param ... arguments passed on to classify_one(...)
#'
#' @export
classify <- function(images, ...)
  do.call('rbind', pblapply(images, function(i) classify_one(image_url = i, ...)))
