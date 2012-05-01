_.templateSettings = interpolate: /#\{(.+?)\}/g
_.startsWith = (str, pattern) ->
  return false  unless str
  str.indexOf(pattern) is 0

_.endsWith = (str, pattern) ->
  return false  unless str
  d = str.length - pattern.length
  d >= 0 and str.indexOf(pattern, d) is d