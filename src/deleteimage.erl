-module(deleteimage).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
        wf:content_type("application/json"),
	Session = wf:session("userinfo"),
	if Session == 'undefined' -> wf:redirect("/baiduimage");
            true ->	
            {Userid,Email,Nickname,_,_} = Session,
	    Imageid = wf:q("imageid"),
	    Rev = wf:q("rev"),
	    Ext = wf:q("ext"),
	    Server = couchbeam:server_connection("localhost", 5984, "", []),
	    {ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	    case couchbeam:open_doc(Db,list_to_binary(Imageid),[{"include_docs",true}]) of
	        {ok,Row} ->
	                {[{_,RowId},{_,RowRev},_,_,{_,RowExt},{_,Ablumid},{_,TableType}]} = Row,
	                if TableType =/= <<"images">> -> MOut = "{\"state\":false}";
	                    true ->
	                    %% 查询数据库ablum
	                        case couchbeam:open_doc(Db,Ablumid,[{"include_docs",true}]) of
	                                {ok,ARow} ->
	                                         {[_,_,_,_,{_,CheckUserid},_]} = ARow,
	                                         if CheckUserid ==Userid -> %%一切OK，可以删除
	                                                Doc = {[{<<"_id">>,list_to_binary(Imageid)},{<<"_rev">>,RowRev}]},
	                                                couchbeam:delete_doc(Db,Doc),
	                                                Filename = "site/static/dhnetimage/"++Imageid++binary_to_list(RowExt),
		                                        SFilename = "site/static/dhnetimage/"++Imageid++"_s"++binary_to_list(RowExt),
		                                        io:format("~p~n",[Filename]),
		                                        file:delete(Filename),
		                                        file:delete(SFilename),
	                                            
	                                            MOut ="{\"state\":true}";
	                                         true ->MOut=  "{\"state\":false}"
	                                         end; 
	                                _-> MOut = "{\"state\":false}"
	                        end
	                end;
	        _->MOut ="{\"state\":false}"
	    end,
            MOut
        end.
        
