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