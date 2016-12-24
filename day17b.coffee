md5 = require( 'js-md5' )
_ = require( 'lodash' )

input = "pvhmgsws"

queue = []

initialState = {
  x: 0
  y: 0
  path: ''
}

longest = null

queue.push initialState

isOpen = ( chr ) ->
  return chr == 'b' or chr == 'c' or chr == 'd' or chr == 'e' or chr == 'f'

computeNextMoves = ( state ) ->
  hash = md5( input + state.path )
  moves = []
  moves.push [ 'U', [ 0, -1 ] ] if state.y > 0 and isOpen( hash.charAt( 0 ) )
  moves.push [ 'D', [ 0, 1 ] ] if state.y < 3 and isOpen( hash.charAt( 1 ) )
  moves.push [ 'L', [ -1, 0 ] ] if state.x > 0 and isOpen( hash.charAt( 2 ) )
  moves.push [ 'R', [ 1, 0 ] ] if state.x < 3 and isOpen( hash.charAt( 3 ) )
  return moves

while queue.length > 0
  state = queue.shift()
  moves = computeNextMoves( state )
#  console.log "moves #{JSON.stringify(moves.length)}"
#  console.log "state #{JSON.stringify(state)}, moves #{JSON.stringify(moves.length)}"
  for move in moves
    nextState = _.cloneDeep state
    nextState.path += move[0]
    newX = nextState.x + move[1][0]
    newY = nextState.y + move[1][1]
    
    if newX == 3 and newY == 3
      if !longest? or nextState.path.length > longest.length
        longest = nextState.path
    else
      nextState.x = newX
      nextState.y = newY
      
      queue.push nextState
    
console.log "#{longest}: #{longest.length}"