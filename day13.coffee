String::count = ( s1 ) ->
  (@length - (@replace( new RegExp( s1, 'g' ), '' ).length)) / s1.length

input = 1364

isWall = ( x, y ) ->
  val = (x * x) + (3 * x) + (2 * x * y) + y + (y * y) + input
  return val.toString( 2 ).count( '1', '' ) % 2 == 1


process.stdout.write "  "
for x in [0..50]
  process.stdout.write "#{x % 10}"
console.log ""

map = []

for y in [0..100]
  map[y] = []
  for x in [0..100]
    map[y][x] = isWall( x, y )

for y in [0..100]
  process.stdout.write "#{y % 10} "
  for x in [0..100]
    if x == 31 and y == 39
      process.stdout.write "X"
    else
      process.stdout.write if map[y][x] then '#' else ' '
  console.log ""

locations = {}

move = ( steps, x, y ) ->
  return if x < 0
  return if y < 0
  #  return if steps > 50
  return console.log "Out of bound!" if x >= 100
  return console.log "Out of bound!" if y >= 100
  # Is this a wall?  
  return if map[y][x]
  # Maybe we already got here but maybe we now got here sooner
  return if locations["#{x}_#{y}"] and locations["#{x}_#{y}"] < steps

  locations["#{x}_#{y}"] = steps

  # Right
  move( steps + 1, x + 1, y )
  # Left
  move( steps + 1, x - 1, y )
  # Down
  move( steps + 1, x, y + 1 )
  # Up
  move( steps + 1, x, y - 1 )

move( 0, 1, 1 )

count = 0
for key, value of locations
  count++ if value <= 50 
console.log count

#for y in [0..100]
#  process.stdout.write "#{y % 10} "
#  for x in [0..100]
#    if locations["#{x}_#{y}"]
#      process.stdout.write "X"
#    else
#      process.stdout.write if map[y][x] then '#' else ' '
#  console.log ""