-module (thumbnail).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
	os:cmd("convert site/static/images/dragon.gif -thumbnail 80 site/static/images/resize_dragon_80.gif"),
	"conver to 80px".
