%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    wf:content_type("application/json"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Data} = couchbeam_view:fetch(Db,{"image","all_images"}),
	JsonData = mochijson2:encode(Data),
	"{\"results\":"++JsonData++"}".
	%io:format("~p",[mochijson2:encode(Data)]).
	%mochijson2:encode(Data).
	%%insertToDb(Src,Title).
	

