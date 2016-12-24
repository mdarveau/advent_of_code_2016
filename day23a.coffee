commands = [
  "cpy a b"
  "dec b"
  "cpy a d"
  "cpy 0 a"
  "cpy b c"
  "inc a"
  "dec c"
  "jnz c -2"
  "dec d"
  "jnz d -5"
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
#  "cpy 2 a"
#  "tgl a"
#  "tgl a"
#  "tgl a"
#  "cpy 1 a"
#  "dec a"
#  "dec a"
].map ( c )->
  c.split( ' ' )

# Part A
registers = {
  a: 7
  b: 0
  c: 0
  d: 0
}

## Part B
#registers = {
#  a: 12
#  b: 0
#  c: 0
#  d: 0
#}

x = 0
while x < commands.length
  command = commands[x]
#  console.log "Running #{command} (#{x})"
  if command[0] == 'cpy'
    unless Number.isInteger( parseInt( command[2] ) )
      registers[command[2]] = (if Number.isInteger( parseInt( command[1] ) ) then parseInt( command[1] ) else registers[command[1]])
#    else
#      console.log "Skipping cpy: #{command}"
    x++
  else if command[0] == 'inc'
    unless Number.isInteger( parseInt( command[1] ) )
      registers[command[1]]++
#    else
#      console.log "Skipping inc: #{command}"
    x++
  else if command[0] == 'dec'
    unless Number.isInteger( parseInt( command[1] ) )
      registers[command[1]]--
#    else
#      console.log "Skipping dec: #{command}"
    x++
  else if command[0] == 'jnz'
    val = if Number.isInteger( command[1] ) then parseInt( command[1] ) else registers[command[1]]
    if val != 0
      x += (if Number.isInteger( parseInt( command[2] ) ) then parseInt( command[2] ) else registers[command[2]] )
#      console.log "jnz, new x=#{x}"
    else
      x++
  else if command[0] == 'tgl'
    affectedCommandNo = x + if Number.isInteger( command[1] ) then parseInt( command[1] ) else registers[command[1]]
    if affectedCommandNo < commands.length
      affectedCommand = commands[affectedCommandNo]
      if affectedCommand.length == 2
        if affectedCommand[0] == 'inc'
          affectedCommand[0] = 'dec'
        else
          affectedCommand[0] = 'inc'
      else if affectedCommand.length == 3
        if affectedCommand[0] == 'jnz'
          affectedCommand[0] = 'cpy'
        else
          affectedCommand[0] = 'jnz'
#    else
#      console.log "Toggle out of scope with #{affectedCommandNo}."
    x++
  process.stdout.write ""+x
    
#  console.log commands
#  console.log "#{JSON.stringify( registers, null, '  ' )}"

console.log "#{JSON.stringify( registers, null, '  ' )}"