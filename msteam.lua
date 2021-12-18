--[[
Malte0621's ExternalSteam Module. [EARLY PROTOTYPE] - Many bugs exists and you should use pcall in some places to prevent errors.
(coroutine.wrap(function() end) is also helpful to prevent crashes during the request.)

--> Usage
#include "msteam.lua"

local started = steam.Start()
if started then
    local userid = steam.GetId()
    local username = steam.GetUsername()
    -- steam.Shutdown() -- Calling this will close the game .-.
end

--> API
--------------------------
"msteam.lua"
--------------------------
steam = {
    Start = function() -> <success:bool>
    Shutdown = function() : Calling this will close the game .-.
    GetUsername = function() -> <username:string>
    GetId = function() -> <userid:int>
}
--------------------------
]]

local start_steam_api = start_steam_api
local shutdown_steam_api = shutdown_steam_api
local get_steam_username = get_steam_username
local get_steam_id = get_steam_id

steam = {
    Start = function()
        return start_steam_api()
    end,
    Shutdown = function() -- Calling this will close the game .-.
        shutdown_steam_api()
    end,
    GetUsername = function()
        return get_steam_username()
    end,
    GetId = function ()
        return get_steam_id()
    end
}