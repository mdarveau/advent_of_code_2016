commands = [
  "cpy 1 a"
  "cpy 1 b"
  "cpy 26 d"
  "jnz c 2"
  "jnz 1 5"
  "cpy 7 c"
  "inc d"
  "dec c"
  "jnz c -2"
  "cpy a c"
  "inc a"
  "dec b"
  "jnz b -2"
  "cpy c b"
  "dec d"
  "jnz d -6"
  "cpy 14 c"
  "cpy 14 d"
  "inc a"
  "dec d"
  "jnz d -2"
  "dec c"
  "jnz c -5"
]

# Part A
registers = {
  a:0
  b:0
  c:0
  d:0
}

# Part B
registers = {
  a:0
  b:0
  c:1
  d:0
}

x=0
while x < commands.length
  command = commands[x].split(' ')
  if command[0] == 'cpy'
    registers[command[2]] = (if Number.isInteger(parseInt(command[1])) then parseInt(command[1]) else registers[command[1]])
    x++
  else if command[0] == 'inc'
    registers[command[1]]++
    x++
  else if command[0] == 'dec'
    registers[command[1]]--
    x++
  else if command[0] == 'jnz'
    val = if Number.isInteger(command[1]) then parseInt(command[1]) else registers[command[1]]
    if val != 0
      x += parseInt(command[2])
    else
      x++
      
console.log "#{JSON.stringify(registers, null, '  ')}"