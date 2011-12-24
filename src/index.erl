%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    wf:content_type("application/json"),
    Start = wf:q("start"),
    io:format("~p~n",[Start]),
    Startkey = wf:q("startkey"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),

	    {ok,Data} = couchbeam_view:fetch(Db,{"image","all_images"},[{limit,30},{skip,Start}]),

	
	if Data == [] -> "{\"results\":[]}";
	    true ->
		JsonData = mochijson2:encode(Data),
		"{\"results\":"++JsonData++"}"
	end.
	%io:format("~p",[mochijson2:encode(Data)]).
	%mochijson2:encode(Data).
	%%insertToDb(Src,Title).
	

