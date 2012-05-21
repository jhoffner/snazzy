(function () {
    var Cookie = {
        set: function(name, value, days){
            if (days) {
                var date = new Date();
                date.setTime(date.getTime()+(days*24*60*60*1000));
                var expires = "; expires="+date.toGMTString();
            }
            else var expires = "";
            document.cookie = name+"="+value+expires+"; path=/";
        },
        get: function(name){
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for(var i=0;i < ca.length;i++) {
                var c = ca[i];
                while (c.charAt(0)==' ') c = c.substring(1,c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
            }
            return null;
        },
        clear: function(name){
            this.set(name,"",-1);
        }
    }

	var activeSession = false, wasActivated = false;

    var cookieName = "snazzy_rail_active";

	function initSnazzy(){
		checkForActiveSession(function(){
			setTimeout(activateSnazzy, 500);
		});
	}
	
	function checkForActiveSession(cb) {

	    if (Cookie.get(cookieName) == 'active'){
            cb();
        }
	}
	
	function activateSnazzy(){
        if (window.location.hostname.indexOf("herokuapp") > 0 || window.location.hostname.indexOf('snazzyroom') > 0){
            return;
        }

        Cookie.set(cookieName, 'active', 1);

        activeSession = true;

        if (wasActivated){
            //execScript("SnazzyRoom.activate();");

            $("#snazzy").show();
            $(".snazzy-body-container").css("margin-right", "180px");
        }
        else{
            execScript(
                'var s = document.createElement("SCRIPT");'
                + 's.type = "text/javascript";'
                + 's.src = "http://blooming-winter-9847.herokuapp.com/assets/plugin/rail_loader.js";'
                + 'document.getElementsByTagName("head")[0].appendChild(s);'
            );

            wasActivated = true;
        }
	}
	
	function deactivateSnazzy(){

		if (wasActivated){
            //execScript("SnazzyRoom.deactivate();");
            $("#snazzy").hide();
            $(".snazzy-body-container").css("margin-right", 0);
        }

        activeSession = false;
		Cookie.clear(cookieName);
	}

	function handleResize() {
		if (activeSession) {
			//$('#canvas_frame').css({ width: ($(window).width() - snazzyWidth) + 'px' });
		}
	}

    function execScript(js){
        $(document.body)
            .append('<script type="text/javascript">try{'
            + js
            + '}catch(ex){if(window.console && console.debug){console.debug(ex);}}</script>');
    }

	window.snazzyRailActionClick = function(){

		if (activeSession){
			deactivateSnazzy();
		}
		else {
			activateSnazzy(true);
		}
	}
	
	initSnazzy();



})();