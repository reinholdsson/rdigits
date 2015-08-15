library(rdigits)

a <- digits('localhost', 5000)
a$classify_one('20150621-190234-431e', 'http://purrfectcatbreeds.com/wp-content/uploads/2014/06/siberian-cat1.jpg')
a$classify('20150621-190234-431e', c('http://purrfectcatbreeds.com/wp-content/uploads/2014/06/siberian-cat1.jpg', 'http://purrfectcatbreeds.com/wp-content/uploads/2014/06/siberian-cat1.jpg'))
