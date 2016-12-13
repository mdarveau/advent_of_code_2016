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
  return _.find( levelContent, {element: chipElement, type: 'G'} )?

isGoalState = ( state ) ->
  return state.elevator == 3 and state.levels[3].length == 14

generateElevatorLoads = ( levelContents ) ->
  loads = []
  # All pairs are equivalent
  pairAdded = false
  if levelContents.length > 0
    for x in [0..levelContents.length - 1]
      for y in [x..levelContents.length - 1]
        load = _.uniq [ levelContents[x], levelContents[y] ]
        isPair = load.length == 2 and load[0].type != load[1].type and load[0].element == load[1].element
        if !isPair or (isPair and !pairAdded)
          pairAdded = true if isPair
          loads.push( load )
        
  return loads

# Any pair on a level is equivalent
computeStateHash = ( state ) ->
  hash = "" + state.elevator
  for contents, level in state.levels
    hash += "|"
    pairs = 0
    for content in contents
      if _.find( contents, {element: content.element, type: if content.type == 'M' then 'G' else 'M'} )?
        pairs++
      else
        hash += "#{if content.type == 'G' then "+" else "-"}#{content.element}"
    hash += pairs / 2
  return hash


#The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
#The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
#The third floor contains a thulium-compatible microchip.
#The fourth floor contains nothing relevant.
#initialState =
#  elevator: 0
#  levels: [
#    [ {element: 'S', type: 'G'}, {element: 'S', type: 'M'}, {element: 'P', type: 'G'}, {element: 'P', type: 'M'} ]
#    [ {element: 'T', type: 'G'}, {element: 'R', type: 'G'}, {element: 'R', type: 'M'}, {element: 'C', type: 'G'}, {element: 'C', type: 'M'} ]
#    [ {element: 'T', type: 'M'} ]
#    []
#  ]
#  steps: []
#  steps_count: 0

initialState =
  elevator: 0
  levels: [
    [ {element: 'S', type: 'G'}, {element: 'S', type: 'M'}, {element: 'P', type: 'G'}, {element: 'P', type: 'M'}, {element: 'E', type: 'G'}, {element: 'E', type: 'M'}, {element: 'D', type: 'G'}, {element: 'D', type: 'M'} ]
    [ {element: 'T', type: 'G'}, {element: 'R', type: 'G'}, {element: 'R', type: 'M'}, {element: 'C', type: 'G'}, {element: 'C', type: 'M'} ]
    [ {element: 'T', type: 'M'} ]
    []
  ]
  steps: []
  steps_count: 0

#The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
#The second floor contains a hydrogen generator.
#The third floor contains a lithium generator.
#The fourth floor contains nothing relevant.
#initialState =
#  elevator: 0
#  levels: [
#    [ {element: 'hydrogen', type: 'M'}, {element: 'lithium', type: 'M'} ]
#    [ {element: 'hydrogen', type: 'G'} ]
#    [ {element: 'lithium', type: 'G'} ]
#    []
#  ]  
#  steps: []
#  steps_count: 0


for x in [0..3]
  initialState.levels[x] = _.orderBy( initialState.levels[x], [ 'element', 'type' ] )

initialState.hash = computeStateHash( initialState )

printState = ( state ) ->
  for x in [3..0]
    process.stdout.write "->" if state.elevator == x
    process.stdout.write x + ":["
    for i in state.levels[x]
      process.stdout.write if i.type == 'G' then "+" else "-"
      process.stdout.write i.element.toUpperCase().charAt( 0 ) + " "
    process.stdout.write "]  "
  console.log ""

queue = []
history = {}

tryState = ( state ) ->
  if isGoalState( state )
    console.log "Found: #{state.steps_count}"
    #    for step in state.steps
    #      printState step
    process.exit()

  # Generate all next states
  applyLoads = ( load, levelDelta ) ->
    # Clone the structure to keep the old one on the stack
    nextState = _.cloneDeep state
    #    nextState.steps.push state
    nextState.steps_count++

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
    hash = computeStateHash( nextState )
    return if history[hash]

    # Try this state
    history[hash] = true
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
  
  # Keep only one pair
  assert.deepEqual generateElevatorLoads( [ {element: 'A', type: 'G'}, {element: 'A', type: 'M'}, {element: 'B', type: 'G'}, {element: 'B', type: 'M'} ] ), [
    [ {element: 'A', type: 'G'} ]
    [ {element: 'A', type: 'G'}, {element: 'A', type: 'M'} ]
    [ {element: 'A', type: 'G'}, {element: 'B', type: 'G'} ]
    [ {element: 'A', type: 'G'}, {element: 'B', type: 'M'} ]
    [ {element: 'A', type: 'M'} ]
    [ {element: 'A', type: 'M'}, {element: 'B', type: 'G'} ]
    [ {element: 'A', type: 'M'}, {element: 'B', type: 'M'} ]
    [ {element: 'B', type: 'G'} ]
    [ {element: 'B', type: 'M'} ]
  ]

tests()

p = 0

queue.push initialState
while queue.length != 0
  state = queue.shift()
  p++
  console.log "depth = #{state.steps_count}. #{Object.keys(history).length} done, #{queue.length} queued" if p % 1000 == 0
  tryState( state )