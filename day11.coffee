_ = require( 'lodash' )
assert = require( 'assert' )

isValidGlobalState = ( state ) ->
  for level in [0..3]
    return false unless isValidLevelState( state.levels[level] )
  return true

hasGenerator = ( contents ) ->
  return _.some contents, {type: 'G'}

isValidLevelState = ( contents ) ->
  # No generator, no problem
  return true unless hasGenerator( contents )

  for content in contents
    return false if content.type == 'M' and !chipHasMatchingGenerator( content.element, contents )

  return true

chipHasMatchingGenerator = ( chipElement, levelContent ) ->
  return _.find levelContent, {element: chipElement, type: 'G'}

isGoalState = ( state ) ->
  return state.elevator.level == 3 and state.elevator.levels[3].length = 10

generateElevatorLoads = ( levelContents ) ->
  loads = []
  if levelContents.length > 0
    for x in [0..levelContents.length - 1]
      for y in [x..levelContents.length - 1]
        loads.push( _.uniq [ levelContents[x], levelContents[y] ] )
  return loads



#The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
#The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
#The third floor contains a thulium-compatible microchip.
#The fourth floor contains nothing relevant.
initialState =
  elevator: 0
  levels: [
    [ {element: 'S', type: 'G'}, {element: 'S', type: 'M'}, {element: 'P', type: 'G'}, {element: 'P', type: 'M'} ]
    [ {element: 'T', type: 'G'}, {element: 'R', type: 'G'}, {element: 'R', type: 'M'}, {element: 'C', type: 'G'},
      {element: 'C', type: 'M'} ]
    [ {element: 'T', type: 'M'} ]
    []
  ]
  steps: []

for x in [0..3]
  initialState.levels[x] = _.orderBy( initialState.levels[x], [ 'element', 'type' ] )

printState = ( state ) ->
  for x in [3..0]
    process.stdout.write if state.elevator == x then "--> " else "    "
    for i in state.levels[x]
      process.stdout.write if i.type == 'G' then "+" else "-"
      process.stdout.write i.element.toUpperCase().charAt( 0 ) + " "
    console.log ""

queue = []
history = []

tryState = ( state ) ->
  history.push {
    elevator: state.elevator
    levels: state.levels
  }

#  printState state

  if isGoalState( state )
    console.log "Found: #{JSON.stringify( state, null, '  ' )}"
    process.exit()

  # Generate all next states
  applyLoads = ( load, levelDelta ) ->
    # Clone the structure to keep the old one on the stack
    nextState = _.cloneDeep state
    nextState.steps.push state

    # Remove items from current level
    _.pullAllWith nextState.levels[state.elevator], load, _.isEqual

    # Change level
    nextState.elevator += levelDelta

    # Push items to new level
    nextState.levels[nextState.elevator].push( l ) for l in load

    # Sort for easy compare of states
    nextState.levels[nextState.elevator] = _.orderBy( nextState.levels[nextState.elevator], [ 'element', 'type' ] )

    # Don't keep invalid state
    return unless isValidGlobalState( nextState )

    # Don't push a state already tried, we don't want to go back
    return if _.some history, ( i ) -> _.isEqual( i.levels, nextState.levels ) and i.elevator == nextState.elevator

    # Don't push a state already queued
    return if _.some queue, ( i ) -> _.isEqual( i.levels, nextState.levels ) and i.elevator == nextState.elevator

    # Try this state
    queue.push nextState

  loads = generateElevatorLoads( state.levels[state.elevator] )
  for load in loads
    # Go up
    applyLoads( load, 1 ) if state.elevator < 3

    # Go down
    applyLoads( load, -1 ) if state.elevator > 0


tests = ->
  assert chipHasMatchingGenerator( 'E', [ {element: 'E', type: 'G'} ] )
  assert !chipHasMatchingGenerator( 'E', [ {element: 'E', type: 'M'} ] )
  assert !chipHasMatchingGenerator( 'E', [ {element: 'F', type: 'G'} ] )

  assert hasGenerator( [ {element: 'F', type: 'G'} ] )
  assert !hasGenerator( [ {element: 'F', type: 'M'} ] )

  assert isValidLevelState( [ {element: 'F', type: 'G'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'M'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'G'}, {element: 'F', type: 'M'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'G'}, {element: 'F', type: 'M'}, {element: 'H', type: 'G'}, {element: 'H', type: 'M'} ] )
  assert !isValidLevelState( [ {element: 'H', type: 'G'}, {element: 'F', type: 'M'} ] )

  assert.deepEqual generateElevatorLoads( [ {element: 'A', type: 'G'} ] ), [
    [ {element: 'A', type: 'G'} ]
  ]

  assert.deepEqual generateElevatorLoads( [ {element: 'A', type: 'G'}, {element: 'B', type: 'G'}, {element: 'C', type: 'G'} ] ), [
    [ {element: 'A', type: 'G'} ]
    [ {element: 'A', type: 'G'}, {element: 'B', type: 'G'} ]
    [ {element: 'A', type: 'G'}, {element: 'C', type: 'G'} ]
    [ {element: 'B', type: 'G'} ]
    [ {element: 'B', type: 'G'}, {element: 'C', type: 'G'} ]
    [ {element: 'C', type: 'G'} ]
  ]

tests()

queue.push initialState
while queue.length != 0
  state = queue.shift()
  console.log "depth = #{state.steps.length}. #{history.length} done, #{queue.length} queued"
  tryState( state )