process.stdout._handle.setBlocking( true )

commands = [
  "cpy a b"
  "dec b"
  "cpy a d"
  "cpy 0 a"
  "cpy b c"

#  "inc a"
#  "dec c"
#  "jnz c -2"
#  "dec d"
#  "jnz d -5"
  "mul c d a"  # New: a+= c * d
  "noop"
  "noop"
  "noop"
  "noop"

  "dec b"
  "cpy b c"
  "cpy c d"
  "dec d"
  "inc c"
  "jnz d -2"
  "tgl c"
  "cpy -16 c"
  "jnz 1 c"
  "cpy 79 c"
  "jnz 74 d"
  "inc a"
  "inc d"
  "jnz d -2"
  "inc c"
  "jnz c -5"
].map ( c )->
  c.split( ' ' )

# Part B
registers = {
  a: 12
  b: 0
  c: 0
  d: 0
}

getValue = ( param ) ->
  return if Number.isInteger( parseInt( param ) ) then parseInt( param ) else registers[param]

x = 0
while x < commands.length
  command = commands[x]
  console.log "Running (#{x}) #{command} #{JSON.stringify( registers )}"
  if command[0] == 'cpy'
    unless Number.isInteger( parseInt( command[2] ) )
      registers[command[2]] = getValue( command[1] )
    x++
    
  else if command[0] == 'inc'
    unless Number.isInteger( parseInt( command[1] ) )
      registers[command[1]]++
    x++
    
  else if command[0] == 'dec'
    unless Number.isInteger( parseInt( command[1] ) )
      registers[command[1]]--
    x++
    
  else if command[0] == 'jnz'
    val = getValue( command[1] )
    if val != 0
      x += getValue( command[2] )
    else
      x++
      
  else if command[0] == 'tgl'
    affectedCommandNo = x + getValue( command[1] )
    if affectedCommandNo < commands.length
      affectedCommand = commands[affectedCommandNo]
      if affectedCommand[0] == 'noop'
        console.log "Trying to affect optimized code: instr #{affectedCommandNo}"
        process.exit()
      else if affectedCommand.length == 2
        if affectedCommand[0] == 'inc'
          affectedCommand[0] = 'dec'
        else
          affectedCommand[0] = 'inc'
      else if affectedCommand.length == 3
        if affectedCommand[0] == 'jnz'
          affectedCommand[0] = 'cpy'
        else
          affectedCommand[0] = 'jnz'
      console.log "Toggled #{affectedCommandNo} to #{affectedCommand}"
    x++
    
  else if command[0] == 'mul'
    registers[command[3]] += getValue( command[1] ) * getValue( command[2] )
    x++
  else if command[0] == 'noop'
    x++
#  process.stdout.write ""+x

#  console.log commands
#  console.log "#{JSON.stringify( registers )}"

console.log "#{JSON.stringify( registers, null, '  ' )}"


