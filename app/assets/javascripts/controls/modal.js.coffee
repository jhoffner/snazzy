App.Controls.ConfirmModal = can.Control
  defaults:
    backdrop: true
    show: false
    keyboard: true
    confirm: null
    cancel: null
    titleHtml: "Confirm"
    messageHtml: "Would you like to proceed?"
    cancelHtml: "Cancel"
    confirmHtml: "Confirm"
,
  init: (el, options) ->
    @element.modal(@options)

  '*[data-dismiss="modal"] click': (el, e) ->
    @showOptions.cancel(e) if @showOptions.cancel

  '.btn-primary click': (btn, e) ->
    @element.modal 'hide'
    @showOptions.confirm(e) if @showOptions.confirm

  show: (options = {}) ->

    _.defaults options, @options

    @element.find('h3').html(options.titleHtml)
    @element.find('p').html(options.messageHtml)
    @element.find('.btn[data-dismiss="modal"]').html(options.cancelHtml)
    @element.find('.btn-primary').html(options.confirmHtml)
    @element.modal 'show'
    @showOptions = options


