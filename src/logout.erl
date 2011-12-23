-module (logout).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main()->
    wf:logout(),
    wf:redirect("/baiduimage").
    
    
 
