-module (login).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
    Email = wf:q("email"),
    Password = wf:q("password"),
    
    Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Mylist}=couchbeam_view:fetch(Db,{"user","all_user"}),
	io:format("~p~n",Mylist),
    M = check_login(Email,Password,Mylist),
    
    if M == "true" ->
        "登录成功";
       M == "1" -> "密码错误";
       M == "2" -> "username and password is empty";
	  true -> 
	        #template { file="./site/templates/login.html" }
	end.
    
    
check_login(Email,Password,[])-> "";

check_login(Email,Password,[H|T]) ->
    {[_,_,{_,{[_,_,{_,CEmail},{_,CPassword},_,_,_]}}]} = H,
    M = check_login_2(Email,Password,CEmail,CPassword),
    if M == "true" -> "true";
        true -> check_login(Email,Password,T)
    end.
check_login_2(Email,Password,CEmail,CPassword) ->
    New = {Email,Password},
    List_Email = binary_to_list(CEmail),
    List_Password = binary_to_list(CPassword),
    Old = {binary_to_list(CEmail),binary_to_list(CPassword)},
    Empty = {"",""},
    if New == Old -> "true";
       New == Empty -> "2";
        true -> "0"
    end.

