commands = [
  "cpy a d"
  "cpy 4 c"
  "cpy 643 b"
#  "inc d"
#  "dec b"
#  "jnz b -2"
#  "dec c"
#  "jnz c -5"
  "mul b c d"  # New: d+= b * c
  "noop"
  "noop"
  "noop"
  "noop"
  "cpy d a"
  "jnz 0 0"
  "cpy a b"
  "cpy 0 a"
  "cpy 2 c"
  "jnz b 2"
  "jnz 1 6"
  "dec b"
  "dec c"
  "jnz c -4"
  "inc a"
  "jnz 1 -7"
  "cpy 2 b"
  "jnz c 2"
  "jnz 1 4"
  "dec b"
  "dec c"
  "jnz 1 -4"
  "jnz 0 0"
  "out b"
  "jnz a -19"
  "jnz 1 -21"
].map ( c )->
  c.split( ' ' )



getValue = ( registers, param ) ->
  return if Number.isInteger( parseInt( param ) ) then parseInt( param ) else registers[param]

output = ""
    
run = ( registers ) ->
  x = 0
  while x < commands.length
    command = commands[x]
#    console.log "Running (#{x}) #{command} #{JSON.stringify( registers )}"
    if command[0] == 'cpy'
      unless Number.isInteger( parseInt( command[2] ) )
        registers[command[2]] = getValue( registers, command[1] )
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
      val = getValue( registers, command[1] )
      if val != 0
        x += getValue( registers, command[2] )
      else
        x++
        
    else if command[0] == 'tgl'
      affectedCommandNo = x + getValue( registers, command[1] )
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
      registers[command[3]] += getValue( registers, command[1] ) * getValue( registers, command[2] )
      x++
    else if command[0] == 'noop'
      x++
    else if command[0] == 'out'
      output += getValue( registers, command[1] )
      for x in [0...output.length]
        return false if output.charAt(x) != (if x % 2 == 0 then '0' else '1')

      x++
      
  return true
  #  process.stdout.write ""+x
  
  #  console.log commands
  #  console.log "#{JSON.stringify( registers )}"

process.stdout._handle.setBlocking( true )

value = 0

while true
  console.log value
  if run(
      a: value
      b: 0
      c: 0
      d: 0
    )
    console.log "#{value} works!"
    process.exit()
  value++

console.log "#{JSON.stringify( registers, null, '  ' )}"


