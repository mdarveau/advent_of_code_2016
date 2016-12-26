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
  _.reduce( state.checkpoints, ( sum, n ) -> sum + (if n then 1 else 0) )

computeNextMoves = ( grid, state ) ->
  moves = []
  moves.push [ 0, -1 ] if grid[state.position.y - 1][state.position.x] != '#'
  moves.push [ 0, 1 ] if grid[state.position.y + 1][state.position.x] != '#'
  moves.push [ -1, 0 ] if grid[state.position.y][state.position.x - 1] != '#'
  moves.push [ 1, 0 ] if grid[state.position.y][state.position.x + 1] != '#'
  return moves

findShortestDistance = ( from, to ) ->
  processed = []
  queue = []

  initialState = {
    position: from
    moves: 0
  }

  queue.push initialState

  while queue.length > 0
    state = queue.shift()

    if processed.length % 500 == 0
      console.log "processed #{processed.length}, queue is now #{queue.length} long"

    moves = computeNextMoves( grid, state )
    for move in moves
      nextState = _.cloneDeep state
      nextState.moves++
      nextState.position.x += move[0]
      nextState.position.y += move[1]

      if nextState.position.x == to.x and nextState.position.y == to.y
        console.log "Found solution in #{nextState.moves} moves!!!"
        return nextState.moves
      else
        unless _.some( processed, ( state )-> _.isEqual( state.position, nextState.position ) )
          queue.push nextState
          processed.push nextState

findDistances = ->
  distances = new Array( 8 )
  for x in [0...distances.length]
    distances[x] = new Array( 8 )

  for x in [0...distances.length]
    for y in [0...7]
      continue if x == y or distances[x][y]?
      console.log "Searching from #{x} to #{y}"
      distances[x][y] = distances[y][x] = findShortestDistance( findNumberInGrid( grid, x ), findNumberInGrid( grid, y ) )
      console.log "#{x} to #{y} = #{distances[x][y]}"

  console.log "distances: #{JSON.stringify( distances, null, '  ' )}"
  return distances

distances = [
  [ null, 28, 310, 304, 88, 314, 70, 292 ],
  [ 28, null, 310, 304, 104, 314, 78, 292 ],
  [ 310, 310, null, 34, 258, 68, 272, 38 ],
  [ 304, 304, 34, null, 252, 54, 266, 20 ],
  [ 88, 104, 258, 252, null, 262, 38, 240 ],
  [ 314, 314, 68, 54, 262, null, 276, 42 ],
  [ 70, 78, 272, 266, 38, 276, null, 254 ],
  [ 292, 292, 38, 20, 240, 42, 254, null ]
]

distances = findDistances() unless distances?

permutator = ( inputArr ) ->
  results = []

  permute = ( arr, memo ) ->
    `var memo`
    cur = undefined
    memo = memo or []
    i = 0
    while i < arr.length
      cur = arr.splice( i, 1 )
      if arr.length == 0
        results.push memo.concat( cur )
      permute arr.slice(), memo.concat( cur )
      arr.splice i, 0, cur[0]
      i++
    results

  permute inputArr

partB = true
  
shortestDistance = Number.MAX_SAFE_INTEGER
for p in permutator([1, 2, 3, 4, 5, 6, 7])
  lastPoint = 0
  distance = 0
  for checkpoint in p
    distance += distances[lastPoint][checkpoint]
    lastPoint = checkpoint

  if partB
    distance += distances[lastPoint][0]
  if distance < shortestDistance
    shortestDistance = distance
  
console.log "Shortest distance: #{shortestDistance}"