-module (space).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
	Session = wf:session("userinfo"),
	if Session == 'undefined' -> wf:redirect("/baiduimage");
            true ->	
	Id = wf:q("sid"),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	case couchbeam:open_doc(Db, list_to_binary(Id)) of
		{ok,M} ->
			%{[_,_,{_,Email},{_,_},{_,Role},{_,Nickname},_,_,_]}  = M,
			Email = couchbeam_doc:get_value(<<"email">>,M),
			Role = couchbeam_doc:get_value(<<"role">>,M),
			Nickname = couchbeam_doc:get_value(<<"nick">>,M),
			%
			%arg1 为nickname
			%	arg2为id	
			% arg4为template 名称
			%
			Tp = "selecte_cat.html",
			#template { file="./site/templates/space.html",bindings = [{'Arg1',Nickname},{'Arg2',list_to_binary(Id)},{'Arg3',Email},{'Arg4',Tp}]};
		Oter -> wf:redirect("/baiduimage")
	 end
	end.
	
%%获取所有画版
list_table(Userid)->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,M} = couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Userid}]),
	Out = list_all(M),
	Out.

get_c_ablum(H)->
	{[_,_,{_,{[{_,Id},_,{_,Catid},{_,Catname},{_,Userid},_]}}]} = H,
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,M} = couchbeam_view:fetch(Db, {"image","ablum_images"},[{key,Id},{limit,9}]),
	%{ok,Catrow}  = couchbeam:open_doc(Db,Catid,[{"include_docs",true}]),
	 % {[{_,CatrowId},{_,CatrowRev},{_,CatrowName},{_,CatrowTable}]} = Row,
	Imgtags = get_ablum_list(M),
	"<li><div data-id=\""++binary_to_list(Id)++"\" data-seq=\"1\" class=\"Board wfc\"><div class=\"draglay\"></div><h3>"++binary_to_list(Catname)++"</h3><a href=\"/viewboards?id="++binary_to_list(Id)++"\" class=\"link\">"++Imgtags++"</a><div class=\"FollowBoard\"><a href=\"/boards/edit?id="++binary_to_list(Id)++"\" class=\"btn btn13 wbtn\"><strong>编辑</strong><span></span></a></div></div></li>".
list_all([]) -> "";
list_all([H|T]) ->
      get_c_ablum(H)++list_all(T).
 get_c_ablum_image(H)->
 	%{[_,_,{_,{[{_,Title},{_,Src},{_,Id},{_,Ext},{_,Ablumid}]}}]} = H,
 	{[_,_,{_,{[{_,Title},{_,Src},{_,Id},{_,Ext},_,{_,Ablumid}]}}]} = H,
 	 "<img src=\"/dhnetimage/"++binary_to_list(Id)++"_s"++binary_to_list(Ext)++"\">".	
 	
get_ablum_list([]) -> "";
get_ablum_list([H|T]) ->
      get_c_ablum_image(H)++get_ablum_list(T).

%% 获取ablum数据
get_ablum_count(Id) ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Lists}= couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Id}]),
	Array = array:from_list(Lists),
	Counts = array:size(Array),
	integer_to_list(Counts).
%% 获取某个用户所有的图片数量
get_image_count(Userid) ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Lists} = couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Userid}]),
	Counts = get_image_counts_list(Lists),
	integer_to_list(Counts).
	
get_image_counts_list([]) -> 0;
get_image_counts_list([H|T]) ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{[_,_,{_,{[{_,Id},_,_,_,_,_]}}]} = H,
	%%Id = couchbeam_doc:get_id(H),
	{ok,Countlist} = couchbeam_view:fetch(Db, {"image","ablum_images"},[{key,Id}]),
	Array = array:from_list(Countlist),
	Counts = array:size(Array),
	io:format("~p~n",[Counts]),
	Counts + get_image_counts_list(T).
     	
%% 获取各种信息 
get_info(Key)->
	binary_to_list(Key).	
	
%%获取分类列表
get_cat_list(Tpl)->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,M} = couchbeam_view:fetch(Db, {"cat","all_cat"}),
	
	Templates = list_cate(M,Tpl),
	Templates.
	
read_tpl(H,Tpl) -> 
	{[{_,Id},_,{_,Catname}]} = H,%{[_,_,{_,{[{_,Title},{_,Src},{_,Id},{_,Ext},{_,Ablumid}]}}]} = H,
	"<li class=\"BoardCategory\" data=\""++binary_to_list(Id)++"\">"++
	"<span>"++binary_to_list(Catname)++"</span>"++
	"</li>".

list_cate([],Tpl)->"";	
list_cate([H|T],Tpl) ->
	read_tpl(H,Tpl) ++ list_cate(T,Tpl).	
