md5 = require('js-md5');

seed = 'ugkcyxxp'

x = 0
while true
  md5sum = md5(seed + x)
  console.log md5sum.charAt(5) if md5sum.indexOf('00000') == 0  
  x++

