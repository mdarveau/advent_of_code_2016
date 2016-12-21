_ = require('lodash')
blacklist = require( "./day20_data" )

x = 0
blacklist = _.orderBy( blacklist, [ (data)->data[0] ] )
while x < blacklist.length
  while blacklist[x][1] >= blacklist[x+1]?[0]-1
    blacklist[x][1] = Math.max(blacklist[x][1], blacklist[x+1]?[1])
    blacklist.splice( x+1, 1 )
  x++
  
isBlacklisted = ( ip )->
  for data in blacklist
    return true if data[0] <= ip and ip <= data[1]
  return false

for ip in [0..4294967295]
  if !isBlacklisted(ip)
    console.log "A: #{ip}"
    break
    
    
count = 4294967296
for data in blacklist
  count -= (data[1] - data[0]) + 1
console.log "B: #{count}"