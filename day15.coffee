#Disc #1 has 13 positions; at time=0, it is at position 11.
#Disc #2 has 5 positions; at time=0, it is at position 0.
#Disc #3 has 17 positions; at time=0, it is at position 11.
#Disc #4 has 3 positions; at time=0, it is at position 0.
#Disc #5 has 7 positions; at time=0, it is at position 2.
#Disc #6 has 19 positions; at time=0, it is at position 17.

positions = [ 13, 5, 17, 3, 7, 19 ]
start = [ 11, 0, 11, 0, 2, 17 ]

partB = false
if partB
  positions.push( 11 )
  start.push( 0 )

testTime = ( t ) ->
  for d in [0..(positions.length - 1)]
    return false unless (start[d] + t + (d + 1)) % positions[d] == 0
  return true

t = 0
while true
  t++
  if testTime( t )
    console.log t
    process.exit()