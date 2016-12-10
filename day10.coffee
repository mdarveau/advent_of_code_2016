commands = require( "./day10_data" )

outputs = []
bots = []

give = ( from, to, to_no, value ) ->
  if to == 'bot'
    bots[to_no] = bots[to_no] ? {values: []}
    bots[to_no].values.push value
    dispatchValues( to_no, bots[to_no].values ) if bots[to_no].values.length == 2
  else if to == 'output'
    outputs[to_no] = value

dispatchValues = ( bot, values ) ->
  return unless bots[bot]?.instruction?
  bots[bot].values = []
  console.log "Bot #{bot} compared 17 and 61" if Math.min( values[0], values[1] ) == 17 and Math.max( values[0], values[1] ) == 61
  give( bot, bots[bot].instruction.low_to, bots[bot].instruction.low_to_no, Math.min( values[0], values[1] ) )
  give( bot, bots[bot].instruction.high_to, bots[bot].instruction.high_to_no, Math.max( values[0], values[1] ) )


for command in commands
  if command.command == 'value'
    give( "input", 'bot', command.bot, command.value )

  else if command.command == 'give'
    bots[command.bot] = bots[command.bot] ? {values: []}
    bots[command.bot].instruction = command
    dispatchValues( command.bot, bots[command.bot].values ) if bots[command.bot].values.length == 2

console.log "Outputs: #{outputs[0]*outputs[1]*outputs[2]}"