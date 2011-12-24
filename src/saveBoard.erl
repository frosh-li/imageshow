-module (saveBoard).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> 
	{CId,Email,CNick,CSpace,CAvatar} = commonheader:check_login(),
	Id = wf:q("catid"),
	Name = wf:q("catname"),
        Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	[HT|AT] = couchbeam:get_uuid(Server),
	Doc = {[{<<"_id">>,HT},{<<"catid">>,list_to_binary(Id)},{<<"catname">>,list_to_binary(Name)},{<<"userid">>,CId},{<<"table">>,<<"userablum">>}]},
        couchbeam:save_doc(Db, Doc),
        wf:content_type("application/json"),
        "{state:\"ok\"}".
