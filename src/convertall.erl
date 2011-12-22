%% -*- mode: nitrogen -*-
-module (convertall).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    %wf:content_type("image/jpeg"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	{ok,Mylist}=couchbeam_view:fetch(Db,{"image","all_images"}),

	member(Mylist),
	
	
	"".
	%io:format(Pic).
	
%%%	%%insertToDb(Src,Title).
	
%%checkSrcInDb(Src,Db) ->
    %%couchbeam_view:foreach(fun(Row)->{[{_,_},{_,Dsrc},{_,_}]} = Row,if Dsrc == <<"http://img3.u148.net/activity/article_right2.gif">> -> io:format("matched ~p~n",[Dsrc]); true->continue  end end,Db,{"image","all_src"}).


saveOne(Doc) ->
    io:format("~p~n",[Doc]),
    {[{_,Id},{_,_},{_,{[{_,_},{_,Src},_,{_,Ext}]}}]}=Doc,

	Reqs = ibrowse:send_req(binary_to_list(Src),[],get),

	case Reqs of
	    {ok,_,Header,Pic} -> 
	        %file:write_file("site/static/dhnetimage/"++binary_to_list(Id)++".jpg",Pic),
	        io:format("后缀名:~p~n",[Ext]),
	        file:write_file("site/static/dhnetimage/"++binary_to_list(Id)++binary_to_list(Ext),Pic),
	        os:cmd("convert site/static/dhnetimage/"++binary_to_list(Id)++binary_to_list(Ext)++" -thumbnail 192 site/static/dhnetimage/"++binary_to_list(Id)++"_s"++binary_to_list(Ext)),
	        Out = "save to "++binary_to_list(Id)++binary_to_list(Ext);
	    {error, Reason} -> Out = "can't get the picture , Reason is "++Reason
	end.
member([]) -> 
    "end";
member([H|T])->
    saveOne(H),
	member(T).

