-module (baiduimage).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
	Session = wf:session("email"),
	#template { file="./site/templates/baiduimage.html",bindings=[{'Session',Session}] }.
	
	
userinfo(Session) ->
	case Session of
		'undefined' -> Out = "not login<a href='/login'>登录</a>";
		Other -> Out = "your email is "++Session++" <a href='/logout'>退出登录</a>"
	end,
	Out.
