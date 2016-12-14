md5 = require( 'js-md5' );

salt = "ngcjuoqr"
#salt = "abc"

stretchMd5 = ( d )->
  for x in [0..2016]
    d = md5( d )
  return d

x = 0

res = []
hashes = {}

hasNextHash = ( x, char )->
  for y in [(x + 1)..(x + 1001)]
    hash = hashes[salt + y] = if hashes[salt + y]? then hashes[salt + y] else stretchMd5( salt + y )
    if hash.includes( char + char + char + char + char )
      res.push( hash )
      console.log "Found in next 1000 #{hash}. #{res.length}, #{x}"
      return true

while res.length < 64
  hash = if hashes[salt + x]? then hashes[salt + x] else stretchMd5( salt + x )
  for i in [0..(hash.length - 3)]
    if hash.charAt( i ) == hash.charAt( i + 1 ) and hash.charAt( i + 1 ) == hash.charAt( i + 2 )
      hasNextHash( x, hash.charAt( i ) )
      break;

  x++
