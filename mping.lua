--[[
Malte0621's ExternalPing Module. [EARLY PROTOTYPE] - Many bugs exists and you should use pcall in some places to prevent errors.
(coroutine.wrap(function() end) is also helpful to prevent crashes during the request.)

--> Usage

local ping = ping("www.google.com")
print(ping.Time)

--> API
--------------------------
BuildIn
--------------------------
ping = function(address) -> {Success = <success:bool>, (Error = <error:string>), IP = <ip:string>, Timeout = <timeout:bool>, Time = <pingtime:int>, Ttl = <ttl:int>}
resolve = function(address) -> {Success = <success:bool>, (Error = <error:string>), IP = <ip:string>}
--------------------------
]]