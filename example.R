# library(rdigits)
# 
# a <- digits('localhost', 5000)
# a$classify_one('20150621-190234-431e', 'http://goo.gl/erOPS4')
# a$classify('20150621-190234-431e', c('http://goo.gl/erOPS4', 'http://goo.gl/C6Qr2c'))

library(httr)
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
  'create-dataset' = 'Create'
)

r <- POST(url, body = body, encode = "multipart", add_headers(
  Host = '192.168.47.10:5000',
  Connection = 'keep-alive',
  # 'Content-Length' = '1235282', # DON'T USE THIS! APP HANGS!
  "Cache-Control" = 'max-age=0',
  Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  Origin = 'http://192.168.47.10:5000',
  'Upgrade-Insecure-Requests' = '1',
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36',
  # 'Content-Type' = 'multipart/form-data; boundary=----WebKitFormBoundaryptL5PXteV86F0eZH',
  'Content-Type' = 'multipart/form-data', #; boundary=----WebKitFormBoundaryptL5PXteV86F0eZH',
  Referer = 'http://192.168.47.10:5000/datasets/images/classification/new',
  'Accept-Encoding' = 'gzip, deflate',
  'Accept-Language' = 'sv-SE,sv;q=0.8,en-US;q=0.6,en;q=0.4'
  #Cookie = 'user-id=reinholdsson|Thu%2C%2014%20Aug%202025%2009%3A42%3A09%20GMT|McRsrpE3CIA3ojvJKGWh23CBbdc%3D'
)) # "form"
r  # it works! :) (even if I get 405 Method Not Allowed, the job is created)
content(r)

# Can't get it to work without 405 error, use RSelenium instead?
