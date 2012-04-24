
(function() {
	//GIMMEBAR
	var initial = "(function() {\n\t//GIMMEBAR\n";
	var scripts = document.querySelectorAll('script');
	for (var i = 0; i < scripts.length; i++) {
		if (scripts[i].innerHTML.substring(0, initial.length) === initial) {
			if (scripts[i].getAttribute('data-gimmebar-stub')) {
				scripts[i].parentNode.removeChild(scripts[i]);
			} else {
				scripts[i].setAttribute('data-gimmebar-stub', '1');
			}
		}
	}


	var GimmeBar = {};

	if(!GimmeBar.JSON)GimmeBar.JSON={};
	(function(){function l(b){return b<10?"0"+b:b}function o(b){p.lastIndex=0;return p.test(b)?'"'+b.replace(p,function(f){var c=r[f];return typeof c==="string"?c:"\\u"+("0000"+f.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+b+'"'}function m(b,f){var c,d,g,j,i=h,e,a=f[b];if(a&&typeof a==="object"&&typeof a.toJSON==="function")a=a.toJSON(b);if(typeof k==="function")a=k.call(f,b,a);switch(typeof a){case "string":return o(a);case "number":return isFinite(a)?String(a):"null";case "boolean":case "null":return String(a);
	case "object":if(!a)return"null";h+=n;e=[];if(Object.prototype.toString.apply(a)==="[object Array]"){j=a.length;for(c=0;c<j;c+=1)e[c]=m(c,a)||"null";g=e.length===0?"[]":h?"[\n"+h+e.join(",\n"+h)+"\n"+i+"]":"["+e.join(",")+"]";h=i;return g}if(k&&typeof k==="object"){j=k.length;for(c=0;c<j;c+=1){d=k[c];if(typeof d==="string")if(g=m(d,a))e.push(o(d)+(h?": ":":")+g)}}else for(d in a)if(Object.hasOwnProperty.call(a,d))if(g=m(d,a))e.push(o(d)+(h?": ":":")+g);g=e.length===0?"{}":h?"{\n"+h+e.join(",\n"+h)+
	"\n"+i+"}":"{"+e.join(",")+"}";h=i;return g}}if(typeof Date.prototype.toJSON!=="function"){Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+l(this.getUTCMonth()+1)+"-"+l(this.getUTCDate())+"T"+l(this.getUTCHours())+":"+l(this.getUTCMinutes())+":"+l(this.getUTCSeconds())+"Z":null};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){return this.valueOf()}}var q=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
	p=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,h,n,r={"\u0008":"\\b","\t":"\\t","\n":"\\n","\u000c":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},k;if(typeof GimmeBar.JSON.stringify!=="function")GimmeBar.JSON.stringify=function(b,f,c){var d;n=h="";if(typeof c==="number")for(d=0;d<c;d+=1)n+=" ";else if(typeof c==="string")n=c;if((k=f)&&typeof f!=="function"&&(typeof f!=="object"||typeof f.length!=="number"))throw Error("JSON.stringify");
	return m("",{"":b})};if(typeof GimmeBar.JSON.parse!=="function")GimmeBar.JSON.parse=function(b,f){function c(g,j){var i,e,a=g[j];if(a&&typeof a==="object")for(i in a)if(Object.hasOwnProperty.call(a,i)){e=c(a,i);if(e!==undefined)a[i]=e;else delete a[i]}return f.call(g,j,a)}var d;b=String(b);q.lastIndex=0;if(q.test(b))b=b.replace(q,function(g){return"\\u"+("0000"+g.charCodeAt(0).toString(16)).slice(-4)});if(/^[\],:{}\s]*$/.test(b.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
	"]").replace(/(?:^|:|,)(?:\s*\[)+/g,""))){d=eval("("+b+")");return typeof f==="function"?c({"":d},""):d}throw new SyntaxError("JSON.parse");}})();

	var barHeight = 80;
	var divWrap = document.createElement('div');
	var div = document.createElement('div');
	function applyStyles(elt, styles) {
		var i, l, vals, name, val;
		for (i = 0, l = styles.length; i < l; i++) {
			vals = styles[i].split(':');
			name = vals[0];
			val = vals[1];
			elt.style[name] = val;
		}
	}
	function buildDropZone(parent, className) {
		var styles = ["margin-right:1.25%",
									"border-radius:3px", "display:block", "height:60px", "margin:20px", "position:relative",
									"border-top-left-radius:3px 3px", "border-top-right-radius:3px 3px",
									"border-bottom-right-radius:3px 3px", "border-bottom-left-radius:3px 3px"];
		var d = document.createElement('div');
		applyStyles(d, styles);
		d.className = className;
		
		if(className === "public"){
			d.style.marginRight = "10px";
		}
		else{
			d.style.marginLeft = "10px";
		}
		
		d.setAttribute('data-dropzone', 'true');
		parent.appendChild(d);
	}
	function buildDoc() {
		var styles = ["position:absolute","margin:0","padding:0","outline:none","display:block",
									"margin-right:1.25%", "border-radius:3px", "height:60px", "margin:20px",
									"position:relative", "border-top-left-radius:3px 3px",
									"border-top-right-radius:3px 3px", "border-bottom-right-radius:3px 3px",
									"border-bottom-left-radius:3px 3px"];
		var d,i;
		for (i = 0; i < 2; i++) {
			d = document.createElement('div');
			d.setAttribute('data-zonetype', i === 0 ? 'public' : 'private');
			d.style.width = "50%";
			d.style.cssFloat = "left";
			d.style.position = 'relative';
			d.style.height = '96px';
			buildDropZone(d, i === 0 ? 'public' : 'private');
			div.appendChild(d);
			d.addEventListener('dragover', dragOver, false);
			d.addEventListener('dragenter', dragEnter, false);
			d.addEventListener('dragleave', dragLeave, false);
			d.addEventListener('drop', drop, false);
		}
		var assimilator = document.createElement('div');
		assimilator.style.position = 'absolute';
		assimilator.style.width = '200px';
		assimilator.style.height = '90px';
		assimilator.style.top = '0';
		assimilator.style.right = '0';

		div.appendChild(assimilator);
		// div.
	}
	function getViewportHeight() {
		if (typeof window.innerHeight != 'undefined') {
			return window.innerHeight;
		} else if (typeof document.documentElement != 'undefined' && typeof document.documentElement.clientHeight != 'undefined' && document.documentElement.clientHeight != 0) {
			return document.documentElement.clientHeight
		}
		return document.getElementsByTagName('body')[0].clientHeight
	}
	function getGimmebar() {
		var src = 'http://localhost:2610/Plugin';
		var i, l, iframes = document.getElementsByTagName('iframe');
		for (i = 0, l = iframes.length; i < l; i++) {
			if (iframes[i].src && iframes[i].src.substring(0, src.length) === src) {
				return iframes[i];
			}
		}
		return null;
	}
	function buildMessage(type, data) {
		data = data || {};
		data.type = type;
		data.url = document.location.href;
		return GimmeBar.JSON.stringify(data);
	}
	function dragOver(e) {
		e.stopPropagation();
		e.preventDefault();
		e.dataTransfer.dropEffect = e.dataTransfer.effectAllowed;
		return false;
	}
	function dragEnter(e) {
		var target = e.target;
		var type;
		if (target.getAttribute('data-dropzone')) {
			type = target.parentNode.getAttribute('data-zonetype');
			getGimmebar().contentWindow.postMessage(buildMessage('dragEnter', {'zoneType':type}), 'https://gimmebar.com');
		}
		e.stopPropagation();
		e.preventDefault();
		e.dataTransfer.dropEffect = e.dataTransfer.effectAllowed;
		return false;
	}
	function dragLeave(e) {
		var target = e.target;
		if (target.getAttribute('data-dropzone')) {
			getGimmebar().contentWindow.postMessage(buildMessage('dragLeave'), 'https://gimmebar.com');
		}
		e.stopPropagation();
		e.preventDefault();
		return false;
	}
	function contains(array, elt) {
		var i, l;
		for (i = 0, l = array.length; i < l; i++) {
			if (array[i] === elt) {
				return true;
			}
		}
		return false;
	}
	function drop(e) {
		var target = e.target;
		e.stopPropagation();
		e.preventDefault();
		var dt = e.dataTransfer;
		var text = dt.getData('Text');
		var files = dt.files;
		var data;
		var dropzone = this.getAttribute('data-zonetype');
		if (!files || files.length === 0) {
			try {
				data = GimmeBar.JSON.parse(text);
				try {
					var overlay = GimmeBar.JSON.parse(data.text);
					data.overlayData = overlay.overlayData;
				} catch (e) { }
			} catch (e) {
				data = {source: text, title: document.title};
			}
			if (contains(dt.types, 'application/x-moz-file-promise-url')) {
				data.imgSrc = dt.getData('application/x-moz-file-promise-url');
			}
			// make sure a dragged link is not an image
			if (contains(dt.types, 'text/x-moz-url') && !contains(dt.types, 'application/x-moz-nativeimage')) {
				data.URL = dt.getData('text/x-moz-url').split("\n");
			} else if (contains(dt.types, 'URL')) {
				data.URL = [dt.getData('URL'), data.title];
			}
			data.plainText = dt.getData('text/plain');
			getGimmebar().contentWindow.postMessage(buildMessage('drop', {'dropzone': dropzone, 'dropData': data}), 'https://gimmebar.com');
		}
		return false;
	}
	function positionDiv() {
		div.style.top = (getViewportHeight()-barHeight) + "px";
	}
	window.addEventListener('resize', function() {
		var iframe = getGimmebar();
		if (iframe) {
			positionDiv();
		}
	}, false);
	var exists = document.querySelectorAll('div[data-interceptorDiv]');
	if (exists.length > 0) return;
	divWrap.setAttribute('data-interceptorDiv', '1');
	document.body.appendChild(divWrap);
	divWrap.appendChild(div);
	divWrap.style.display = "none"
	divWrap.style.bottom = 0;
	divWrap.style.width="100%";
	divWrap.style.zIndex=1000001;
	divWrap.style.height="94px";
	divWrap.style.position='fixed';
	divWrap.style.filter = 'alpha(opacity=0)';
	divWrap.style['-moz-opacity'] = '0.0';
	divWrap.style.opacity = '0.0';
	
	div.style.height = "94px";
	div.style.paddingRight="200px";

	//positionDiv();
	buildDoc();
})();
