_ = require('lodash')
datas = require( "./day20_data" )

reduceBlacklist = ->
  x = 0
  while x < datas.length
    y = x + 1
    while y < datas.length
      #  Included
      if (datas[x][0] <= datas[y][0] and datas[y][0] <= datas[x][1]) or (datas[x][0] <= datas[y][1] and datas[y][1] <= datas[x][1]) or (datas[y][0] <= datas[x][0] and datas[x][1] <= datas[y][1])
        datas[x][0] = Math.min( datas[x][0], datas[y][0] )
        datas[x][1] = Math.max( datas[x][1], datas[y][1] )
        datas.splice( y, 1 )
        return true
      y++
    x++

  x = 0
  while x < datas.length
    if datas[x][1] + 1 == datas[x+1]?[0]
      datas[x][1] = datas[x+1][1]
      datas.splice( x+1, 1 )
      return true
    x++
    
  return false

datas = _.orderBy( datas, [ (data)->data[0] ] )
while reduceBlacklist()
  # Yeah... lazy
  datas = _.orderBy( datas, [ (data)->data[0] ] )
  
count = 4294967296

for data in datas
  count -= (data[1] - data[0]) + 1

console.log count