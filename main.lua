#include "mhttp.lua"
#include "mudp.lua"
#include "version.lua"

local installed_version = version

local checkForUpdates = true
if checkForUpdates then
	local s,f = pcall(function()
		local latestVersion = http.GetAsync("https://raw.githubusercontent.com/Malte0621/Teardown-ExternalNet-Mod/main/version.lua")
		if latestVersion.Success then
			loadstring(latestVersion.Body)()
			if installed_version ~= version or get_externalnet_version() ~= version then
				DebugPrint("[ExternalNet]: Updates availible, check github repo.")
			end
		else
			DebugPrint("[ExternalNet]: Failed to fetch latest version of ExternalNet.")
		end
	end)
	if not s then
		DebugPrint("[ExternalNet]: Failed to fetch latest version of ExternalNet. {Error: \"" .. f .. "\"}")
	end
end
local testingMode = false
local doHttpTest = false
local doUDPTest = false
local isUDPServer = false
local doPingtest = false
local onlyResolveDuringPing = false
local doTestEvery = 0.5  -- Seconds
-- mhttp_return_headers = false -- Disable response headers (may prevent crashing.)

local loaded = false
local showTicks = 60*1.5

function init()
	loaded = true
end

local c = 0

local udpSocket = nil

local udpServerSocket = nil

function update(dt)
	if testingMode then
		if c == 25 then
			c = c + 1
			if isUDPServer then
				if not udpServerSocket then
					udpServerSocket = udp.host(1621)
				end
				if udpServerSocket then
					pcall(function()
						local data = udpServerSocket.recv(1024)
						DebugPrint('--------- Server ---------')
						DebugPrint(data.addr.str)
						DebugPrint(data.data)
						DebugPrint('--------------------------')
						local s,f = pcall(function()
							udpServerSocket.send(data.addr.ip,data.addr.port,"Hello Server")
						end)
						if s then
							DebugPrint('SENT RESPONSE')
						else
							DebugPrint('I FAILED TO SEND MY RESPONSE! :(  :  ' .. f)
						end
					end)
				end
			end
		elseif c >= 60*doTestEvery then
			c = 0
			
			-- HTTP
			if doHttpTest then
				local resp = http.GetAsync("http://localhost/hi.txt",{["Test-Header"] = "Test"})
				-- local resp = http.PostAsyncA("http://localhost/test.php",{hi = "Hello"})
				-- local resp = http.PutAsync("http://localhost/test.php")
				if resp.Success then
					DebugPrint(resp.Body)
					if mhttp_return_headers then
						for i,v in pairs(resp.Headers) do
							DebugPrint(i .. ", " .. v)
						end
					end
				else
					DebugPrint("MTHTP_ERROR: " .. resp.Error)
				end
			end
			-- UDP
			if doUDPTest then
				if not isUDPServer then
					if not udpSocket then
						udpSocket = udp.connect("127.0.0.1",1621)
						DebugPrint("Connected")
					end
					if udpSocket then
						DebugPrint('--------- Client ---------')
						local sent = udpSocket.send("Hello Client")
						DebugPrint(sent and "true" or "false")
						local data = udpSocket.recv(1024)
						DebugPrint(data)
						DebugPrint('--------------------------')
					end
				end
			end
			-- PING
			if doPingtest then
				if onlyResolveDuringPing then
					local resp = resolve("www.google.com")
					if resp.Success then
						DebugPrint(resp.IP)
					end
				else
					local resp = ping("www.google.com")
					if resp.Success then
						if resp.Timeout then
							DebugPrint('Ping2Google: Timeout')
							DebugPrint('Resolved Google Ip Address: ' .. resp.IP)
						else
							DebugPrint('Ping2Google: ' .. resp.Time)
							DebugPrint('Resolved Google Ip Address: ' .. resp.IP)
						end
					else
						DebugPrint('MPING_ERROR: ' .. resp.Error)
					end
				end
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

