-module(pick_resource).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
	#template{file="./site/templates/pick_resource.html"}.
