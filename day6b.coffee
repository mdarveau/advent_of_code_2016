data = require("./day6_data")
_ = require('lodash')

for x in [0..7]
  charsMap = {}
  for d in data
    chr = d.charAt(x)
    charsMap[chr] = (charsMap[chr] ? 0) + 1

  chars = []
  for char, count of charsMap
    chars.push {
      char: char
      count: count
    }

  chars = _.orderBy( chars, ['count'], ['desc'])
  console.log chars[chars.length-1].char
    

  
#convertData = ( data ) ->
#  res = {
#    name: /^(.*)-\d*\[.*\]$/.exec( data )[1].replace( /-/g, "" )
#    id: /-(\d*)\[.*\]$/.exec( data )[1]
#    checksum: /\[(.*)\]$/.exec( data )[1]
#  }
#  charsMap = {}
#  for x in [0..res.name.length - 1]
#    chr = res.name.charAt(x)
#    charsMap[chr] = (charsMap[chr] ? 0) + 1
#
#  chars = []
#  for char, count of charsMap
#    chars.push {
#      char: char
#      charValue: char.charCodeAt(0)
#      count: count
#    }
#
#  chars = _.orderBy( chars, ['count', 'charValue'], ['desc', 'asc'])
#  chk = ''
#  chk += char.char for char in chars[0..4]
#
#  console.log "Room #{res.name} got #{chk} expected #{res.checksum}"
#
#  res.validChecksum = chk == res.checksum
#  return res
#
#data = data.map convertData
#
#code = 0
#
#for room in data
#  console.log "Room #{room.name} is #{if room.validChecksum then "valid" else "invalid"}"
#  code += parseInt(room.id) if room.validChecksum
#
#console.log code
