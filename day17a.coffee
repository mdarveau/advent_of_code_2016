md5 = require( 'js-md5' )
_ = require( 'lodash' )

input = "pvhmgsws"

queue = []

initialState = {
  x: 0
  y: 0
  path: ''
}

queue.push initialState

isOpen = ( chr ) ->
  return chr == 'b' or chr == 'c' or chr == 'd' or chr == 'e' or chr == 'f'

computeNextMoves = ( state ) ->
  hash = md5( input + state.path )
  console.log hash
  moves = []
  moves.push [ 'U', [ 0, -1 ] ] if state.y > 0 and isOpen( hash.charAt( 0 ) )
  moves.push [ 'D', [ 0, 1 ] ] if state.y < 3 and isOpen( hash.charAt( 1 ) )
  moves.push [ 'L', [ -1, 0 ] ] if state.x > 0 and isOpen( hash.charAt( 2 ) )
  moves.push [ 'R', [ 1, 0 ] ] if state.x < 3 and isOpen( hash.charAt( 3 ) )
  return moves


while queue.length > 0
  state = queue.shift()
  moves = computeNextMoves( state )
  console.log "state #{JSON.stringify(state)}, moves #{JSON.stringify(moves)}"
  for move in moves
    nextState = _.cloneDeep state
    nextState.path += move[0]
    nextState.x = nextState.x + move[1][0]
    nextState.y = nextState.y + move[1][1]
    
    if nextState.x == 3 and nextState.y == 3
      console.log nextState.path
      process.exit()
    
    queue.push nextState
    
    