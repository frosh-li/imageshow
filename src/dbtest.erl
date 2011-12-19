%% -*- mode: nitrogen -*-
-module (dbtest).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include("image_cache.hrl").
main() ->
    mnesia:create_table(employee,
                        [{attributes, record_info(fields, employee)}]),
    mnesia:create_table(dept,
                        [{attributes, record_info(fields, dept)}]),
    mnesia:create_table(project,
                        [{attributes, record_info(fields, project)}]),
    mnesia:create_table(manager, [{type, bag}, 
                                  {attributes, record_info(fields, manager)}]),
    mnesia:create_table(at_dep,
                         [{attributes, record_info(fields, at_dep)}]),
    mnesia:create_table(in_proj, [{type, bag}, 
                                  {attributes, record_info(fields, in_proj)}]),
                                  "create database down!".
