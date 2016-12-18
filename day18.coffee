md5 = require( 'js-md5' )
_ = require( 'lodash' )

grid = [ ".^^^.^.^^^.^.......^^.^^^^.^^^^..^^^^^.^.^^^..^^.^.^^..^.^..^^...^.^^.^^^...^^.^.^^^..^^^^.....^...." ]

#grid = [ ".^^.^.^^^^" ]

#nbRows = 40
nbRows = 400000

for r in [1..(nbRows-1)]
  previous = grid[r - 1]
  current = ""
  for x in [0..previous.length - 1]
    # true == trap
    left = if x == 0 then false else previous.charAt( x - 1 ) == '^'
    center = previous.charAt( x )  == '^'
    right = if x == previous.length - 1 then false else previous.charAt( x + 1 )  == '^'
    
    # ^^.
    # .^^
    # ^..
    # ..^
    trap = (left and center and !right) or (!left and center and right) or (left and !center and !right) or (!left and !center and right)
    
    current += if trap then '^' else '.'
  
  grid.push current
  
count = 0
for r in [0..(nbRows-1)]
  for x in [0..grid[r].length - 1]
    count++ if grid[r][x] == '.'
    
console.log count