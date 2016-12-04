data = require("./day4_data")

convertData = ( data ) ->
  room = {
    encrypted_name: /^(.*)-\d*\[.*\]$/.exec( data )[1]
    id: /-(\d*)\[.*\]$/.exec( data )[1]
    checksum: /\[(.*)\]$/.exec( data )[1]
  }
  room.name = ''
  for x in [0..room.encrypted_name.length - 1]
    chrCode = room.encrypted_name.charCodeAt(x)
    room.name += String.fromCharCode(((chrCode-97+parseInt(room.id))%26)+97) unless room.encrypted_name.charAt(x) == '-'
    room.name += ' ' if room.encrypted_name.charAt(x) == '-'

  return room

data = data.map convertData

for room in data
  console.log "Room #{room.name} is #{room.id}"
