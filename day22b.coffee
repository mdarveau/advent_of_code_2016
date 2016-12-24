dd = require( "./day22_data" )

grid = new Array(31)
for y in [0...grid.length]
  grid[y] = new Array(33)
    
for d in dd
  grid[d.y][d.x] = d
    
printSizes = ->
  for y in [0...grid.length]
    for x in [0...grid[y].length]
      d = grid[y][x]
      out = "#{d.used}/#{d.size}"
      process.stdout.write ' '.repeat(Math.floor((7-out.length)/2)) + out + ' '.repeat(Math.ceil((7-out.length)/2)) + " | " 
    console.log "" 
    
printSizes()

#for y in [0...grid.length]
#  for x in [0...grid[y].length]
#    fit = true
#    d = grid[y][x]

    
# 63 to y0, x-1 + 5*31