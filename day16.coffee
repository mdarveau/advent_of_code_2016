#input = "01110110101001000"
#disk = 272

input = "01110110101001000"
disk = 35651584

#input = "10000"
#disk = 20



data = input
while data.length < disk
  b = ""
  for x in [(data.length - 1)..0]
    b += (if data.charAt( x ) == '0' then '1' else '0')
  data += "0" + b

data = data.substr( 0, disk )

checksum = ( data ) ->
  chk= ""
  for x in [0..(data.length - 1)] by 2
    chk += (if data.charAt(x) == data.charAt(x+1) then '1' else '0')
    
  return chk
  
chk = checksum(data)
while chk.length % 2 == 0
  chk = checksum(chk)
  
console.log chk