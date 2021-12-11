#include "mhttp.lua"

local testingMode = false

local loaded = false
local showTicks = 60*1.5

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

local c = 0

function tick(dt)
	if testingMode then
		if c >= 60*1.25 then
			c = 0
			 local resp = http.GetAsync("http://localhost/hi.txt",{["Test-Header"] = "Test"})
			-- local resp = http.PostAsyncA("http://localhost/test.php",{hi = "Hello"})
			-- local resp = http.PutAsync("http://localhost/test.php")
			if resp.Success then
				DebugPrint(resp.Body)
				for i,v in pairs(resp.Headers) do
					DebugPrint(i .. ", " .. v)
				end
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