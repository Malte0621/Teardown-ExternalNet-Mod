#include "mhttp.lua"

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

function tick(dt)
	if testingMode then
		if c >= 60*1.25 then
			c = 0
			-- http.PostAsyncA("http://localhost/",{msg = "hello"},cb)
			local resp = http.GetAsync("http://localhost/hi.txt")
			if resp.Success then
				DebugPrint(resp.Body)
			else
				DebugPrint("MTHTP_ERROR: " .. resp.Error)
			end
		else
			c = c + 1
		end
	end
end

function draw()
	if loaded and showTicks > 0 then
		UiTranslate((UiWidth() / 2), (UiHeight() - (UiHeight() / 8)))
		UiAlign("center center")
		UiFont("bold.ttf", 32)
		UiText("ExternalHttp (V2) by Malte0621, Loaded.")
		showTicks = showTicks - 1
	end
end