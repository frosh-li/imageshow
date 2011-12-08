%% -*- mode: nitrogen -*-
-module (storeimagecache).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
	Src = wf:q("src"),
	Title = wf:q("title"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	[HT|AT] = couchbeam:get_uuid(Server),
	
	Doc = {[{<<"_id">>,HT},{<<"src">>, binary:list_to_bin(Src)},{<<"title">>,binary:list_to_bin(Title)}]},
	{ok, Doc1} = couchbeam:save_doc(Db, Doc),
	"saving".
	%%insertToDb(Src,Title).
	

