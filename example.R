library(rdigits)

a <- digits('localhost', 5000)
a$classify_one('20150621-190234-431e', 'http://goo.gl/erOPS4')
a$classify('20150621-190234-431e', c('http://goo.gl/erOPS4', 'http://goo.gl/C6Qr2c'))

# library(RCurl)
# postForm()

library(httr)
url <- "http://httpbin.org/post"
body <- list(a = 1, b = 2, c = 3)
r <- POST(url, body = body, encode = "multipart") # "form"

url <- 'http://192.168.47.10:5000/datasets/images/classification'
body <- list(
  dataset_name = 'NEW_JOB',
  folder_train = '',
  textfile_use_val = 'y',
  method = 'textfile',
  textfile_train_images = upload_file('~/digits_image_train.txt'),
  textfile_val_images = upload_file('~/digits_image_test.txt'),
  textfile_labels_file = upload_file('~/digits_image_labels.txt'),
  csrf_token = 'None',
  resize_channels = '3',
  encoding = 'png',
  resize_width = '256',
  resize_height = '256',
  resize_mode = 'squash',
  folder_pct_val = '25',
  folder_pct_test = '0',
  textfile_val_folder = '',
  textfile_shuffle = '1',
  "create-dataset" = 'Create'
)

r <- POST(url, body = body, encode = "multipart") # "form"
r  # it works! :) (even if I get 405 Method Not Allowed, the job is created)
content(r)
