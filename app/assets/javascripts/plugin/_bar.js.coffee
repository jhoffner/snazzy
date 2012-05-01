# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in plugin.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$removeImg = null

getPageData = ->
  $.parseJSON $("#pageInfo").html()

getActiveRoomId = ->
  'room_' + $("#dressing_rooms_names").val()

getActiveRoomEl = ->
  $('#' + getActiveRoomId())

getActiveRoomInfo = ->
  getActiveRoomEl().getVar 'roomInfo'

getActiveRoomBasePostUrl = (itemId = '') ->
  info = getActiveRoomInfo()
  "/#{info.username}/#{info.slug}/#{itemId}"

addItem = (data) ->
  $li = $("<li><a target=\"_parent\" href=\"#{data.url}\"><img src=\"#{data.image.url}\" /></a></li>")
  getActiveRoomEl().find("ul").append $li
  refreshLayout()
  $.post(
    getActiveRoomBasePostUrl() + 'item',
    item: data,
    (json) -> $li.remove() unless json.success,
    'json'
  )

removeItem = ($img) ->
  $li = $img.closest("li")

  $.ajax
    url: getActiveRoomBasePostUrl($li.getVar())
    type: 'DELETE'

  $li.remove()
  refreshLayout()

highlightZone = (active) ->
  $el = $("#dressing_room_items")
  if active
    $el.css
      boxShadow: "0 0 11px #FFF"
      backgroundColor: "#291D4F"
  else
    $el.css
      boxShadow: "none"
      backgroundColor: ""

refreshLayout = ->
  highlightZone false

  left = 0
  $('#dressing_room_items .photo-container:visible li').each (i, el) ->
    left += $(el).width()

  labelWidth = $("#drag_here").width();
  totalW = $("#dressing_room_items").width()
  left += ((totalW - left) / 2) - (labelWidth / 3) + 30
  if (totalW - left > labelWidth)
    $("#drag_here").show().css "left", left + "px"
  else
    $("#drag_here").hide()


handleMessage = (e) ->
  switch e.data
    when "dragenter"
      handleDragEnter e

    when "dragleave"
      handleDragLeave e

    when "askroomid"
      pageData = getPageData()
      data =
        eventName: "roomid"
        roomId: $("#dressing_rooms_names").val()

      e.source.postMessage JSON.stringify(data), "*"

    else
      data = $.parseJSON(e.data)
      handleDragLeave
      addItem data

handleDragStart = (e) ->
  $el = $(e.target)
  $removeImg = $el if $el.is("img") and $el.closest("#dressing_room_items").length is 1

handleDragEnter = (e) ->
  highlightZone true

handleDragLeave = (e) ->
  highlightZone false

handleMouseLeave = (e) ->
  if ($removeImg)
    removeItem($removeImg)
    $removeImg = null

handleChange = ->
  $("#dressing_room_items .photo-container").hide()
  $("#" + getActiveRoomId()).show()
  refreshLayout()


App.Plugin.initBar = ->
  # setup event listeners
  window.addEventListener "message", handleMessage, false
  $("#dressing_room_items").mouseleave(handleMouseLeave)
  $(window).bind "dragstart", handleDragStart
  $("#dressing_rooms_names").change(handleChange).change()
  setTimeout refreshLayout, 500







