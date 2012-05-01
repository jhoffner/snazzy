#jQuery.ajaxSettings.traditional = true

# send the csrf token along with every jquery request
$(document).ajaxSend (e, xhr, options) ->
  token = $("meta[name='csrf-token']").attr("content")
  xhr.setRequestHeader "X-CSRF-Token", token

#### API Extensions:

jQuery.debug = (msg) ->
  window.console.debug msg if window.console

jQuery.delegate = (selector, eventType, eventData, handler) ->
  $(document).delegate selector, eventType, eventData, handler
  this

jQuery.fn.getVar = (varName, childOnly) ->
  varSelector = "var"
  varSelector += "[title=" + varName + "]"  if varName
  varEl = $((if childOnly then ">" else "") + varSelector, this).first()
  text = varEl.text()
  return null unless text
  return text if varEl.is(".string")
  jsonStr = "{\"value\":" + text + "}"
  json = $.parseJSON(jsonStr)
  json.value

jQuery.fn.getVars = (varName, childOnly) ->
  vars = []
  i = 0
  l = @length

  while i < l
    data = @eq(i).getVar(varName, childOnly)
    vars.push data  if data
    i++
  vars

jQuery.fn.setVar = (varName, json) ->
  $("var[title=" + varName + "]", this).html $.toJSON(json)
  this

jQuery.fn.identify = (prefix) ->
  i = 0
  prefix = prefix or "anon"
  @each ->
    return  if $(this).attr("id")
    loop
      i++
      id = prefix + "_" + i
      break unless $("#" + id).length > 0

    $(this).attr "id", id

jQuery.fn.disableSelection = ->
  @each ->
    $(this)
      .attr("unselectable", "on")
      .css
        "-moz-user-select": "none"
        "-webkit-user-select": "none"
        "user-select": "none"
      .each ->
        @onselectstart = ->
          false
