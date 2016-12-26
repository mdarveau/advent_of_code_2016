process.stdout._handle.setBlocking( true )

chalk = require( 'chalk' )
_ = require( 'lodash' )
grid = require( "./day24_data" )

printState = ( grid, state ) ->
  console.log "------------------------------------------------------------------------------------------------------------------------------------"
  for y in [0...grid.length]
    for x in [0...grid[y].length]
      value = grid[y][x]
      if Number.isInteger( parseInt( value ) )
        if state.checkpoints[parseInt( grid[y][x] )]
          value = chalk.green.bold( '@' )
        else
          value = chalk.red.bold( value )
      value = chalk.blue.bold( 'X' ) if state.position.x == x and state.position.y == y
      process.stdout.write value
    console.log ""
  console.log "------------------------------------------------------------------------------------------------------------------------------------"

findNumberInGrid = ( grid, number ) ->
  for y in [0...grid.length]
    for x in [0...grid[y].length]
      return {x, y} if grid[y][x] == "#{number}"

countCheckPointsCompleted = ( state ) ->
  _.reduce(state.checkpoints, (sum, n) -> sum + (if n then 1 else 0))
      
computeNextMoves = ( grid, state ) ->
  moves = []
  moves.push [ 0, -1 ] if grid[state.position.y - 1][state.position.x] != '#'
  moves.push [ 0, 1 ] if grid[state.position.y + 1][state.position.x] != '#'
  moves.push [ -1, 0 ] if grid[state.position.y][state.position.x - 1] != '#'
  moves.push [ 1, 0 ] if grid[state.position.y][state.position.x + 1] != '#'
  return moves

processed = []
queue = []

initialState = {
  position: findNumberInGrid( grid, 0 )
  checkpoints: new Array( 8 ).map ()-> return false
  moves: 0
}
initialState.checkpoints[0] = true

printState( grid, initialState )

queue.push initialState

loggedMoves = 0

shortestPath = Number.MAX_SAFE_INTEGER

while queue.length > 0
  state = queue.shift()

#  if loggedMoves < state.moves
#    loggedMoves = state.moves
#    if loggedMoves % 10 == 0
#      console.log "Processing depth #{state.moves} (#{countCheckPointsCompleted(state)} checkpoints completed), queue is now #{queue.length} long, processed #{processed.length}"
#      printState( grid, state )

  if processed.length % 500 == 0
    console.log "Processing depth #{state.moves} (#{countCheckPointsCompleted(state)} checkpoints completed), queue is now #{queue.length} long, processed #{processed.length}"
  
  moves = computeNextMoves( grid, state )
  for move in moves
    nextState = _.cloneDeep state
    nextState.moves++
    nextState.position.x += move[0]
    nextState.position.y += move[1]

    if Number.isInteger( parseInt( grid[nextState.position.y][nextState.position.x] ) )
      nextState.checkpoints[parseInt( grid[nextState.position.y][nextState.position.x] )] = true

    if _.isEqual nextState.checkpoints, [ true, true, true, true, true, true, true, true ]
      if state.moves < shortestPath
        shortestPath = state.moves
        console.log "Found solution in #{nextState.moves} moves!!!"
    else
      unless nextState.moves >= shortestPath or _.some( processed, ( state )-> _.isEqual( state.position, nextState.position ) and _.isEqual( state.checkpoints, nextState.checkpoints ) )
        queue.push nextState
        queue = _.sortBy queue, [ ( state )->
          return 8 - countCheckPointsCompleted(state) 
        , ( state )->
            state.moves
        ]
        processed.push nextState