# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

App.DressingRooms.Tiles = can.Control
  init: (el, options) ->
    @element.show()

    @layoutTiles(0)
    setTimeout (=> @layoutTiles(0)), 1000

  '.actions-bar li.like click': (li) ->
    @vote li, 'like'

  '.actions-bar li.dislike click': (li) ->
    @vote li, 'dislike'

  '.actions-bar li.comment click': (li) ->
    @toggleComment li

  '.new_comment a.btn click': (btn) ->
    @submitComment btn

  '.new_comment textarea keypress': (el, e) ->
    @submitComment el if e.keyCode == 13

  submitComment: (el) ->
    helper = @actionHelper el
    path = helper.getPath 'create_dressing_room_item_comment'
    data = 'activity[message]': helper.$item.find('textarea').val()

    $.post path, data, (json) =>
      if json.success
        helper.reloadItem()
      else
        log json.message

  toggleComment: (li) ->
    li.closest('.tile').find('.activity.new_comment').slideToggle()
    setTimeout (=> @layoutTiles()), 500
    setTimeout (=> @layoutTiles()), 600

  actionHelper: (el) ->
    controller = @
    $item = el.closest '.room-item'

#      _getPath = (route_name, args...) ->
#        Routes[route_name + '_path'].apply(null, args)

    $item: $item
    itemId: $item.attr 'id'
    roomInfo: @getRoomInfo()
    getPath: (route_name) ->
      Routes[route_name + '_path'] @roomInfo.username, @roomInfo.slug, @itemId
    reloadItem: ->
      $.get @getPath('show_dressing_room_item'), (html) =>
        $new_item = $(html).css
          top: @$item.css 'top'
          left: @$item.css 'left'
          position: @$item.css 'position'

        @$item = @$item.replaceWith $new_item
        controller.layoutTiles()
    deleteItem: (activityId) ->
      $.ajax
        url: @getPath "delete_dressing_room_item", activityId
        type: 'DELETE'
        success: (json) =>
          @$item.detach()
          controller.layoutTiles()

  vote: (li, type, success) ->

    route_name = if li.hasClass('active') then "delete_dressing_room_item_#{type}" else "create_dressing_room_item_#{type}"

    helper = @actionHelper li
    path = helper.getPath route_name

    $.ajax
      url: path
      type: if li.hasClass('active') then 'DELETE' else 'POST'
      success: (json) =>
        if json.success
          if helper.roomInfo.user_owned && !li.hasClass('active') && li.hasClass('dislike')
            App.confirmModal.show
              titleHtml: "What would you like to do?"
              messageHtml: "You can either delete this item since you do not like it or you can leave it in your room"
              cancelHtml: "Leave It"
              confirmHtml: "Delete It"
              confirm: ->
                helper.deleteItem()
              cancel: ->
                helper.reloadItem()
          else
            helper.reloadItem()
        else
          log json.message

  getRoomInfo: ->
    @roomInfo ||= @element.getVar 'room_info'

  layoutTiles: (animate = if @element.find('.tile').length > 30 then 0 else 200) ->
    @element.find('.tile').wookmark
      offset: 14
      container: this.element
      autoResize: true
      animate: animate

    @element.find('.tile img').each (i, img) ->
      width = parseInt $(img).attr('data-width') || 180;
      if width < 180
        $(img).css 'margin-left', ((180-width) / 2) + 'px'




