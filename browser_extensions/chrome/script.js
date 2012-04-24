(function () {
	var activeSession = false;
	var snazzyHeight = 210;

	function initSnazzy(){
		checkForActiveSession(function(){
			activateSnazzy(false);
		});
	}
	
	function checkForActiveSession(cb) {
		
	}
	
	function activateSnazzy(updateSession){
			
        $(document.body)
            .append('<script type="text/javascript">'
                 + 'var s = document.createElement("SCRIPT");'
                 + 's.type = "text/javascript";'
                 + 's.src = "http://snazzyroom.apphb.com/Scripts/BrowserPluginLoader.js";'
                 + 'document.getElementsByTagName("head")[0].appendChild(s);'
                 + '</script>');

        $(window).resize(handleResize);
        handleResize();
		
		if (updateSession){
			//$.post('/Plugin/UpdateSession', {activate: true});
		}

		activeSession = true;
	}
	
	function deactivateSnazzy(){
		$('#snazzy').remove();
		$('#canvas_frame').css({ height: '100%' });
		activeSession = false;
		
		if (updateSession){
			//$.post('/Plugin/UpdateSession', {activate: false});
		}
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
	
/*
	var js = document.createElement('script');
	js.src = 'http://code.jquery.com/jquery-1.7.min.js';
	document.body.appendChild(js);

	var poll = function () {
		
		if (window.jQuery) {
			initSnazzy();
		}
		else {
			window.setTimeout(poll, 100);
		}
	}

	poll();
*/
})();