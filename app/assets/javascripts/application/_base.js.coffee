window.App =
  Controls: {}
  init: ->
    @initBootstrap()
    @initControls()

  initBootstrap: ->
    $('.dropdown-toggle').dropdown()

  initControls: ->
    @confirmModal = new @Controls.ConfirmModal('#confirm_modal') if @Controls.ConfirmModal

$ -> window.App.init()



