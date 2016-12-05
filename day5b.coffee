md5 = require('js-md5');

seed = 'ugkcyxxp'

x = 0
password = []
while true
  md5sum = md5(seed + x)
  if md5sum.indexOf('00000') == 0 and parseInt(md5sum.charAt(5)) <= 7
    password[md5sum.charAt(5)] = md5sum.charAt(6) unless password[md5sum.charAt(5)]?
    console.log password   
  x++

