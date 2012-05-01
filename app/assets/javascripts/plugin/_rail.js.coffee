# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in plugin.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$removeImg = null 
pageData = null
source = null

gotoUrl = (relativeUrl) ->
  port = if window.location.port is 80 then '' else ":#{window.location.port}"
  top.location.href = "http://#{window.location.hostname}#{port}#{relativeUrl}"

getPageData = ->
  pageData ||= $.parseJSON $("#pageInfo").html()

getActiveRoomId = ->
  'room_' + getPageData().activeRoomSlug

getActiveRoomEl = ->
  $('#' + getActiveRoomId())

getActiveRoomInfo = ->
  getActiveRoomEl().getVar 'roomInfo'

getActiveRoomBasePostUrl = (itemId = '') ->
  info = getActiveRoomInfo()
  "/#{info.username}/#{info.slug}/#{itemId}"

addItem = (data) ->
  $li = $("<li><a target=\"_parent\" href=\"#{data.url}\"><img src=\"#{data.image.url}\" /></a></li>")
  getActiveRoomEl().find("ul").prepend $li
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

postMsg = (msg) ->
  source.postMessage(JSON.stringify(msg), '*');

handleMessage = (e) ->
  source = e.source
  
  switch e.data
    when "setsource"
      postMsg eventName: "sourceset"

    when "dragenter"
      handleDragEnter e

    when "dragleave"
      handleDragLeave e

    when "askroomid"
      pageData = getPageData()
      data =
        eventName: "roomid"
        roomId: $("#dressing_rooms_names").val()

      postMsg data

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

handleDropdownSelect = (e) ->
  $el = $(@)
  activateRoom $el.find('a').html(), $el.getVar()

handleNewRoomAction = ->


handleViewRoomAction = ->
  info = getActiveRoomInfo()
  gotoUrl "/#{info.username}/#{info.slug}"

handleAddPageAction = ->
  postMsg eventName: "add_current_page"

activateRoom = (label, slug) ->
  getPageData().activeRoomSlug = slug
  $("#dressing_room_items .photo-container").hide()
  $("#" + getActiveRoomId()).show()
  info = getActiveRoomInfo();

  $("#dressing_rooms_names a.dropdown-toggle span").html(label)
  $.post("/api/recent_room/#{info._id}/")
  refreshLayout()


App.Plugin.initRail = ->
  # setup event listeners
  window.addEventListener "message", handleMessage, false
  $("#dressing_room_items").mouseleave(handleMouseLeave)
  $(window).bind "dragstart", handleDragStart
  $.delegate "#dressing_rooms_names ul.dropdown-menu li", 'click', handleDropdownSelect


  $("#new_room_action").click handleNewRoomAction
  $("#view_room_action").click handleViewRoomAction
  $('#add_page').click handleAddPageAction

  setTimeout refreshLayout, 500







