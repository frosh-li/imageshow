javascript:(function(){var head = document.getElementsByTagName("head")[0];var allscript = head.getElementsByTagName("script");var b = false;for(var i = 0 ; i < allscript.length ; i++){if(allscript[i].getAttribute("id")=="dh_pick_img_script"){b=true;break;}}if(b){return;}var script = document.createElement("script");script.id="dh_pick_img_script";script.setAttribute("src","http://127.0.0.1:8000/dh/main.js?v"+new Date().getTime());head.appendChild(script);})();
