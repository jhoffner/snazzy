(function () {

    snazzyUrl = window.snazzyUrl || "local.snazzyroom.com:3000";

    var snazzyWidth = 180, jQueryLoading = false, setsourceTimeout
    var $ = window.jQuery

    function parseJSON(json){
        return (window.JSON && window.JSON.parse) ? JSON.parse(json) : $.parseJSON(json);
    }

    function loadJQuery(){
        if (!jQueryLoading){
            jQueryLoading = true;
            el = document.createElement("SCRIPT");
            el.type = "text/javascript";
            el.src = "http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js";
            document.getElementsByTagName("head")[0].appendChild(el);
        }
    }

    function handleDataMsg(data){
        switch (data.eventName) {
            case "sourceset":
                clearTimeout(setsourceTimeout);
                break;

            case "roomid":
                //postHoverMsg(e.data);
                break;

            case "add_current_page":
                addCurrentPage();
                break;
        }
    }

    function addCurrentPage(){
       data = getDataFromImage(findBestChoiceImage(), true);
       postSnazzyMsg(JSON.stringify(data));
    }

    function findBestChoiceImage(){
        $imgs = $("img");
        var $img = null;
        $imgs.each(function(i, img){
            width = $(img).width();
            height = $(img).height();
            if (width < 1000 && (!$img || $img.width() < width) && height >= (width*0.9)){
                $img = $(img);
            }
        })

        return $img;
    }

    function getDataFromImage($img, ignoreAnchor){
        var anchor = $img.parents('a');
        var dragData = {
            dataType: 'image',
            image: {
                url: $img.attr('src'),
                width: $img.width(),
                height: $img.height()
            },
            url: (!ignoreAnchor && anchor.length > 0 && anchor.attr('href') && anchor.attr('href').indexOf('javascript:') < 0)
                ? anchor.attr('href')
                : window.location.href
        };

        if (dragData.url.indexOf('/') == 0) {
            dragData.url = window.location.protocol
                + '//' + window.location.hostname
                + ':' + window.location.port
                + dragData.url;
        }

        return dragData;
    }

    function postHoverMsg(msg) {
        document.getElementById("snazzypop").contentWindow.postMessage(msg, '*')
    }

    function postSnazzyMsg(msg) {
        document.getElementById("snazzy").contentWindow.postMessage(msg, '*')
    }


    function handleResize() {
        var left = (($(window).width() - 940) / 2) + 'px';
        $('#snazzy-datazone')
            .css({
                position: 'fixed',
                backgroundColor: 'red',
                width: '180px',
                height: '100%',
                right: 0,
                top: 0
            });

        $('#snazzypop').css('left', left);
    }

    function initLayout(){

        $bodyContainer = null;
        if (window.YAHOO){
            $bodyContainer = $(document.body).addClass("snazzy-body-container");
        }
        else {
            $bodyContainer = $('<div class="snazzy-body-container"></div>');

            $(document.body).children().each(function(i, el){
                try{$(el).appendTo($bodyContainer);}catch(ex){}
            });

            $(document.body)
                .append($bodyContainer)
        }

        $bodyContainer.css("margin-right", snazzyWidth + "px");

        $(document.body)
            .append('<div id="snazzy-relay"></div>')
            //.append('<iframe src="http://' + snazzyUrl + '/plugin/hover_pop" id="snazzypop"></iframe>')
            .append('<iframe src="http://' + snazzyUrl + '/plugin/rail" id="snazzy"></iframe>');


        $('#snazzy-relay')
            .css({
                position: 'fixed',
                height: "100%",
                display: 'none',
                backgroundColor: 'green',
                zIndex: 10001,
                opacity: 0,
                width: snazzyWidth + 'px',
                right: 0
            })
            .append('<div id="snazzy-datazone"></div>');

        $('#snazzy').css({
            position: 'fixed',
            height: "100%",
            width: snazzyWidth + 'px',
            right: 0,
            top: 0,
            border: 0,
            zIndex: 10000,
            borderLeft: "1px solid #999"
        });

        $('#snazzypop').css({
            position: 'fixed',
            top: '50px',
            width: '315px',
            height: '290px',
            right: snazzyWidth + 'px',
            border: 0,
            zIndex: 10001,
            display: 'none',
            padding: 0
        });
    }

    function initEvents(){
        window.addEventListener('message', function (e) {

            if (e.data == 'closehover') {
                $('#snazzypop').fadeOut();
            }

            else if (e.data){
                var data = parseJSON(e.data);
                if (data){
                    handleDataMsg(data);
                }
            }
        });

        $(window)
            .bind('dragstart', function (e) {
                if ($(e.target).is('img')) {
                    dragData = getDataFromImage($(e.target));

                    $('#snazzy-relay').show();
                }
            })
            .bind('dragend', function (e) {
                $('#snazzy-relay').hide();
                dragData = null;
            });

        $('#snazzy-datazone')
            .bind('dragover', function (e) {
                e.stopPropagation();
                e.preventDefault();
                try { e.dataTransfer.dropEffect = true; } catch (e) { }
                return false;
            })
            .bind('dragenter', function (e) {
                $(this).css('background-color', 'yellow');
                postSnazzyMsg('dragenter');

                e.stopPropagation();
                e.preventDefault();

                return false;
            })
            .bind('dragleave', function (e) {
                $(this).css('background-color', 'red');
                postSnazzyMsg('dragleave');

                e.stopPropagation();
                e.preventDefault();

                return false;
            })
            .bind('drop', function (e) {

                var data = JSON.stringify(dragData);

                //postSnazzyMsg('askroomid');
                postSnazzyMsg(data);
                //postHoverMsg(data);
                //$('#snazzypop').fadeIn();

                e.stopPropagation();
                e.preventDefault();
                return false;
            });
    }

    function init() {

        if (!window.jQuery){
            loadJQuery();
            setTimeout(init, 500);
            return;
        }

        if (!$){
            jQuery.noConflict();
            $ = jQuery;
        }

        var currentImg;

        initLayout();
        initEvents();

        $(window).resize(handleResize);
        handleResize();

        setsourceTimeout = setInterval(function(){postSnazzyMsg("setsource")}, 1000);
    }

    function urlContains(path){
        return window.location.hostname.toLowerCase().indexOf(path)
    }

    var marginSet = null

    window.SnazzyRoom = {
        activate: function(){
            $('#snazzy').show();
            $marginEl = null;

//            if (urlContains("amazon")){
//                $marginEl = $("#page-wrap, #navbar, #page-footer, #divsinglecolumnminwidth");
//            }
//            else{
                $marginEl = $(".snazzy-body-container")
//            }

            marginValue = $marginEl.css('margin-right');

            $marginEl.css('margin-right', snazzyWidth + 'px');

            marginSet = [$marginEl, marginValue];
        },
        deactivate: function(){
            alert("deactivate fired");
            $('#snazzy').hide();
//            $('#canvas_frame').css({ width: '100%' });
            activeSession = false;

            if (marginSet){
                marginSet[0].css('margin-right', marginSet[1]);
            }
        }
    }

    init();
    window.SnazzyRoom.activate();

})();


