-module (login).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
    Email = wf:q("email"),
    Password = wf:q("password"),
    
    Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Mylist}=couchbeam_view:fetch(Db,{"user","all_user"}),
    New = {Email,Password},
    io:format("user and password ~p~n",[New]),
    if New == {undefined,undefined} ->
    	#template { file="./site/templates/login.html",bindings=[{'Ecode',"0"}] };
    	true ->
    		M = check_login(Email,Password,Mylist),
    		case M of
	    	{"true",CId,CNick,CSpace,CAvatar} ->
	       	wf:session("userinfo",{CId,Email,CNick,CSpace,CAvatar}),
	       	%%wf:cookie(<<"Email">>, <<"junguoliang@163.com">>),
	       	wf:cookie("Userid", binary_to_list(CId),"/",525600),
	       	wf:redirect("/baiduimage");
		  True -> 
			#template { file="./site/templates/login.html",bindings=[{'Ecode',"1"}] }
		end
    end.
    
    
    
    
errorCode(T) ->
	case T of
	"1" -> Out = "用户名密码错误";
	"0" -> Out = "";
	"3"->Out = "用户名密码正确";
	Other ->Out =  ""
	end,
	Out.
	
check_login(Email,Password,[])-> "";

check_login(Email,Password,[H|T]) ->
    %{[_,_,{_,{[{_,CId},_,{_,CEmail},{_,CPassword},_,{_,CNick},{_,CSpace},{_,CAvatar},_]}}]} = H,
        {[_,_,{_,Row}]} = H,
        CEmail = couchbeam_doc:get_value(<<"email">>,Row),
        CId = couchbeam_doc:get_id(Row),
        CPassword = couchbeam_doc:get_value(<<"password">>,Row),
        CNick = couchbeam_doc:get_value(<<"nick">>,Row),
        CSpace = couchbeam_doc:get_value(<<"space">>,Row),
        CAvatar = couchbeam_doc:get_value(<<"avatar">>,Row),
        M = check_login_2(Email,Password,CEmail,CPassword),
        if M == "true" -> {"true",CId,CNick,CSpace,CAvatar};
            true -> check_login(Email,Password,T)
        end.
check_login_2(Email,Password,CEmail,CPassword) ->
    New = {Email,Password},
    List_Email = binary_to_list(CEmail),
    List_Password = binary_to_list(CPassword),
    Old = {binary_to_list(CEmail),binary_to_list(CPassword)},
    Empty = {"",""},
    case New of Old -> "true";
        Empty -> "0";
        True -> "1"
    end.

