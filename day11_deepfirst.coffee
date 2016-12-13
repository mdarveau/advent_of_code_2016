_ = require( 'lodash' )
assert = require( 'assert' )

isValidGlobalState = ( state ) ->
  for level in [0..3]
    return false unless isValidLevelState( state.levels[level] )
  return true

hasGenerator = ( contents ) ->
  return _.some contents, {type: 'generator'}

isValidLevelState = ( contents ) ->
  # No generator, no problem
  return true unless hasGenerator( contents )

  for content in contents
    return false if content.type == 'microchip' and !chipHasMatchingGenerator( content.element, contents )

  return true

chipHasMatchingGenerator = ( chipElement, levelContent ) ->
  return _.find levelContent, {element: chipElement, type: 'generator'}

isGoalState = ( state ) ->
  return state.elevator == 3 and state.levels[3].length == 10

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
    [ {element: 'strontium', type: 'generator'}, {element: 'strontium', type: 'microchip'}, {element: 'plutonium', type: 'generator'}, {element: 'plutonium', type: 'microchip'} ]
    [ {element: 'thulium', type: 'generator'}, {element: 'ruthenium', type: 'generator'}, {element: 'ruthenium', type: 'microchip'}, {element: 'curium', type: 'generator'}, {element: 'curium', type: 'microchip'} ]
    [ {element: 'thulium', type: 'microchip'} ]
    []
  ]
  
#The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
#The second floor contains a hydrogen generator.
#The third floor contains a lithium generator.
#The fourth floor contains nothing relevant.
#initialState =
#  elevator: 0
#  levels: [
#    [ {element: 'hydrogen', type: 'microchip'}, {element: 'lithium', type: 'microchip'} ]
#    [ {element: 'hydrogen', type: 'generator'} ]
#    [ {element: 'lithium', type: 'generator'} ]
#    []
#  ]  

for x in [0..3]
  initialState.levels[x] = _.orderBy( initialState.levels[x], [ 'element', 'type' ] )
  
printState = ( state ) ->
  for x in [3..0]
    process.stdout.write "->" if state.elevator == x
    process.stdout.write x + ":["
    for i in state.levels[x]
      process.stdout.write if i.type == 'generator' then "+" else "-"
      process.stdout.write i.element.toUpperCase().charAt(0) + " "
    process.stdout.write "]  "
  console.log ""
  
stateStack = []
history = []

pushState = ( state ) ->
  # Don't keep invalid state
  return unless isValidGlobalState( state )

  # Don't push a state already on the stack
  return if _.some stateStack, ( i ) -> _.isEqual i, state

  # Don't push a state already tried, we don't want to go back
  return if _.some history, ( i ) -> _.isEqual( i.levels, state.levels ) and i.elevator == state.elevator
  
  return if stateStack.length > 64
    
  history.push {
    elevator: state.elevator
    levels: state.levels
  }
  
  console.log "History: #{history.length}"
  
  stateStack.push( state )
#  console.log "#{stateStack.length} items on the stack"
#  printState state

  if isGoalState( state )
    console.log "Found: in #{stateStack.length} steps"
#    for step in stateStack
#      printState step
#    process.exit()

  loads = generateElevatorLoads( state.levels[state.elevator] )
  for load in loads
    # Generate all next states
    applyLoads = ( levelDelta ) ->
      # Clone the structure to keep the old one on the stack
      nextState = _.cloneDeep state
      
      # Remove items from current level
      _.pullAllWith nextState.levels[state.elevator], load, _.isEqual
      
      # Change level
      nextState.elevator += levelDelta
      
      # Push items to new level
      nextState.levels[nextState.elevator].push( l ) for l in load
      
      # Sort for easy compare of states
      nextState.levels[nextState.elevator] = _.orderBy( nextState.levels[nextState.elevator], [ 'element', 'type' ] )
      
      # Try this state
      pushState( nextState )

    # Go up
    applyLoads( 1 ) if state.elevator < 3
    
    # Go down
    applyLoads( -1 ) if state.elevator > 0


  stateStack.pop()

tests = ->
  assert chipHasMatchingGenerator( 'E', [ {element: 'E', type: 'generator'} ] )
  assert !chipHasMatchingGenerator( 'E', [ {element: 'E', type: 'microchip'} ] )
  assert !chipHasMatchingGenerator( 'E', [ {element: 'F', type: 'generator'} ] )

  assert hasGenerator( [ {element: 'F', type: 'generator'} ] )
  assert !hasGenerator( [ {element: 'F', type: 'microchip'} ] )

  assert isValidLevelState( [ {element: 'F', type: 'generator'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'microchip'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'generator'}, {element: 'F', type: 'microchip'} ] )
  assert isValidLevelState( [ {element: 'F', type: 'generator'}, {element: 'F', type: 'microchip'}, {element: 'H', type: 'generator'}, {element: 'H', type: 'microchip'} ] )
  assert !isValidLevelState( [ {element: 'H', type: 'generator'}, {element: 'F', type: 'microchip'} ] )

  assert.deepEqual generateElevatorLoads( [ {element: 'A', type: 'generator'} ] ), [
    [ {element: 'A', type: 'generator'} ]
  ]

  assert.deepEqual generateElevatorLoads( [ {element: 'A', type: 'generator'}, {element: 'B', type: 'generator'}, {element: 'C', type: 'generator'} ] ), [
    [ {element: 'A', type: 'generator'} ]
    [ {element: 'A', type: 'generator'}, {element: 'B', type: 'generator'} ]
    [ {element: 'A', type: 'generator'}, {element: 'C', type: 'generator'} ]
    [ {element: 'B', type: 'generator'} ]
    [ {element: 'B', type: 'generator'}, {element: 'C', type: 'generator'} ]
    [ {element: 'C', type: 'generator'} ]
  ]

tests()

pushState( initialState )