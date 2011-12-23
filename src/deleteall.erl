%% -*- mode: nitrogen -*-
-module (deleteall).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	couchbeam_view:foreach(
	fun(Row)->
		{[{_,Id},_,{_,[Rev,Ext]}]} = Row,
		Doc = {[{<<"_id">>,Id},{<<"_rev">>,Rev}]},
		couchbeam:delete_doc(Db,Doc),
		Filename = "site/static/dhnetimage/"++binary_to_list(Id)++binary_to_list(Ext),
		SFilename = "site/static/dhnetimage/"++binary_to_list(Id)++"_s"++binary_to_list(Ext),
		io:format("~p~n",[Filename]),
		file:delete(Filename),
		file:delete(SFilename),
		io:format("~p~n",[Row]) 
	end
	,Db,{"image","all_fordelete"}),
	%%io:format("~p~n",[Mylist]),
	"".
    
rOne(H)->
	case H of
	{"Content-Type","image/jpeg"} -> ".jpg";
	{"Content-Type","image/gif"} -> ".gif";
	{"Content-Type","image/png"} -> ".png";
	Other -> ""
	end.


