dd = require( "./day22_data" )

viable = 0
for x in [0...dd.length]
  for y in [x+1...dd.length]
#    console.log "#{dd[x].used} <= #{dd[y].avail} = #{dd[x].used <= dd[y].avail}"
    viable++ if (dd[x].used != 0 and dd[x].used <= dd[y].avail) or (dd[y].used != 0 and dd[y].used <= dd[x].avail)
    
console.log viable