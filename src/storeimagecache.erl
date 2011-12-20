%% -*- mode: nitrogen -*-
-module (storeimagecache).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    wf:content_type("text/javascript"),
	Src = wf:q("src"),
	Title = wf:q("title"),
	Index = wf:q("index"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	{ok,Mylist}=couchbeam_view:fetch(Db,{"image","all_src"}),
	M = member(Src,Mylist),
	if M == true ->
	   "done(\""++Index++"\")";
	   true -> 
	        [HT|AT] = couchbeam:get_uuid(Server),
            Doc = {[{<<"_id">>,HT},{<<"src">>, binary:list_to_bin(Src)},{<<"title">>,binary:list_to_bin(Title)}]},
            {ok, Doc1} = couchbeam:save_doc(Db, Doc),
            "done(\""++Index++"\")"
	    
	end.
    
%%%	%%insertToDb(Src,Title).
	
%%checkSrcInDb(Src,Db) ->
    %%couchbeam_view:foreach(fun(Row)->{[{_,_},{_,Dsrc},{_,_}]} = Row,if Dsrc == <<"http://img3.u148.net/activity/article_right2.gif">> -> io:format("matched ~p~n",[Dsrc]); true->continue  end end,Db,{"image","all_src"}).


member(Key, List)->
	member(Key, List, []).
member(_Key, _List, true)->
	true;
member(_Key, [], Re)->
	Re;
member(Key, [H|T], Ret) ->
	{[_Id,{_Key,Url},_]}=H,
	Re = binary_to_list(Url) =:= Key,
	member(Key, T, Re).
