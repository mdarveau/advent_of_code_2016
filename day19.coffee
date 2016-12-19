nb = new Array(3017957)

for x in [0..nb.length-1]
  nb[x] = (x+1) % nb.length

x = 0
while true
  nb[x] = nb[nb[x]]
  if x == nb[x]
    console.log x+1
    process.exit()
  x = nb[x]