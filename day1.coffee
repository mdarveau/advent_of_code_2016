data = "L5,R1,R3,L4,R3,R1,L3,L2,R3,L5,L1,L2,R5,L1,R5,R1,L4,R1,R3,L4,L1,R2,R5,R3,R1,R1,L1,R1,L1,L2,L1,R2,L5,L188,L4,R1,R4,L3,R47,R1,L1,R77,R5,L2,R1,L2,R4,L5,L1,R3,R187,L4,L3,L3,R2,L3,L5,L4,L4,R1,R5,L4,L3,L3,L3,L2,L5,R1,L2,R5,L3,L4,R4,L5,R3,R4,L2,L1,L4,R1,L3,R1,R3,L2,R1,R4,R5,L3,R5,R3,L3,R4,L2,L5,L1,L1,R3,R1,L4,R3,R3,L2,R5,R4,R1,R3,L4,R3,R3,L2,L4,L5,R1,L4,L5,R4,L2,L1,L3,L3,L5,R3,L4,L3,R5,R4,R2,L4,R2,R3,L3,R4,L1,L3,R2,R1,R5,L4,L5,L5,R4,L5,L2,L4,R4,R4,R1,L3,L2,L4,R3".split( ',' )

position =
  x: 0
  y: 0

directionIndex = 0

directions = [ [ 0, 1, "N" ], [ 1, 0, "E" ], [ 0, -1, "S" ], [ -1, 0, "W" ] ]
# L = -1
# R = 1

history = {}

for move in data
  newDirection = move.substring( 0, 1 )
  steps = parseInt( move.substring( 1 ) )

  directionIndex -= 1 if newDirection == 'L'
  directionIndex += 1 if newDirection == 'R'
  directionIndex += 4 if directionIndex < 0

  direction = directions[directionIndex % 4]
  console.log "Turning #{newDirection} (#{direction}) then #{steps} steps"

  for step in [1..steps]
    position.x += direction[0] * 1
    position.y += direction[1] * 1
    console.log "New position is #{position.x}, #{position.y}"
    if history["#{position.x},#{position.y}"]?
      console.log "Final position is #{position.x}, #{position.y}"
      distance = Math.abs( position.x ) + Math.abs( position.y )
      console.log "Final distance is #{distance}"
      process.exit()
    history["#{position.x},#{position.y}"] = true
