
App.DressingRooms.ShowController = can.Control
  init: (el, options) ->
    @tiles = new App.DressingRooms.Tiles $("#tiles_container")
    @friendsModal = new App.Controls.ConfirmModal('#friends_modal')

  '#action_add_contributors click': (el, e) -> @showFriendsModal()

  showFriendsModal: ->
    @jfmfs ||= $('#jfmfs_container')
      .jfmfs
        friend_fields: 'id,name'
        pre_selected_friends: [] #todo: add preselected friends
      .data 'jfmfs'

    @friendsModal.show
      confirm: =>
        alert @jfmfs.getSelectedIds()


