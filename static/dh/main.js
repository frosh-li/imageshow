/*
    图片抓取框的js代码  
    是一个弹出的侧栏窗口
    如果用户显示屏幕比较大的时候就将其显示在右侧，如果不够就显示小的toolbar在底部
*/
(function(){
    var dh = function(){
    	  this.mainContainer = null;
   	  this.pickBtn = null;
           };
   dh.setFloatStyle=function(obj,style) 
	{
	   var sty=obj.style;  
	   if('cssFloat' in sty){  
	      obj.style.cssFloat=style;  
	   }else if('styleFloat' in sty){  
	      obj.style.styleFloat=style;  
	   }else{  
	      throw 'set float style:'+style+'error.';  
	   }  
	}
    dh.prototype = {
			init:function(){
				this.drawPanel();
				this.getPageAllImages();
			},
			drawPanel:function(){
				//画出页面原型到页面中
				var newElement = document.createElement("div");
				newElement.id="dh_pick_img";
				newElement.setAttribute("style","-moz-box-shadow:inset 0 -200px 100px #032b5c,inset -100px 100px 100px #2073b5,inset 100px 200px 100px #1f9bb1;-webkit-box-shadown:inset 0 -200px 100px #032b5c,inset -100px 100px 100px #2073b5,inset 100px 200px 100px #1f9bb1;box-shadow:inset 0 -200px 100px #032b5c,inset -100px 100px 100px #2073b5,inset 100px 200px 100px #1f9bb1;position:fixed;width:230px;right:0px;top:0px;height:100%;overflow-x:hidden;overflow-y:scroll;margin:0px;padding:10px;background-color:white;border:1px solid #ccc;z-index:999999;");
				newElement.innerHTML = '<div style="text-align: center;"><span id="_obj_dh_pick_btn_" style="color: rgb(102, 102, 102); font-size: 20px; display:block; text-shadow: rgba(0, 0, 0, 0.292969) 0px 1px 1px; border-top-left-radius: 0.5em 0.5em; border-top-right-radius: 0.5em 0.5em; border-bottom-right-radius: 0.5em 0.5em; border-bottom-left-radius: 0.5em 0.5em; padding-top: 0.5em; padding-right: 2em; padding-bottom: 0.55em; padding-left: 2em; -webkit-box-shadow: rgba(0, 0, 0, 0.199219) 0px 1px 2px; box-shadow: rgb(48, 27, 41) 3px 2px 31px; background-color: white; cursor: pointer; position: relative; top: 0px; opacity: 0.9; " onmouseover="this.style.opacity=1;" onmouseout="this.style.opacity=0.9" onmousedown="this.style.top=\'1px\'" onmouseup="this.style.top=\'0px\'">'+"\u6293\u53d6\u672c\u9875\u56fe\u7247"+'</span><span id="_obj_dh_save_btn_" style="color: rgb(102, 102, 102); font-size: 20px; display:block; text-shadow: rgba(0, 0, 0, 0.292969) 0px 1px 1px; border-top-left-radius: 0.5em 0.5em; border-top-right-radius: 0.5em 0.5em; border-bottom-right-radius: 0.5em 0.5em; border-bottom-left-radius: 0.5em 0.5em; padding-top: 0.5em; padding-right: 2em; padding-bottom: 0.55em; padding-left: 2em; -webkit-box-shadow: rgba(0, 0, 0, 0.199219) 0px 1px 2px; box-shadow: rgb(48, 27, 41) 3px 2px 31px; background-color: white; cursor: pointer; position: relative;margin-top:15px; top: 0px; opacity: 0.9; " onmouseover="this.style.opacity=1;" onmouseout="this.style.opacity=0.9" onmousedown="this.style.top=\'1px\'" onmouseup="this.style.top=\'0px\'">'+"\u4e0a\u4f20"+'</span></div><div id="_obj_dh_picked_images_list" style="margin-top: 14px;background: yellow;border-radius: 8px;padding: 10px 0;"></div>';
				//TODO 页面元素的处理
				var me = this;
				document.body.appendChild(newElement);
				this.mainContainer = newElement;
				this.pickBtn = document.getElementById("_obj_dh_pick_btn_");
				this.pickBtn.onclick = function(){me.startToPick(me)};
			},
			startToPick:function(me){
				var tpl = "<img src='${src}' style='width:80px;' /><span>${title}</span><em>size:${size}</em>";
				var allimages = document.getElementsByTagName("img"),
					 pageTitle = document.getElementsByTagName("title")[0].innerHTML,
					 htmlCode = [],
					 aData = [];
				var targetElement = document.getElementById("_obj_dh_picked_images_list");
				console.log(allimages.length);
				for(var i = 0 ; i < allimages.length ; i++){
					var cImg = allimages[i];
					if(parseInt(cImg.width) < 300){
						continue;
					}
					var cAlt = cImg.getAttribute("alt"),
					 	 cTitle = cImg.getAttribute("title"),
					 	 cSrc = cImg.getAttribute("src"),
					 	 size = cImg.width + "*" + cImg.height;
						 rTitle = cAlt!="" && cAlt != null?cAlt:(cTitle!="" && cTitle != null?cTitle:"无标题");
						 
						 var newImage = new Image();
						 newImage.src = cSrc;
						 cSrc = newImage.src;
						 delete newImage;
						 
						 var cElement = document.createElement("div");
						 
						 
						 //dh.setFloatStyle(cElement,"left");
						 cElement.style.width = "85px";
						 cElement.style.color="white";
						 cElement.style.width = "90%";
						 cElement.style.color = "#333";
						 cElement.style.margin = "10px auto";
						 cElement.style.lineHeight = "18px";
						 cElement.innerHTML = "<img src='"+cSrc+"' style='width: 100%;box-shadow: 0 0  10px red;' /><span style='display:block;'>"+rTitle+"</span><em>size:"+size+"</em>";
						 console.log(cElement);
						 htmlCode.push(cElement);
						 aData.push({title:rTitle,src:cSrc,size:size});
				}
				for(var i = 0 ; i< htmlCode.length ;i++){
					targetElement.appendChild(htmlCode[i]);
				}
				console.log(aData);
				me.ajaxPost(aData);
			},
			getPageAllImages:function(){
				var allimages = document.getElementsByTagName("img");
				for(var i = 0 ; i < allimages.length ; i++){
					//this.mainContainer.appendChild(allimages[i]);
				}
			},
			ajaxPost:function(obj){
				console.log(obj.length);
				if(obj.length == 0){
					return;
				}
				for(var i = 0 ; i < obj.length ; i++){
				    var c = obj[i],param = [];
				    var host = window.location.origin;
				    //if(c.src.indexOf(host) != 0){
				    //	c.src = escape(host + "/" + c.src);
				    //}
				    //c.title = escape(c.title);
				    for(var key in c){
					    param.push(key+"="+c[key]);
				    }
				    param.push("index="+i+"&callback=done?v="+new Date().getTime());
				    if(document.getElementById("a_b_c_d_e_image_search_"+i)){
					    document.getElementById("a_b_c_d_e_image_search").src = "http://bmifrosh.vicp.net:8000/storeimagecache?"+param.join("&");
				    }else{
					    var script = document.createElement("script");
					    script.id = "a_b_c_d_e_image_search_"+i;
					    script.src="http://bmifrosh.vicp.net:8000/storeimagecache?"+param.join("&");
					    document.body.appendChild(script);
				    }
				}
				alert("uploaded");
			}
            };
    var o = new dh();
	 o.init();
})();
function done(i){
	document.getElementById("a_b_c_d_e_image_search_"+i).remove();
	//alert("saved");
}
