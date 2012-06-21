do ->
  # if the api has already been loaded then just toggle and get it on with it
  if window.SnazzyRoom
    window.SnazzyRoom.toggle()
    return

  #### scoped globals:

  # local alias existing jquery if it exists on the page
  $ = window.jQuery

  snazzyUrl = window.snazzyUrl or "snazzyroom.herokuapp.com/"
  snazzyWidth = 180
  jQueryLoading = false

  setsourceTimeout = $marginEl = marginValue = dragData = null

  #### functions:

  parseJSON = (json) ->
    (if (window.JSON and window.JSON.parse) then JSON.parse(json) else $.parseJSON(json))

  loadJQuery = ->
    unless jQueryLoading
      jQueryLoading = true
      el = document.createElement("SCRIPT")
      el.type = "text/javascript"
      el.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
      document.getElementsByTagName("head")[0].appendChild el

  handleDataMsg = (data) ->
    switch data.eventName
      when "sourceset"
        clearTimeout setsourceTimeout
      when "roomid", "add_current_page"
        addCurrentPage()

  addCurrentPage = ->
    data = getDataFromImage(findBestChoiceImage(), true)
    postSnazzyMsg JSON.stringify(data)

  findBestChoiceImage = ->
    $imgs = $("img")
    $img = null
    $imgs.each (i, img) ->
      width = $(img).width()
      height = $(img).height()
      $img = $(img)  if width < 1000 and (not $img or $img.width() < width) and height >= (width * 0.9)

    $img

  getDataFromImage = ($img, ignoreAnchor) ->
    anchor = $img.parents("a")
    dragData =
      dataType: "image"
      image:
        url: $img.attr("src")
        width: $img.width()
        height: $img.height()

      url: (if (not ignoreAnchor and anchor.length > 0 and anchor.attr("href") and anchor.attr("href").indexOf("javascript:") < 0) then anchor.attr("href") else window.location.href)

    dragData.url = window.location.protocol + "//" + window.location.hostname + ":" + window.location.port + dragData.url  if dragData.url.indexOf("/") is 0
    dragData

  postHoverMsg = (msg) ->
    document.getElementById("snazzypop").contentWindow.postMessage msg, "*"

  postSnazzyMsg = (msg) ->
    document.getElementById("snazzy").contentWindow.postMessage msg, "*"

  handleResize = ->
    left = (($(window).width() - 940) / 2) + "px"
    $("#snazzy-datazone").css
      position: "fixed"
      backgroundColor: "red"
      width: "180px"
      height: "100%"
      right: 0
      top: 0

    $("#snazzypop").css "left", left

  initLayout = ->
    $bodyContainer = null
    if window.YAHOO
      $bodyContainer = $(document.body).addClass("snazzy_canvas_frame")
    else
      $bodyContainer = $("<div class=\"snazzy_canvas_frame\"></div>")
      $(document.body).children().each (i, el) ->
        try
          $(el).appendTo $bodyContainer

      $(document.body).append $bodyContainer

    $bodyContainer.css "margin-right", snazzyWidth + "px"
    $(document.body)
      .append("<div id=\"snazzy_relay\"></div>")
      .append "<iframe src=\"http://" + snazzyUrl + "/plugin/rail\" id=\"snazzy\"></iframe>"

    $("#snazzy_relay")
      .css
        position: "fixed"
        height: "100%"
        display: "none"
        backgroundColor: "green"
        zIndex: 10001
        opacity: 0
        width: snazzyWidth + "px"
        right: 0
      .append "<div id=\"snazzy-datazone\"></div>"

    $("#snazzy")
      .css
        position: "fixed"
        height: "100%"
        width: snazzyWidth + "px"
        right: 0
        top: 0
        border: 0
        zIndex: 10000
        borderLeft: "1px solid #999"

    $("#snazzypop")
      .css
        position: "fixed"
        top: "50px"
        width: "315px"
        height: "290px"
        right: snazzyWidth + "px"
        border: 0
        zIndex: 10001
        display: "none"
        padding: 0

  initEvents = ->
    window.addEventListener "message", (e) ->
      if e.data
        data = parseJSON(e.data)
        handleDataMsg data if data

    $(document.body)
      .bind "dragstart", (e) ->
        $target = $(e.target);
        $img = if $target.is("img") then $target else $target.find("img")

        if $img.length > 0
          dragData = getDataFromImage($img)
          $("#snazzy_relay").show()

      .bind "dragend", (e) ->
        $("#snazzy_relay").hide()
        dragData = null

    $("#snazzy-datazone")
      .bind "dragover", (e) ->
        e.stopPropagation()
        e.preventDefault()
        try
          e.dataTransfer.dropEffect = true
        false
      .bind "dragenter", (e) ->
        $(this).css "background-color", "yellow"
        postSnazzyMsg "dragenter"
        e.stopPropagation()
        e.preventDefault()
        false
      .bind "dragleave", (e) ->
        $(this).css "background-color", "red"
        postSnazzyMsg "dragleave"
        e.stopPropagation()
        e.preventDefault()
        false
      .bind "drop", (e) ->
        data = JSON.stringify(dragData)
        postSnazzyMsg data
        e.stopPropagation()
        e.preventDefault()
        false

  init = ->
    unless window.jQuery
      loadJQuery()
      setTimeout init, 500
      return
    unless $
      jQuery.noConflict()
      $ = jQuery

    currentImg = undefined
    initLayout()
    initEvents()
    $(window).resize handleResize
    handleResize()
    setsourceTimeout = setInterval (-> postSnazzyMsg "setsource"), 1000

  urlContains = (path) ->
    window.location.hostname.toLowerCase().indexOf path

  window.SnazzyRoom =
    isActive: ->
      activeSession

    activate: ->
      $("#snazzy").show()
      $marginEl = null
      $marginEl = $(".snazzy_canvas_frame")
      marginValue = $marginEl.css("margin-right")
      $marginEl.css "margin-right", snazzyWidth + "px"
      activeSession = true

    deactivate: ->
      $("#snazzy").hide()
      activeSession = false
      $marginEl.css "margin-right", marginValue  if $marginEl

    toggle: ->
      if @isActive() then @deactivate() else @activate()

  init()
  window.SnazzyRoom.activate()