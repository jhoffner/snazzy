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

	var activeSession = false;
	var snazzyHeight = 210;
    var cookieName = "snazzy-active";

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
			
        $(document.body)
            .append('<script type="text/javascript">'
                 + 'var s = document.createElement("SCRIPT");'
                 + 's.type = "text/javascript";'
                 + 's.src = "http://local.snazzyroom.com:3000/assets/plugin/bar_loader.js";'
                 + 'document.getElementsByTagName("head")[0].appendChild(s);'
                 + '</script>');

        $(window).resize(handleResize);
        handleResize();
		
		Cookie.set(cookieName, 'active', 1);

		activeSession = true;
	}
	
	function deactivateSnazzy(){
		$('#snazzy').remove();
		$('#canvas_frame').css({ height: '100%' });
		activeSession = false;
		
		Cookie.clear(cookieName);
	}

	function handleResize() {
		if (activeSession) {
			$('#canvas_frame').css({ height: ($(window).height() - snazzyHeight) + 'px' });
		}
	}

	window.snazzyActionClick = function(){

		if (activeSession){
			deactivateSnazzy();
		}
		else {
			activateSnazzy(true);
		}
	}
	
	initSnazzy();

})();