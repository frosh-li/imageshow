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
	Size = wf:q("size"),
	Ext = wf:q("ext"),
	Catid = wf:q("catid"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	{ok,Mylist}=couchbeam_view:fetch(Db,{"image","all_src"}),
	M = member(Src,Mylist),
	if M == true ->
	   "_dh_upload_done(\""++Index++"\",'"++Src++"','3')";
	   true -> 
		Reqs = ibrowse:send_req(Src,[],get),
		case Reqs of
		    {ok,_,Header,Pic} -> 
		    	Extx = readExt(Header),
		    case Extx of
		        ".jpg" -> TT = save_to_db_thumb(Extx,Pic,Src,Db,Title,Server,Catid,Size);
		        ".png" -> TT = save_to_db_thumb(Extx,Pic,Src,Db,Title,Server,Catid,Size);
		        ".gif" -> TT = save_to_db_thumb(Extx,Pic,Src,Db,Title,Server,Catid,Size);
		        Other -> TT = "2"
		    end;
		    {error, Reason} -> TT = "2"
		end,
            "_dh_upload_done(\""++Index++"\",'"++Src++"',"++TT++")"
	end.
    

save_to_db_thumb(Extx,Pic,Src,Db,Title,Server,Catid,Size) ->
            [HT|AT] = couchbeam:get_uuid(Server),
            OHeight = list_to_integer(string:right(Size,string:len(Size)-string:str(Size,"*"))),
            io:format("old Height is ~p~n",[OHeight]),
            TT  = OHeight * 192 / list_to_integer(string:left(Size,string:str(Size,"*")-1)),
            io:format("float height is ~p~n",[TT]),
            Height = round(TT),
            io:format("height is ~p~n",[Height]),
            Doc = {[{<<"_id">>,HT},{<<"src">>, binary:list_to_bin(Src)},{<<"title">>,binary:list_to_bin(Title)},{<<"ext">>,<<"noinput">>},{<<"ablumid">>,binary:list_to_bin(Catid)},{<<"height">>,list_to_binary(integer_to_list(Height))},{<<"table">>,<<"images">>}]},
            {ok,SavedDoc} = couchbeam:save_doc(Db, Doc),
file:write_file("site/static/dhnetimage/"++binary_to_list(HT)++Extx,Pic),
			os:cmd("convert site/static/dhnetimage/"++binary_to_list(HT)++Extx++" -thumbnail 192 site/static/dhnetimage/"++binary_to_list(HT)++"_s"++Extx),
		        %%% update ext area
		        couchbeam:save_doc(Db,couchbeam_doc:extend(<<"ext">>,list_to_binary(Extx),SavedDoc)),
		        "1".    
    
rOne(H)->
	case H of
	{"Content-Type","image/jpeg"} -> X=".jpg";
	{"Content-Type","image/gif"} -> X=".gif";
	{"Content-Type","image/png"} -> X=".png";
	Other -> X=""
	end,
	X.

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
