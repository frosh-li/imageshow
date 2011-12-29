(function() {
	var dh = function() {
		this.mainContainer = null;
		this.pickBtn = null;
	};
	dh.setFloatStyle = function(obj, style) {
		var sty = obj.style;
		if ('cssFloat' in sty) {
			obj.style.cssFloat = style;
		} else if ('styleFloat' in sty) {
			obj.style.styleFloat = style;
		} else {
			throw 'set float style:' + style + 'error.';
		}
	}
	// 测试中文
	dh.prototype = {
		init : function() {
			this.drawPanel();
		},
		drawPanel : function() {

			var newElement = document.createElement("div");
			newElement.id = "dh_pick_img";
			newElement
					.setAttribute(
							"style",
							"position:fixed;width:160px;right:0px;top:0px;overflow-x:hidden;overflow-y:scroll;margin:0px;padding:10px;border:1px solid #ccc;z-index:999999;");
			newElement.innerHTML = '<div style="text-align: center;"><span id="_obj_dh_pick_btn_" style="color: rgb(102, 102, 102); font-size: 14px; display:inline-block; text-shadow: rgba(0, 0, 0, 0.292969) 0px 1px 1px; border-top-left-radius: 0.5em 0.5em; border-top-right-radius: 0.5em 0.5em; border-bottom-right-radius: 0.5em 0.5em; border-bottom-left-radius: 0.5em 0.5em; padding-top: 0.5em; padding-right: 2em; padding-bottom: 0.55em; padding-left: 2em; -webkit-box-shadow: rgba(0, 0, 0, 0.199219) 0px 1px 2px; box-shadow: rgb(48, 27, 41) 3px 2px 31px; background-color: white; cursor: pointer; position: relative; top: 0px; opacity: 0.9; " onmouseover="this.style.opacity=1;" onmouseout="this.style.opacity=0.9" onmousedown="this.style.top=\'1px\'" onmouseup="this.style.top=\'0px\'">'
					+ "\u6293\u53d6\u672c\u9875\u56fe\u7247"
					+ '</span>'
					+'<span id="_obj_dh_save_btn_" style="color: rgb(102, 102, 102); margin-left:10px;font-size: 14px; display:none; text-shadow: rgba(0, 0, 0, 0.292969) 0px 1px 1px; border-top-left-radius: 0.5em 0.5em; border-top-right-radius: 0.5em 0.5em; border-bottom-right-radius: 0.5em 0.5em; border-bottom-left-radius: 0.5em 0.5em; padding-top: 0.5em; padding-right: 2em; padding-bottom: 0.55em; padding-left: 2em; -webkit-box-shadow: rgba(0, 0, 0, 0.199219) 0px 1px 2px; box-shadow: rgb(48, 27, 41) 3px 2px 31px; background-color: white; cursor: pointer; position: relative;margin-top:15px; top: 0px; opacity: 0.9; " onmouseover="this.style.opacity=1;" onmouseout="this.style.opacity=0.9" onmousedown="this.style.top=\'1px\'" onmouseup="this.style.top=\'0px\'">'
					+ "\u4e0a\u4f20"
					+ '</span><span id="_obj_dh_max_btn_" style="color: rgb(102, 102, 102); font-size: 14px; display:none;margin-left:10px; text-shadow: rgba(0, 0, 0, 0.292969) 0px 1px 1px; border-top-left-radius: 0.5em 0.5em; border-top-right-radius: 0.5em 0.5em; border-bottom-right-radius: 0.5em 0.5em; border-bottom-left-radius: 0.5em 0.5em; padding-top: 0.5em; padding-right: 2em; padding-bottom: 0.55em; padding-left: 2em; -webkit-box-shadow: rgba(0, 0, 0, 0.199219) 0px 1px 2px; box-shadow: rgb(48, 27, 41) 3px 2px 31px; background-color: white; cursor: pointer; position: relative;margin-top:15px; top: 0px; opacity: 0.9; " onmouseover="this.style.opacity=1;" onmouseout="this.style.opacity=0.9" onmousedown="this.style.top=\'1px\'" onmouseup="this.style.top=\'0px\'">'
					+ "\u6700\u5c0f\u5316"
					+ '</span></div><input  type="hidden" value="" id="_dh_ablum_id_" /><div id="_obj_dh_picked_images_list" style="padding:10px;display:none;color:white;">'
					
					+'</div>';
			// TODO page element
			var me = this;
			document.body.insertBefore(newElement,document.body.firstChild);
			this.mainContainer = newElement;
			this.pickBtn = document.getElementById("_obj_dh_pick_btn_");
			document.getElementById("_obj_dh_max_btn_").onclick = function() {
				// min window
				me.minSize();

			};
			this.pickBtn.onclick = function() {
				me.startToPick(me)
			};
			document.getElementById("_obj_dh_save_btn_").onclick = function() {
				me.ajaxPost();
			};
		},
		getPageHeight : function() {

			return document.documentElement.offsetHeight;
		},
		check_login:function(){
			var script = document.createElement("script");
			script.src = "http://bmifrosh.vicp.net:8000/loginstate";
			script.setAttribute("charset","utf-8");
		    document.body.appendChild(script);
		},
		startToPick : function(me) {
			me.check_login();
			var tpl = "<img src='${src}' style='width:80px;height:80px;' /><span>${title}</span><em>size:${size}</em>";
			var allimages = document.getElementsByTagName("img"), pageTitle = document
					.getElementsByTagName("title")[0].innerHTML, htmlCode = [], aData = [];
			var targetElement = document
					.getElementById("_obj_dh_picked_images_list");
			targetElement.innerHTML = "";
			console.log(allimages.length);
			for ( var i = 0; i < allimages.length; i++) {
				var cImg = allimages[i];
				if (parseInt(cImg.width) < 300) {
					continue;
				}
				var cAlt = cImg.getAttribute("alt"), cTitle = cImg
						.getAttribute("title"), cSrc = cImg.getAttribute("src"), size = cImg.width
						+ "*" + cImg.height;
				rTitle = cAlt != "" && cAlt != null ? cAlt : (cTitle != ""
						&& cTitle != null ? cTitle : pageTitle);
				var space = rTitle.split(" "), _split = rTitle.split("_");
				if (_split.length > 0) {
					rTitle = _split[0];
				} else if (space.length > 0) {
					rTitle = space[0]
				}
				var newImage = new Image();
				newImage.src = cSrc;
				cSrc = newImage.src;
				delete newImage;
				var ext = cSrc.substring(cSrc.length - 4, cSrc.length);
				//cSrc = escape(cSrc);
				var cElement = document.createElement("div");
				
				dh.setFloatStyle(cElement, "left");
				cElement.style.color = "white";
				cElement.style.width = "200px";
				cElement.style.height = "auto";
				cElement.style.margin = "10px 0 10px 20px";
				cElement.style.lineHeight = "18px";
				cElement.style.position = "relative";
				cElement.innerHTML = "<img src='"
						+ cSrc
						+ "' style='width: 200px;height:200px;box-shadow: 0 0  10px white;' /><span style='display:block;'>"
						+ rTitle
						+ "</span><em>size:"
						+ size
						+ "</em><a href=\"#\" style=\"position: absolute;background: transparent url('http://bmifrosh.vicp.net:8000/fancybox/fancybox.png') -40px 0px;display: block;width: 27px;height: 25px;top: -15px;right: -15px;\"></a><i style='position: absolute;width: 40px;height: 40px;top: 30%;left: 45%;background-color: green;text-align: center;font-size: 40px;font-weight: 700;line-height: 40px;font-style: normal;display:none;'></i>";
				htmlCode.push(cElement);
				cElement.onclick = function(e) {
					var evt = window.event || e;
					var target = null;
					if (evt.target) {
						target = evt.target
					} else {
						target = evt.srcElement;
					}
					if (target.tagName.toUpperCase() == "A") {
						var img = target.parentNode.getElementsByTagName("img")[0], src = img.src;

						for ( var i = 0; i < me.aData.length; i++) {
							if (me.aData[i]['src'] == src) {
								me.aData.splice(i, 1);
								target.parentNode.parentNode
										.removeChild(target.parentNode);
								break;
							}
						}
						console.log(me.aData);
					}
				};
				aData.push({
					title : rTitle,
					src : cSrc,
					size : size,
					ext : ext
				});
			}
			for ( var i = 0; i < htmlCode.length; i++) {
				targetElement.appendChild(htmlCode[i]);
			}
			var cleardiv = document.createElement("div");
			cleardiv.style.clear = "both";
			targetElement.appendChild(cleardiv);
			console.log(aData);
			me.aData = aData;
			var mainContain = document.getElementById("dh_pick_img");
			mainContain.style.width = "100%";
			mainContain.style.height = "100%";
			document.getElementById("_obj_dh_max_btn_").style.display = "inline-block";
			document.getElementById("_obj_dh_save_btn_").style.display = "inline-block";
			var mask = document.createElement("div");
			mask.style.width = "100%";
			mask.style.height = me.getPageHeight() + "px";
			;
			mask.style.opacity = 0.8;
			mask.style.left = "0px";
			mask.style.top = "0px";
			mask.style.backgroundColor = "black";
			mask.id = "_dh_div_mask_";
			mask.style.position = "absolute";
			mask.style.zIndex = "999998";
			document.body.appendChild(mask);
			document.getElementById("_obj_dh_picked_images_list").style.display = "block";
			document.getElementById("_obj_dh_pick_btn_").style.display = "none";
			// me.ajaxPost(aData);
		},
		getPageAllImages : function() {
			var allimages = document.getElementsByTagName("img");
			for ( var i = 0; i < allimages.length; i++) {
				// this.mainContainer.appendChild(allimages[i]);
			}
		},
		ajaxPost : function() {
			var obj = this.aData;
			console.log(obj.length);
			if (obj.length == 0) {
				return;
			}
			var catid= document.getElementById("_dh_ablum_id_").value;
			if(catid == ""){
				alert("\u8bf7\u9009\u62e9\u753b\u677f"); // 请选择画板
				return;
			}
			for ( var i = 0; i < obj.length; i++) {
				var c = obj[i], param = [];
				var host = window.location.origin;
				c.title = encodeURI(c.title);
				for ( var key in c) {
					if(key == "src"){
						param.push(key + "=" +  escape(c[key]));
					}else{
						param.push(key + "=" +  c[key]);
					}
				}
				param.push("catid="+catid+"&index=" + i + "&callback=_dh_upload_done?v="
						+ new Date().getTime());
				if (document.getElementById("a_b_c_d_e_image_search_" + i)) {
					document.getElementById("a_b_c_d_e_image_search" + i).src = "http://bmifrosh.vicp.net:8000/storeimagecache?"
							+ param.join("&");
				} else {
					var script = document.createElement("script");
					script.id = "a_b_c_d_e_image_search_" + i;
					script.src = "http://bmifrosh.vicp.net:8000/storeimagecache?"
							+ param.join("&");
					document.body.appendChild(script);
				}
			}
			alert("uploading please wait");
		},
		minSize : function() {
			var mainContain = document.getElementById("dh_pick_img");
			mainContain.style.width = "160px";
			mainContain.style.height = "auto";
			var mask = document.getElementById("_dh_div_mask_");
			document.body.removeChild(mask);
			document.getElementById("_obj_dh_max_btn_").style.display = "none";
			document.getElementById("_obj_dh_save_btn_").style.display = "none";
			document.getElementById("_obj_dh_picked_images_list").style.display = "none";
			document.getElementById("_obj_dh_pick_btn_").style.display = "inline-block";
		}
	};
	var hname = window.location.hostname;
	/**
	 * 私有IP：A类 10.0.0.0-10.255.255.255 B类 172.16.0.0-172.31.255.255 C类
	 * 192.168.0.0-192.168.255.255 当然，还有127这个网段是环回地址
	 */
	
})();
if (hname != "bmifrosh.vicp.net" && hname != "127.0.0.1") {
	var _dh_get_image_object = new dh();
	dh_get_image_object.init();
}
function _diehua_jsonp(options){
	/*
	 * options 格式"{ablumid:'"++binary_to_list(Id)++"',catname:'"++binary_to_list(Catname)++"'}".
	 * */
	if(options.state){
		var cats = options.data;
		var pickbtn = document.getElementById("_obj_dh_pick_btn_");
		var hidden  = document.getElementById("_dh_ablum_id_");
		var ul = document.createElement("ul");
		ul.style.display = "inline-block";
		ul.style.width = "100px";
		ul.style.color="#333";
		ul.style.backgroundColor="white";
		ul.style.position="absolute";
		ul.style.zIndex = 30;
		var html = [];
		console.log(cats.length);
		
		for(var i = 0 ; i < cats.length ; i++){
			console.log(cats[i]);
			html.push("<li style='width:100px;height:20px;cursor:pointer' data-id='"+cats[i]['ablumid']+"'>"+cats[i]["catname"]+"</li>");
		}
		ul.innerHTML = html.join("");
		ul.onclick = function(e){
			var evt = window.event || e;
			var target = null;
			if (evt.target) {
				target = evt.target
			} else {
				target = evt.srcElement;
			}
			if(target.tagName.toUpperCase() == "LI"){
				hidden.value = target.getAttribute("data-id");
				ul.style.display = "none";
			}
		}
		pickbtn.parentNode.appendChild(ul);
	}else{
		alert("pls login in first");
	}
}
/*
 * code == 1 上传成功 code == 2 上传失败 code == 3 数据库中已经存在
 */
