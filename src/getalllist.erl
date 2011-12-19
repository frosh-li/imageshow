%% -*- mode: nitrogen -*-
-module (getalllist).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
	
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,V} = couchbeam:all_docs(Db),
	M = couchbeam_oldview:fetch(V),
	%couchbeam_oldview:foreach(V,viewall(Elem)),
	{ok,{A}} = M,
	mochijson2:encode(A),
	couchbeam_oldview:foreach(V,fun(Elem)->{[{_,Id},_,_]}=Elem, Clist = couchbeam:open_doc(Db,binary_to_list(Id)),io:format("~p",[Clist]) end).      
