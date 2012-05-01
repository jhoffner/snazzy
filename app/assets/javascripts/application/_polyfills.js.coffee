
window.log = ->
  log.history = log.history or []
  log.history.push arguments
  if @console
    arguments.callee = arguments.callee.caller
    console.log Array::slice.call(arguments)

((b) ->
  c = ->
  d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(",")

  while a = d.pop()
    b[a] = b[a] or c
) window.console = window.console or {}

# JavaScript 1.8.5 support - add bind function if it isnt supported natively
unless Function::bind
  Function::bind = (oThis) ->
    throw new TypeError("Function.prototype.bind - what is trying to be fBound is not callable")  if typeof this isnt "function"
    aArgs = Array::slice.call(arguments, 1)
    fToBind = this
    fNOP = ->

    fBound = ->
      fToBind.apply (if this instanceof fNOP then this else oThis or window), aArgs.concat(Array::slice.call(arguments))

    fNOP:: = @::
    fBound:: = new fNOP()
    fBound