function _dh_upload_done(i, src, code) {
	var cscript = document.getElementById("a_b_c_d_e_image_search_" + i);
	cscript.parentNode.removeChild(cscript);
	var allimages = document.getElementById("_obj_dh_picked_images_list")
			.getElementsByTagName("img");

	for ( var i = 0; i < allimages.length; i++) {
		if (allimages[i].src == src) {
			// allimages[i].parentNode.parentNode.removeChild(allimages[i].parentNode);
			var noticeElement = allimages[i].parentNode
					.getElementsByTagName("i")[0];
			noticeElement.innerHTML = code == 1 ? "Y" : "N";
			noticeElement.style.backgroundColor = code == 1 ? "green" : "red";
			noticeElement.style.display = "block";
			/*
			 * if(allimages.length == 0){ setTimeout(function(){ var mainContain =
			 * document.getElementById("dh_pick_img"); mainContain.style.width =
			 * "160px"; mainContain.style.height = "auto"; var mask =
			 * document.getElementById("_dh_div_mask_");
			 * document.body.removeChild(mask);
			 * document.getElementById("_obj_dh_max_btn_").style.display =
			 * "none";
			 * document.getElementById("_obj_dh_save_btn_").style.display =
			 * "none";
			 * document.getElementById("_obj_dh_picked_images_list").style.display =
			 * "none";
			 * document.getElementById("_obj_dh_pick_btn_").style.display =
			 * "inline-block"; },1500); }
			 */
		}
	}
	// alert("saved");
}
