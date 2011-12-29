-module(de2Hex).  
-export([de2Hex/1]). 
 
tempData([0])-> [];  
tempData([Num]) ->
    Temp = Num band 15,  
    if  
        Temp >= 0,Temp < 10 -> Result = Temp + 48;  
        Temp >= 10,Temp < 16 ->  Result = Temp + 55          
    end,  
    [Result | tempData([Num bsr 4])].  
 
de2Hex(Num)->  
    lists:reverse(tempData([Num])).  
