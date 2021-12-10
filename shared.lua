--[[
Malte0621's ExternalHttp Module.

Check main.lua for api/usage
]]

-- Notice: Requests need a randomize due to teardown's cache system. Just add a random mumber within "?rnd=" at the end of the url.
-- http.get("http://localhost/" .. "?rnd=" .. math.random(1,9999)) -- You might have to change ? to & if you're already using ? in the url.
#include "json.lua"

local callbacks = {}

local pendingCallbacks = {}

function http_tick(dt)
	local id = tonumber(GetString("game.http.request"))
	if id then
		callbacks[id] = table.remove(pendingCallbacks,1)
		SetString("game.http.request","null")
	end
	local success = {}
	for id,callback in pairs(callbacks) do
		local s,f = pcall(function()
			dofile("C:\\teardown_http_temp\\http_response" .. tostring(id) .. ".lua")
			return result
		end)
		if s then
			callback(json.decode(f))
			table.insert(success,id)
		end
	end
	for i,v in ipairs(success) do
		callbacks[v] = nil
	end
end

http = {
	get = function(url,callback)
		if type(url) ~= "string" then
			error("url is required to be set as a table.")
		end
		if type(callback) ~= "function" then
			error("callback is required to be set as a function : function(response) end")
		end
		-- DebugPrint(url .. "|GET") -- For debugging
		SetString("game.http.request",url .. "|GET")
		table.insert(pendingCallbacks,callback)
	end,
	post = function(url,data,callback)
		if type(url) ~= "string" then
			error("url is required to be set as a table.")
		end
		if type(data) ~= "table" then
			error("data is required to be set as a table.")
		end
		if type(callback) ~= "function" then
			error("callback is required to be set as a function : function(response) end")
		end
		-- DebugPrint(url .. "|POST|" .. json.encode(data)) -- For debugging
		SetString("game.http.request",url .. "|POST|" .. json.encode(data))
		table.insert(pendingCallbacks,callback)
	end
}