-module (register).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
-define(USER_DOC , {[
    {<<"_id">>,<<"null">>},
    {<<"_rev">>,<<"null">>},
    {<<"nick">>,<<"null">>},
    {<<"realname">>,<<"null">>},
    {<<"email">>,<<"null">>},
    {<<"sex">>,<<"null">>},
    {<<"avatar">>,<<"null">>},
    {<<"lbsinfo">>,<<"null">>},
    {<<"contract">>,<<"null">>},
    {<<"intro">>,<<"null">>},
    {<<"liketags">>,<<"null">>},
    {<<"friends">>,<<"null">>},
    {<<"likeuid">>,<<"null">>},
    {<<"belikeduid">>,<<"null">>},
    {<<"score">>,<<"null">>},
    {<<"group">>,<<"null">>},
    {<<"private">>,<<"null">>},
    {<<"registerdate">>,<<"null">>},
    {<<"registerip">>,<<"null">>},
    {<<"lastlogin">>,<<"null">>},
    {<<"table">>,<<"user">>}
]}).

        
main()->
    Ip = get_client_ip(),
    Email = wf:q("email"),
    Password = wf:q("password"),
    Nickname = wf:q("nickname"),
    Server = couchbeam:server_connection("localhost", 5984, "", []),
	{ok, Db} = couchbeam:open_db(Server, "image_cache", []),
	NewSession = {Email,Password,Nickname},
	io:format("New user is ~p~n",[NewSession]),
	case NewSession of
	    {undefined,undefined,undefined}
	        ->  #template { file="./site/templates/register.html",bindings=[{'Ecode',"0"}] };
	    _   -> 

	            case couchbeam_view:first(Db,{"user","email"},[{key,list_to_binary(Email)}]) of
	               {ok,_}  ->
	                    io:format("this is a new user~n"),
	                    #template { file="./site/templates/register.html",bindings=[{'Ecode',"1"}] };
	                _ ->
	                    io:format("can be register~n"),
	                    X1 = couchbeam_doc:set_value(<<"email">>,list_to_binary(Email),?USER_DOC),
                        X2 = couchbeam_doc:set_value(<<"nick">>,list_to_binary(Nickname),X1),
                        X3 = couchbeam_doc:set_value(<<"password">>,list_to_binary(Password),X2),
                        X4 = couchbeam_doc:set_value(<<"registerip">>,list_to_binary(Ip),X3),
                        X5 = couchbeam_doc:delete_value(<<"_id">>,X4),
                        X6 = couchbeam_doc:delete_value(<<"_rev">>,X5),
                        
                        case couchbeam:save_doc(Db,X6) of
                            {ok,SaveSuccess} ->
                                io:format("User Doc is ~p~n",[SaveSuccess]),
                                wf:session("userinfo",{
                                    couchbeam_doc:get_value(<<"_id">>,SaveSuccess),
                                    binary_to_list(couchbeam_doc:get_value(<<"email">>,SaveSuccess)),
                                    couchbeam_doc:get_value(<<"nick">>,SaveSuccess),
                                    couchbeam_doc:get_value(<<"space">>,SaveSuccess),
                                    couchbeam_doc:get_value(<<"avatar">>,SaveSuccess)
                                    }),
                                wf:cookie("Userid", binary_to_list(couchbeam_doc:get_value(<<"_id">>,SaveSuccess)),"/",525600),
                                wf:redirect("/baiduimage");
                            _->
                                #template { file="./site/templates/register.html",bindings=[{'Ecode',"3"}] }
                        end
	            end
                
	end.
    
    
get_client_ip()->
    Request = wf_context:request_bridge(),
    Headers = Request:headers(),
    IPAddress = lists:keyfind(x_real_ip,1,Headers),
    case IPAddress of
        {x_real_ip,IP} -> IP;
        _ -> "0.0.0.0"
    end.
    
    
errorCode(T) ->
	case T of
	"1" -> Out = "Email已经被注册了";
	"0" -> Out = "";
	"3"->Out = "注册失败";
	_ ->Out =  ""
	end,
	Out.
	
check_login(Email,Password,[])-> "";

check_login(Email,Password,[H|T]) ->
    {[_,_,{_,{[{_,CId},_,{_,CEmail},{_,CPassword},_,{_,CNick},{_,CSpace},{_,CAvatar},_]}}]} = H,
    M = check_login_2(Email,Password,CEmail,CPassword),
    if M == "true" -> {"true",CId,CNick,CSpace,CAvatar};
        true -> check_login(Email,Password,T)
    end.
check_login_2(Email,Password,CEmail,CPassword) ->
    New = {Email,Password},
    List_Email = binary_to_list(CEmail),
    List_Password = binary_to_list(CPassword),
    Old = {binary_to_list(CEmail),binary_to_list(CPassword)},
    Empty = {"",""},
    case New of Old -> "true";
        Empty -> "0";
        True -> "1"
    end.

