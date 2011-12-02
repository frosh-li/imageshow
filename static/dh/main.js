/*
    图片抓取框的js代码  
    是一个弹出的侧栏窗口
    如果用户显示屏幕比较大的时候就将其显示在右侧，如果不够就显示小的toolbar在底部
*/
(function(){
    var dh = function(){
    	  this.mainContainer = null;
           };
    dh.prototype = {
			init:function(){
				this.drawPanel();
				this.getPageAllImages();
			},
			drawPanel:function(){
				//画出页面原型到页面中
				var newElement = document.createElement("div");
				newElement.id="dh_pick_img";
				newElement.setAttribute("style","position:absolute;position:fixed;width:200px;right:0px;top:0px;height:100%;margin:0px;padding:10px;background-color:white;border:1px solid #ccc");		
				//TODO 页面元素的处理
				document.body.appendChild(newElement);
				this.mainContainer = newElement;
			},
			getPageAllImages:function(){
				var allimages = document.getElementsByTagName("img");
				for(var i = 0 ; i < allimages.length ; i++){
					this.mainContainer.appendChild(allimages[i]);
				}
			}
            };
    var o = new dh();
	 o.init();
})();
