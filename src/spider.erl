-module(spider). 
-compile(export_all). 
-import(lists,[reverse/1,reverse/2,map/2]). 
main()->
    nano_get_url("www.iteye.com").
nano_get_url() -> 
nano_get_url("www.erlang.org"). 

nano_get_url(Host) -> 
{ok,Socket} = gen_tcp:connect(Host, 80, [binary,{packet,0}]), 
ok = gen_tcp:send(Socket,"GET / HTTP/1.0\r\n\r\n"), 
receive_data(Socket,[]). 

receive_data(Socket,SoFar) -> 
receive 
{tcp,Socket,Bin} -> 
receive_data(Socket,[Bin|SoFar]); 
{tcp_closed,Socket} ->  
list_to_binary(lists:reverse(SoFar)) 
end. 
