%% -*- mode: nitrogen -*-
-module (ajaxboards).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    wf:content_type("application/json"),
    Start = wf:q("start"),
    Boardsid = wf:q("boardid"),
    io:format("~p~n",[Start]),
    Startkey = wf:q("startkey"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),

	    {ok,Data} = couchbeam_view:fetch(Db,{"image","ablum_images"},[{limit,30},{skip,Start},{key,list_to_binary(Boardsid)}]),

	
	if Data == [] -> "{\"results\":[]}";
	    true ->
		JsonData = mochijson2:encode(Data),
		"{\"results\":"++JsonData++"}"
	end.
	%io:format("~p",[mochijson2:encode(Data)]).
	%mochijson2:encode(Data).
	%%insertToDb(Src,Title).
	

