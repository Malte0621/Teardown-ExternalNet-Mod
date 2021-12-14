--[[
Malte0621's ExternalUdp Module. [EARLY PROTOTYPE] - Many bugs exists and you should use pcall in some places to prevent errors.
(coroutine.wrap(function() end) is also helpful to prevent crashes during the request.)

(Requires json.lua)

--> Usage
#include "mudp.lua"

local udpSocket = udp.connect("127.0.0.1",1621)
DebugPrint("Connected")
local sent = udpSocket.send("Hello!")
DebugPrint(sent and "true" or "false")
local data = udpSocket.recv(1024)
DebugPrint(data)
udpSocket.close()

--> API
--------------------------
"mudp.lua"
--------------------------
udp = {
	host = function(<port:int>) -> {
		close = function() -> <success:bool>
		send = function(<ip:string>,<port:int>,<data:string>) -> <success:bool>
		recv = function() -> {addr = {ip = <ip:string>, port = <port:int>, str = <ipandport:string>}, data = <data:string> OR <data:nil>}
	}
	connect = function(<ip:string>,<port:int>) -> {
		close = function() -> <success:bool>
		send = function(<data:string>) -> <success:bool>
		recv = function() -> <data:string> OR <data:nil>
	}
}
--------------------------
]]

#include "json.lua"

local bug_fix_random_chars = false -- Fixes tons of random characters at the end of the recv data.

local function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local unpack = table.unpack or unpack

local function parseResponse(resp)
	local index = string.find(resp,string.char(0))
	if index then
		resp = resp:sub(1,index-1)
	end
	return resp
end

udp = {
	host = function(port)
		local resp = udp_host(port)
		if resp.Success then
			local id = resp.Id
			local closed = false
			return {
				isClosed = function()
					return closed
				end;
				close = function()
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_unhost(id)
					if resp.Success then
						closed = true
						return true
					else
						-- error(resp.Error)
						return false
					end
				end;
				send = function(ip,port,data)
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_send(id,true,ip,port,data)
					if resp.Success then
						return true
					else
						-- error(resp.Error)
						return false
					end
				end;
				recv = function(buffer)
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_recv(id,true,"",0,buffer)
					if resp.Success then
						local data = Split(resp.Data,"|")
						local addr = table.remove(data,1)
						data = table.concat(data,"|")
						if bug_fix_random_chars then
							data = parseResponse(data)
						end
						local ip,port = unpack(Split(addr,":"))
						return {addr = {ip = ip, port = tonumber(port), str = addr}, data = data}						
					else
						-- error(resp.Error)
						return nil
					end
				end;
			}
		else
			error(resp.Error)
		end
	end;
	connect = function (ip,port)
		local resp = udp_connect(ip,port)
		if resp.Success then
			local id = resp.Id
			local closed = false
			return {
				isClosed = function()
					return closed
				end;
				close = function()
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_close(id)
					if resp.Success then
						closed = true
						return true
					else
						-- error(resp.Error)
						return false
					end
				end;
				send = function(data)
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_send(id,false,ip,port,data)
					if resp.Success then
						return true
					else
						-- error(resp.Error)
						return false
					end
				end;
				recv = function(buffer)
					if closed then
						-- error("Request Failed : Socket Closed.")
						return false
					end
					local resp = udp_recv(id,false,ip,port,buffer)
					if resp.Success then
						local data = resp.Data
						if bug_fix_random_chars then
							data = parseResponse(data)
						end
						return data
					else
						-- error(resp.Error)
						return nil
					end
				end;
			}
		else
			error(resp.Error)
		end
	end;
}