assert = require( 'assert' )
commands = require( "./day21_data" )

#commands = [
#  "swap position 4 with position 0"
#  "swap letter d with letter b"
#  "reverse positions 0 through 4"
#  "rotate left 1"
#  "move position 1 to position 4"
#  "move position 3 to position 0"
#  "rotate based on position of letter b"
#  "rotate based on position of letter d"
#]

buildSwapPosition = ( x, y )->
  return ( input ) ->
    i = Math.min( x, y )
    j = Math.max( x, y )
    return input.substring( 0, i ) + input.charAt( j ) + input.substring( i + 1, j ) + input.charAt( i ) + input.substring( j + 1 )

buildSwapLetter = ( letterReplaced, withLetter )->
  return ( input ) ->
    buildSwapPosition( input.indexOf( letterReplaced ), input.indexOf( withLetter ) )( input )

buildRotate = ( direction, steps )->
  return ( input ) ->
    s = if direction == 'right' then -steps else steps
    return input.slice( s % input.length ) + input.slice( 0, s % input.length )

buildRotateBased = ( letter )->
  return ( input ) ->
    index = input.indexOf( letter )
    steps = 1 + index + (if index >= 4 then 1 else 0)
    return buildRotate( 'right', steps )( input )

buildReversePosition = ( x, y )->
  return ( input ) ->
    i = Math.min( x, y )
    j = Math.max( x, y )
    return input.substring( 0, i ) + input.substring( i, j + 1 ).split( '' ).reverse().join( '' ) + input.substring( j + 1 )

buildMovePosition = ( x, y )->
  return ( input ) ->
    letter = input.charAt( x )
    input = input.substring( 0, x ) + input.substring( x + 1 )
    return input.substring( 0, y ) + letter + input.substring( y )

assert.equal buildSwapPosition( 2, 4 )( 'abcdef' ), 'abedcf'
assert.equal buildSwapPosition( 4, 2 )( 'abcdef' ), 'abedcf'
assert.equal buildSwapLetter( 'c', 'e' )( 'abcdef' ), 'abedcf'
assert.equal buildRotate( 'left', 3 )( '0123456789' ), '3456789012'
assert.equal buildRotate( 'right', 3 )( '0123456789' ), '7890123456'
assert.equal buildRotate( 'right', 11 )( '0123456789' ), '9012345678'
assert.equal buildRotateBased( '2', 3 )( '0123456789' ), '7890123456'
assert.equal buildRotateBased( '4', 3 )( '0123456789' ), '4567890123'
assert.equal buildRotateBased( '7', 3 )( '01234567' ), '70123456'
assert.equal buildReversePosition( 2, 5 )( '0123456789' ), '0154326789'
assert.equal buildReversePosition( 5, 2 )( '0123456789' ), '0154326789'
assert.equal buildMovePosition( 2, 7 )( '0123456789' ), '0134567289'
assert.equal buildMovePosition( 2, 0 )( '0123456789' ), '2013456789'

functions = commands.map ( data )->
  data = data.split( ' ' )
  if data[0] == 'swap' and data[1] == 'position'
    return buildSwapPosition( +data[2], +data[5] )

  else if data[0] == 'swap' and data[1] == 'letter'
    return buildSwapLetter( data[2], data[5] )

  else if data[0] == 'rotate' and data[1] == 'based'
    return buildRotateBased( data[6] )

  else if data[0] == 'rotate' and (data[1] == 'left' or data[1] == 'right')
    return buildRotate( data[1], data[2] )

  else if data[0] == 'reverse'
    return buildReversePosition( +data[2], +data[4] )

  else if data[0] == 'move'
    return buildMovePosition( +data[2], +data[5] )

  else
    console.log "ERROR: #{data}"


scramble = ( password )->
  for command, x in functions
    #  console.log "#{commands[x]}:"
    #  console.log "  01234567"
    #  console.log "  #{password}"
    password = command( password )
  #  console.log "  #{password }"
  return password

console.log scramble( 'abcdefgh' )


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


for password in permutator( "abcdefgh".split( '' ) )
  if scramble( password.join( '' ) ) == "fbgdceah"
    console.log password.join( '' )
  
