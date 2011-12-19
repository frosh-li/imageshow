-module(createdb).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").


%%%%创建数据库
main()->
    insertToDoc(),
    "insert data success".


%%链接的字段


linktodb()->
    Host = "localhost",
    Port = 5984,
    Prefix = "",
    Options = [],
    couchbeam:server_connection(Host, Port, Prefix, Options).
    
insertToDoc() -> 
    Server = linktodb(),
    [H|T] = couchbeam:get_uuid(Server),
    Docxxx = {[
           {<<"_id">>,H},
           {<<"src">>, <<"myid">>},
           {<<"bb">>, <<"test">>}
       ]},
    {ok,Db} = couchbeam:open_db(Server,"image_cache",[]),
    {ok,Doc1} =couchbeam:save_doc(Db,Docxxx).
    
       
serverInfo() -> 
    couchbeam:server_info(linktodb()).
