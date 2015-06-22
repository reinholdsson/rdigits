#' Classify one image
classify_one <- function(server_url, job_id, image_url) {
  res <- POST(
    sprintf('%s/models/images/classification/classify_one.json?job_id=%s', server_url, job_id),
    body = list(image_url = image_url)
  )
  
  x <- content(res)
  
  st_code <- status_code(res)
  if (st_code != 200) {
    warning(st_code, ', ', x$error$type, ': ', x$error$message, '\n => ', image_url)
    return(NULL)
  }
  
  x <- do.call('rbind', lapply(x$predictions, function(i) data.frame(label = i[[1]], value = i[[2]])))
  x <- cbind(image_url, x)
  #print(paste(ncol(x), image_url))
  #browser()
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
classify <- function(images, ...) {
  do.call('rbind', pblapply(images, function(i) {
    x <- classify_one(image_url = i, ...)
    #print(x)
    return(x)
  }))
}
