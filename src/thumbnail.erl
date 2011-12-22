%% -*- mode: nitrogen -*-
-module (thumbnail).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() ->
    %wf:content_type("image/jpeg"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	
	{ok,Mylist}=couchbeam_view:fetch(Db,{"image","all_images"}),

	Out = member(Mylist),
	
	
	integer_to_list(Out).
	
%%%	%%insertToDb(Src,Title).
	
%%checkSrcInDb(Src,Db) ->
    %%couchbeam_view:foreach(fun(Row)->{[{_,_},{_,Dsrc},{_,_}]} = Row,if Dsrc == <<"http://img3.u148.net/activity/article_right2.gif">> -> io:format("matched ~p~n",[Dsrc]); true->continue  end end,Db,{"image","all_src"}).


saveOne(Doc) ->
    
    {[{_,Id},{_,_},{_,{[{_,_},{_,Src},_,{_,Ext}]}}]}=Doc,
	T = os:cmd("convert site/static/dhnetimage/"++binary_to_list(Id)++Ext++" -thumbnail 192 site/static/dhnetimage/"++binary_to_list(Id)++"_s"++Ext),
	io:format("~p~n",[T]),
	case T of
	    [] -> 
	        1;
	    Other -> 0
	end.
member([]) -> 
    0;
member([H|T])->
    saveOne(H)+member(T).	
