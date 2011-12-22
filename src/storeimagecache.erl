%% -*- mode: nitrogen -*-
-module (storeimagecache).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    wf:content_type("text/javascript"),
	Src = wf:q("src"),
	Title = wf:q("title"),
	Index = wf:q("index"),
	Callback = wf:q("callback"),
	Ext = wf:q("ext"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	{ok,Mylist}=couchbeam_view:fetch(Db,{"image","all_src"}),
	M = member(Src,Mylist),
	if M == true ->
		io:format("not save pic ~n"),
	   "_dh_upload_done(\""++Index++"\",'"++Src++"')";
	   true -> 
	        [HT|AT] = couchbeam:get_uuid(Server),
            Doc = {[{<<"_id">>,HT},{<<"src">>, binary:list_to_bin(Src)},{<<"title">>,binary:list_to_bin(Title)},{<<"ext">>,binary:list_to_bin(Ext)}]},
            {ok, {[_,_,_,_,{_,Rev}]}} = couchbeam:save_doc(Db, Doc),
              

		Reqs = ibrowse:send_req(Src,[],get),
                io:format("ok ~p~n",[Src]),
		case Reqs of
		    {ok,_,Header,Pic} -> 
		    	Extx = readExt(Header),
			file:write_file("site/static/dhnetimage/"++binary_to_list(HT)++Extx,Pic),
			os:cmd("convert site/static/dhnetimage/"++binary_to_list(HT)++Extx++" -thumbnail 192 site/static/dhnetimage/"++binary_to_list(HT)++"_s"++Extx),
		        %%% update ext area
		        couchbeam:save_doc(Db, {[{<<"_id">>,HT},{<<"src">>, binary:list_to_bin(Src)},{<<"title">>,binary:list_to_bin(Title)},{<<"ext">>,binary:list_to_bin(Extx)},{<<"_rev">>,Rev}]}),
		        io:format("~p~n",[Extx]),
			Out = "save to "++binary_to_list(HT)++Extx;
		    {error, Reason} -> Out = "can't get the picture , Reason is "++Reason
		end,
            "_dh_upload_done(\""++Index++"\",'"++Src++"')"
	end.
    
rOne(H)->
	case H of
	{"Content-Type","image/jpeg"} -> ".jpg";
	{"Content-Type","image/gif"} -> ".gif";
	{"Content-Type","image/png"} -> ".png";
	Other -> ""
	end.

readExt([]) -> "";
readExt([H|T]) ->
	rOne(H)++readExt(T).


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
