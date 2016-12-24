process.stdout._handle.setBlocking( true )

_ = require( 'lodash' )
dd = require( "./day22_data" )

grid = new Array( 31 )
for y in [0...grid.length]
  grid[y] = new Array( 33 )

for d in dd
  grid[d.y][d.x] = d

printSizes = ( grid ) ->
  for y in [0...grid.length]
    for x in [0...grid[y].length]
      d = grid[y][x]
      out = "#{d.used}/#{d.size}"
      process.stdout.write ' '.repeat( Math.floor( (7 - out.length) / 2 ) ) + out + ' '.repeat( Math.ceil( (7 - out.length) / 2 ) ) + " | "
    console.log ""

printSizes( grid )

convertToBlock = ( grid ) ->
  blocks = new Array( grid.length )
  for y in [0...grid.length]
    blocks[y] = new Array( grid[y].length )
    for x in [0...blocks[y].length]
      used = grid[y][x].used
      if used < (grid[y - 1]?[x]?.size ? Number.MAX_SAFE_INTEGER) and used < (grid[y + 1]?[x]?.size ? Number.MAX_SAFE_INTEGER) and used < (grid[y]?[x - 1]?.size ? Number.MAX_SAFE_INTEGER) and used < (grid[y - 1]?[x + 1]?.size ? Number.MAX_SAFE_INTEGER)
        blocks[y][x] = true
      else
        blocks[y][x] = false

  return blocks

printState = ( state ) ->
  console.log "------------------------------------------------------------------------------------------------------------------------------------"
  for y in [0...blocks.length]
    for x in [0...blocks[y].length]
      if state.zero.x == x and state.zero.y == y
        value = 'X'
      else if state.payload.x == x and state.payload.y == y
        value = '$'
      else
        value = if blocks[y][x] then '.' else '#'
      process.stdout.write " #{value} |"
    console.log ""
  console.log "------------------------------------------------------------------------------------------------------------------------------------"

findZeroInGrid = ( grid ) ->
  for y in [0...grid.length]
    for x in [0...grid[y].length]
      return {x, y} if grid[y][x].used == 0

computeNextMoves = ( state ) ->
  moves = []
  moves.push [ 0, -1 ] if blocks[state.zero.y - 1]?[state.zero.x]
  moves.push [ 0, 1 ] if blocks[state.zero.y + 1]?[state.zero.x]
  moves.push [ -1, 0 ] if blocks[state.zero.y]?[state.zero.x - 1]
  moves.push [ 1, 0 ] if blocks[state.zero.y]?[state.zero.x + 1]
  return moves

processed = []
queue = []

blocks = convertToBlock( grid )
initialState = {
  zero: findZeroInGrid( grid )
  payload: {x: blocks[0].length - 1, y: 0}
  moves: 0
}

printState( initialState )

queue.push initialState

loggedMoves = 0

while queue.length > 0
  state = queue.shift()

  if loggedMoves < state.moves
    loggedMoves = state.moves
    console.log "Processing depth #{state.moves}, queue is now #{queue.length} long"
#    printState( state )

  moves = computeNextMoves( state )
  for move in moves
    nextState = _.cloneDeep state
    nextState.moves++
    nextState.zero.x += move[0]
    nextState.zero.y += move[1]
    if state.payload.x == nextState.zero.x and state.payload.y == nextState.zero.y
      nextState.payload.x -= move[0]
      nextState.payload.y == move[1]

    if nextState.payload.x == 0 and nextState.payload.y == 0
      console.log "Found solution in #{nextState.moves} moves!!!"
      process.exit()

    unless _.some( processed, ( state )-> _.isEqual( state.zero, nextState.zero ) and _.isEqual( state.payload, nextState.payload ) )
      queue.push nextState
      queue = _.sortBy queue, [ ( state )->
        state.payload.x + state.payload.y
      , ( state )->
          Math.abs( state.zero.x - state.payload.x ) + Math.abs( state.zero.y - state.payload.y )
      , ( state )->
          state.moves
      ]
      processed.push nextState