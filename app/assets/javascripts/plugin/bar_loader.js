(function () {

    snazzyUrl = window.snazzyUrl || "local.snazzyroom.com:3000";

    var snazzyHeight = 210;

    function init() {

        var currentImg;

        window.addEventListener('message', function (e) {

            if (e.data == 'closehover') {
                $('#snazzypop').fadeOut();
            }
            else {
                var data = $.parseJSON(e.data);

                switch (data.eventName) {
                    case "roomid":
                        //postHoverMsg(e.data);
                        break;
                }
            }
        }, false);

        window.addEventListener('dragstart', function (e) {
            if ($(e.target).is('img')) {
                var anchor = $(e.target).closest('a');

                dragData = {
                    dataType: 'image',
                    image: {
                        url: e.target.src,
                        width: e.target.width,
                        height: e.target.height
                    },
                    url: (anchor.length > 0 && anchor.attr('href')) ? anchor.attr('href') : window.location.href,

                };

                if (dragData.url.indexOf('/') == 0) {
                    dragData.url = window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + dragData.url;
                }

                $('#snazzy-relay').show();
            }
        });

        window.addEventListener('dragend', function (e) {
            $('#snazzy-relay').hide();
            dragData = null;
        });

        var sh = snazzyHeight + 'px';

        $('#snazzy-relay, #snazzy, #snazzypop').remove();

        $(document.body)
            .css('margin-bottom', sh)
            .append('<div id="snazzy-relay"></div>')
            //.append('<iframe src="http://' + snazzyUrl + '/plugin/hover_pop" id="snazzypop"></iframe>')
            .append('<iframe src="http://' + snazzyUrl + '/plugin/bar" id="snazzy"></iframe>');


        $('#snazzy-relay')
            .css({
                position: 'fixed',
                height: sh,
                display: 'none',
                backgroundColor: 'green',
                bottom: 0,
                zIndex: 10001,
                opacity: 0,
                width: '100%'
            })
            .append('<div id="snazzy-datazone"></div>');

        $('#snazzy').css({
            position: 'fixed',
            height: sh,
            width: '100%',
            right: 0,
            bottom: 0,
            border: 0,
            zIndex: 10000
        });

        $('#snazzypop').css({
            position: 'fixed',
            bottom: '130px',
            width: '315px',
            height: '290px',
            left: 0,
            border: 0,
            zIndex: 10001,
            display: 'none',
            padding: 0
        });

        var dragging = false;

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

        $(window).resize(handleResize);
        handleResize();
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
                position: 'absolute',
                top: '70px',
                backgroundColor: 'red',
                width: '920px',
                height: '110px',
                left: left
            });

        $('#snazzypop').css('left', left);
    }

    init();

})();
