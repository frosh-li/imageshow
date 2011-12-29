-module (commonheader).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
	"".
	
get_header()->
	#template { file="./site/templates/commonheader.html"}.	
userinfo() ->
	Session = wf:session("userinfo"),
	io:format("Session is ~p~n",[Session]),
	case Session of
		'undefined' -> Out = "<li><a class=\"nav no-icon\" href=\"/login/\">登录</a></li>"
		                       ++"<li><a class=\"nav\" href=\"/register/\">注册</a></li>";
		{CId,Email,CNick,CSpace,CAvatar} -> Out = "<li id=\"user_nav\"><a class=\"nav\" href=\"/space?sid="++binary_to_list(CId)++"\"><img src=\"/images/noavatar.gif\" />"++binary_to_list(CNick)++"<span></span></a><ul><li><a href=\"/space?sid="++binary_to_list(CId)++"\">画板</a></li><li><a href=\"/frosh/pins/\">采集</a></li><li><a href=\"/frosh/likes/\">喜欢</a></li><li class=\"divider\"><a href=\"/invites\">邀请&amp;查找好友</a></li><li class=\"divider\"><a href=\"/settings/\">帐号设置</a></li><li><a href=\"/logout/\">退出登录</a></li></ul></li>	";
		Other -> Out ="<li><a class=\"nav no-icon\" href=\"/login/\">登录</a></li>"
		                ++"<li><a class=\"nav\" href=\"/register/\">注册</a></li>"
	end,
	Out.
	
check_login()->
	Session = wf:session("userinfo"),
	case Session of
		'undefined' -> Out =wf:redirect("/login");
		{CId,Email,CNick,CSpace,CAvatar} -> Out = {CId,Email,CNick,CSpace,CAvatar}
	end,
	Out.

redirect_session_login() ->
	Session = wf:session("userinfo"),
	if Session == 'undefined' -> wf:redirect("/login"),wf:flush();
	    true -> ""
	end.
