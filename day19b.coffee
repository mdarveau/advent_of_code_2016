computeBruteForce = ( size )->

  nb = new Array( size )

  for x in [0..nb.length - 1]
    nb[x] = true

  count = nb.length

  getIndex = ( start, count ) ->
    for n in [1..nb.length]
      i = (start + n) % nb.length
      count-- if nb[i]
      return i if count == 0

  printAll = ->
    for n in [0..nb.length - 1]
      process.stdout.write if nb[n] then '*' else '.'
    console.log ""

  x = 0
  while count != 1
    # Get opposite elf index
    opp = getIndex( x, Math.floor( count / 2 ) )
    nb[opp] = false
    count--

    # Get index of next elf still active
    x = getIndex( x, 1 )

    #    printAll()
    console.log "Remaining: #{count}" if (count % 1000) == 0

  for x in [0..nb.length - 1]
    return x + 1 if nb[x]

#p = 0
#for x in [1..1000]
#  c = computeBruteForce( x )
#  console.log x + " = " + c + if c - p > 0 then " +" + (c - p) else ""
#  p = c

# Reset to 1 from time to time
# ~First half +1 
# 29-54 (25) = +1
# ~Second half +1
# 55-81 (26) = +2

# 83-162 (79) = +1
# 163-243 (80) = +2



#for x in [1..1000]
#  console.log x if compute(x) == 1
# 1
# 2
# 4
# 10
# 28
# 82
# 244
# 730
#
# Conclusion:
# fn(1) = 1
# fn(2) = 2
# fn(n) = fn(n-1) * 3 - 2

step = ( s ) ->
  return 1 if s == 0
  return Math.pow( 3, s - 1 ) + 1

compute2 = ( size ) ->
  start = null
  s = 2
  while true
    end = step( s )
    if end > size
      start = step( s - 1 )
      break
    s++

  range = end - start
  plus1 = (range / 2) - 1

  delta = size - start

  return 1 + delta + Math.max( delta - plus1, 0 )

console.log compute2( 3017957 )
  