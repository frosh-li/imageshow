-module (loginstate).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
    check_login_js().
check_login_js() ->
    wf:content_type("application/json"),
    Session = wf:session("userinfo"),
    case Session of
        'undefined' -> Out ="{state:false}";
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