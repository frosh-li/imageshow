-module (viewboards).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->

	Session = wf:session("userinfo"),
	if Session == 'undefined' -> wf:redirect("/baiduimage");
            true ->	
        {Userid,Email,Nickname,_,_} = Session,
	Ablumid = wf:q("id"),
	io:format("Session is ~p~n",[Session]),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	case couchbeam_view:fetch(Db, {"image","ablum_images"},[{key,Ablumid}]) of
		{ok,M} ->
			%
			%arg1 为nickname
			%	arg2为id	
			% arg4为template 名称
			%
			Tp = "selecte_cat.html",
			#template { file="./site/templates/viewboards.html",bindings = [{'Arg1',Nickname},{'Arg2',list_to_binary(Ablumid)},{'Arg3',Email},{'Arg4',Userid}]};
		Oter -> wf:redirect("/baiduimage")
	 end
	end.
get_ablum_name(Ablumid) ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Row} = couchbeam_view:first(Db, {"userablum","list_all"},[{key,Ablumid}]),
	{[_,_,{_,{[_,_,_,{_,Catname},_,_]}}]}  = Row,
	binary_to_list(Catname).
	
get_ablum_images(Ablumid) ->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Lists} = couchbeam_view:fetch(Db, {"image","ablum_images"},[{key,Ablumid}]),
	Array = array:from_list(Lists),
	Counts = array:size(Array),
	integer_to_list(Counts).
%%获取所有画版
list_table(Userid)->
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,M} = couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Userid}]),
	Out = list_all(M),
	Out.

get_c_ablum(H)->
	{[_,_,{_,{[{_,Id},_,{_,Catid},{_,Catname},{_,Userid},_]}}]} = H,
	"<a href=\"/viewboards?id="++binary_to_list(Id)++"\">"++binary_to_list(Catname)++"<span class=\"stats\">"++get_ablum_images(Id)++"</span></a>".
	
list_all([]) -> "";
list_all([H|T]) ->
      get_c_ablum(H)++list_all(T).
 get_c_ablum_image(H)->
 	{[_,_,{_,{[{_,Title},{_,Src},{_,Id},{_,Ext},{_,Ablumid}]}}]} = H,
 	 "<img src=\"/dhnetimage/"++binary_to_list(Id)++"_s"++binary_to_list(Ext)++"\">".	
 	
get_ablum_list([]) -> "";
get_ablum_list([H|T]) ->
      get_c_ablum_image(H)++get_ablum_list(T).

%% 获取ablum数据
get_ablum_count(Id) ->
	io:format("userid is ~p~n",[Id]),
	Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	{ok,Lists}= couchbeam_view:fetch(Db, {"userablum","list_all_userid"},[{key,Id}]),
	Array = array:from_list(Lists),
	Counts = array:size(Array),
	integer_to_list(Counts).
%% 获取某个用户所有的图片数量
get_image_count(Userid) ->
	io:format("userid is"),
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
	{ok,Countlist} = couchbeam_view:fetch(Db, {"image","ablum_images"},[{key,Id}]),
	Array = array:from_list(Countlist),
	Counts = array:size(Array),
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
	{[{_,Id},_,{_,Catname}]} = H,
	{ok,Templates} = file:read_file("site/templates/test.html"),
	%.
	"<li class=\"BoardCategory\" data=\""++binary_to_list(Id)++"\">"++
	"<span>"++binary_to_list(Catname)++"</span>"++
	"</li>".

list_cate([],Tpl)->"";	
list_cate([H|T],Tpl) ->
	read_tpl(H,Tpl) ++ list_cate(T,Tpl).	
