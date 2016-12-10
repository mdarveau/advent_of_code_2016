data = require("./day8_data")

screen = []
for [1..6]
  line = []
  line.push(false) for [1..50]
  screen.push(line) 

rect = ( width, height ) ->
  for x in [0..width-1]
    for y in [0..height-1]
      screen[y][x] = true

pushRow = ( y, nb ) ->
  screen[y].unshift(screen[y].pop()) for [1..nb]
  
pushColumn = ( x, nb ) ->
  for [1..nb]
    pop = screen[5][x]
    for y in [5..1]
      screen[y][x] = screen[y-1][x]  
    screen[0][x] = pop

printScreen = ( screen ) ->
  for line in screen
    for column in line
      process.stdout.write(if column then '*' else ' ');
    console.log ""
    
#rect(12, 3)      
#pushRow(0, 2)
#pushColumn(2, 2)
#printScreen( screen )

for d in data
  if d.command == 'rect'
    rect( d.rect.x, d.rect.y )
  else if d.command == 'rotate_column'
    pushColumn( d.no, d.distance )
  else if d.command == 'rotate_row'
    pushRow( d.no, d.distance )
    
  console.log "After #{JSON.stringify(d, null, '  ')}:"
  printScreen( screen )
  
count = 0
for line in screen
  for column in line
    count++ if column
    
console.log count