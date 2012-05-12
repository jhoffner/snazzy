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

getActiveRoomPath =  (routeName, itemId, activityId) ->
  info = getActiveRoomInfo()
  route_f = Routes[routeName + "_path"]
  if activityId
    route_f info.username, info.slug, itemId, activityId
  else if itemId
    route_f info.username, info.slug, itemId
  else
    route_f info.username, info.slug

addItem = (data) ->
  $li = $("<li><a target=\"_parent\" href=\"#{data.url}\"><img src=\"#{data.image.url}\" /></a></li>")
  getActiveRoomEl().find("ul").prepend $li
  refreshLayout()
  $.post(
    getActiveRoomPath("create_dressing_room_item")
    item: data
    (json) ->
      if json.success
        $li.append("<var>\"#{json.item_id}\"</var>")
      else
        $li.remove()
    'json'
  )

removeItem = ($img) ->
  $li = $img.closest("li")

  $.ajax
    url: getActiveRoomPath("delete_dressing_room_item", $li.getVar())
    type: 'DELETE'
    success: (json) ->
      if json.success
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

  #if getActiveRoomEl().find('li').length == 0


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
  $target = $(e.target)
  $img = if $target.is("img") then $target else $target.find("img")
  $removeImg = if $img.length > 0 and $img.closest("#dressing_room_items").length is 1 then $img else null

handleDragEnter = (e) ->
  highlightZone true

handleDragLeave = (e) ->
  highlightZone false

handleMouseLeave = (e) ->
  if ($removeImg)
    removeItem($removeImg)
    $removeImg = null

handleRoomSelect = (e) ->
  $("#dressing_room_items, #add_page_action").show()
  $("#dressing_room_new").hide();

  $el = $(@)
  activateRoom $el.find('a').html(), $el.getVar()

handleNewRoomAction = ->
  $("#dressing_room_items, #add_page_action").hide()
  $("#dressing_room_new").show();
  $('#dressing_room_label').val(''); #make sure to reset any value that the browser may have added

handleCreateRoomAction = ->
  label = $('#dressing_room_label').val();
  if label
    username = getPageData().username
    $.post "/#{username}/",
        "item[label]": label,
        set_recent: true
        (data) ->
          if data.success
            window.location.reload true
          else
            alert data.message

handleEmptyRoomAction = ->
  info = getActiveRoomInfo()
  if confirm "Are you sure you want to remove all of your items from #{info.label}?"
    $.put getActiveRoomPath("empty_dressing_room_items"), {}, (data) ->
      if data.success
        getActiveRoomEl().find('ul').html('')

handleDeleteRoomAction = ->
  $.ajax
    url: getActiveRoomPath("delete_dressing_room"),
    type: 'DELETE',
    success: (json) ->
      if json.success
        window.location.reload true

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
  $.put("/api/recent_room/#{info._id}/")
  refreshLayout()


App.Plugin.initRail = ->
  $ ->
    # setup event listeners
    window.addEventListener "message", handleMessage, false
    $("#dressing_room_items").mouseleave handleMouseLeave
    $(document.body).bind "dragstart", handleDragStart
    $.delegate "#dressing_rooms_names ul.dropdown-menu li.room", 'click', handleRoomSelect


    $("#new_room_action").click handleNewRoomAction
    $("#view_room_action").click handleViewRoomAction
    $('#empty_room_action').click handleEmptyRoomAction
    $('#delete_room_action').click handleDeleteRoomAction

    $('#add_page_action').click handleAddPageAction

    $('#dressing_room_create_action').click handleCreateRoomAction

    setTimeout refreshLayout, 500







