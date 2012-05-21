App.Controls.ConfirmModal = can.Control
  defaults:
    backdrop: true
    show: false
    keyboard: true
    confirm: null
    cancel: null
    titleHtml: null
    messageHtml: null
    cancelHtml: null
    confirmHtml: null
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

    @element.find('h3').html(options.titleHtml) if options.titleHtml
    @element.find('p').html(options.messageHtml) if options.messageHtml
    @element.find('.btn[data-dismiss="modal"]').html(options.cancelHtml) if options.cancelHtml
    @element.find('.btn-primary').html(options.confirmHtml) if options.confirmHtml
    @element.modal 'show'
    @showOptions = options


