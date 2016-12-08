data = require("./day7_data")

isTLS = ( d ) ->
  inHypernet = false
  for x in [0..d.length-1]
    inHypernet = true if d.charAt(x) == "["
    inHypernet = false if d.charAt(x) == "]"
    
    if !inHypernet and d.charAt(x) == d.charAt(x+2) and d.charAt(x) != '[' and d.charAt(x+1) != '[' and d.charAt(x) != ']' and d.charAt(x+1) != ']'
      regex = "\\[[a-z]*(#{d.charAt(x+1)}#{d.charAt(x)}#{d.charAt(x+1)})[a-z]*\\]"
      return true if d.search(new RegExp(regex)) >= 0

  return false
    
count = 0
for d in data
  count++ if isTLS(d) 

console.log count