-module (baiduimage).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
main()->
    io:format("Cookies is ~p~n",[wf:cookie("Userid")]),

	#template { file="./site/templates/baiduimage.html" }.
	
