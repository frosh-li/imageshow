%% -*- mode: nitrogen -*-
-module (settings).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
    #template { file="./site/templates/settings.html"}.
