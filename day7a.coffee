data = require("./day7_data")

isTLS = ( d ) ->
  foundADDA = false
  inHypernet = false
  for x in [0..d.length-1]
    inHypernet = true if d.charAt(x) == "["
    inHypernet = false if d.charAt(x) == "]"
    if d.charAt(x) == d.charAt(x+3) and d.charAt(x+1)==d.charAt(x+2) and d.charAt(x) != d.charAt(x+1)
      return false if inHypernet
      foundADDA = true
      
  return foundADDA
    
count = 0
for d in data
  count++ if isTLS(d)
  
console.log count