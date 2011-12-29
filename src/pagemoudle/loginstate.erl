-module (loginstate).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
    check_login_js().
check_login_js() ->
    wf:content_type("application/json"),
    Session = wf:session("userinfo"),
    case Session of
        'undefined' -> 
            %%如果session失效，判断cookie是否可以登录
            Cookie_userid = wf:cookie("Userid"),
            if Cookie_userid == 'undefined' -> Out = "{state:false}";
               true ->
                    Server = couchbeam:server_connection("localhost", 5984, "", []),
                    {ok, Db} = couchbeam:open_db(Server, "image_cache", []),
                    case couchbeam:open_doc(Db,list_to_binary(Cookie_userid),[{"include_docs",true}]) of
                        {ok,Row} -> {[{_,Co_id},_,{_,Co_avatar},{_,Co_email},{_,Co_nick},_,_,{_,Co_space},_]} = Row,
                                    Server = couchbeam:server_connection("localhost", 5984, "", []),
                                    {ok, Db} = couchbeam:open_db(Server, "image_cache", []),
                                    {ok,M} = couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Co_id}]),
                                    Data = list_all(M),
                                    Len = string:len(Data)-1,
                                    CData = string:left(Data,Len ),
                                    Out ="{state:true,data:["++CData++"]}";
                        _ -> Out = "{state:false}"
                    end
               
            end;
        {CId,Email,CNick,CSpace,CAvatar} ->
            Server = couchbeam:server_connection("localhost", 5984, "", []),
            {ok, Db} = couchbeam:open_db(Server, "image_cache", []),
            {ok,M} = couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,CId}]),
            Data = list_all(M),
            Len = string:len(Data)-1,
            CData = string:left(Data,Len ),
            Out ="{state:true,data:["++CData++"]}"
    end,
    "_diehua_jsonp("++Out++")".

get_c_ablum(H)->
    {[_,_,{_,{[{_,Id},_,{_,Catid},{_,Catname},{_,Userid},_]}}]} = H,
    TT = binary_to_list(Catname),
    io:format("~p~n",[TT]),
   "{ablumid:'"++binary_to_list(Id)++"',catname:'"++binary_to_list(Catname)++"'}".
list_all([]) -> "";
list_all([H|T]) ->
      get_c_ablum(H)++","++list_all(T).
