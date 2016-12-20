datas = require( "./day20_data" )

isBlacklisted = ( ip )->
  for data in datas
    return true if data[0] <= ip and ip <= data[1]
  return false

for ip in [0..4294967295]
  if !isBlacklisted(ip)
    console.log "Result:" + ip
    process.exit()
  console.log ip if ip % 1000000 == 0
  
  
# 3238000000
# 4294967295