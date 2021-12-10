--[[
Malte0621's ExternalHttp Module.

--> Usage
#include "shared.lua"

local id2 = 0
local c = 0

function tick(dt)
	if c >= 60*1.25 then
		c = 0
		id2 = id2 + 1
		local function cb(data)
			DebugPrint(data["Body"])
		end
		http.post("http://localhost/?rnd=" .. id2,{msg = "hello"},cb)
		-- http.get("http://localhost/?rnd" .. id2,cb)
	else
		c = c + 1
	end
end

--> API
--------------------------
"shared.lua"
--------------------------
http = {
	get = function(<url:string>,<callback:function>)
	post = function(<url:string>,<data:table>,<callback:function>)
}

callback arguments:
1. {
	Success = <bool> -- true if request was sent successfully and false if not.
	StatusCode = <int> -- HTTP Status code for the requested url (0 if not Success)
	StatusMessage = <string> -- HTTP Status message for the requested url ("" if not Success)
	Headers = <table> -- Table with all the headers {HeaderName = HeaderValue}
	Body = <string> -- The body (text) of the requested url.
}
--------------------------
]]

#include "shared.lua" -- for sending requests in a mod.

local testingMode = false

local loaded = false
local showTicks = 60*1.5

local debugMode = true

function init()
	loaded = true
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local text = ""

local c = 0

SetString("savegame.mod.request","null")

local id = 0

local id2 = 0 -- For sending

function tick(dt)
	local tmp = GetString("game.http.request")
	if tmp ~= nil and tmp ~= "null" and not tonumber(tmp) then
		local split = Split(tmp,"|")
		local set = false
		id = id + 1
		if #split == 3 and split[1]:sub(1,4) == "http" and split[2] == "POST" and split[3]:sub(1,1) == "{" then
			SetString("savegame.mod.request",tmp  .. "|" .. id)
			set = true
		elseif #split == 2 and split[1]:sub(1,4) == "http" and split[2] == "GET" then
			SetString("savegame.mod.request",tmp .. "|" .. id)
			set = true
		end
		if set then
			SetString("game.http.request",tostring(id))
		else
			SetString("game.http.request","null")
		end
	end
	if testingMode then
		if c >= 60*1.25 then
			c = 0
			id2 = id2 + 1
			local function cb(data)
				DebugPrint(data["Body"])
			end
			-- http.post("http://localhost/?rnd=" .. id2,{msg = "hello"},cb)
			http.get("http://localhost/?rnd=" .. id2,cb)
		else
			c = c + 1
		end
	end
	http_tick()
end

function draw()
	if loaded and showTicks > 0 then
		UiTranslate((UiWidth() / 2), (UiHeight() - (UiHeight() / 8)))
		UiAlign("center center")
		UiFont("bold.ttf", 32)
		UiText("ExternalHttp by Malte0621, Loaded.")
		showTicks = showTicks - 1
	end
end