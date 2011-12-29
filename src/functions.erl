-module (functions).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

s_replace(originString,replaceString,replacedString)->
    string:left(originString,string:str(originString,replaceString) -1 )
    ++replaceString
    ++string:right(originString,string:rstr(originString,replaceString)).
