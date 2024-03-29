--[[
Malte0621's ExternalHttp Module (V2).
(coroutine.wrap(function() end) is also helpful to prevent crashes during the request.)

(Requires json.lua)

--> Note
The game crashes when too many requests are sent WITH response headers enabled.
To disable response headers use:
mhttp_return_headers = false
AND To enable it again use:
mhttp_return_headers = true

--> Usage
#include "mhttp.lua"

local resp = http.PostAsyncA("http://localhost/",{msg = "hello"}) -- PostAsyncA urlencodes for you. While PostAsync does not and requires manual urlencoding. 
-- local resp = http.GetAsync("http://localhost/")	

--> API
--------------------------
"mhttp.lua"
--------------------------
http = {
	GetAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}
	PostAsyncA = function(<url:string>,<data:table>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}
	
	PutAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}
	DeleteAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}
	OptionsAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}

	PostAsync = function(<url:string>,<data:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, Headers = <headers:table>, StatusCode = <statuscode:int>}
	
	UrlEncode = function(<str:string>) -> <output:string>
	UrlDecode = function(<str:string>) -> <output:string>
}

## headers example ##
{["key"] = "value"}
--------------------------
]]


#include "json.lua"

mhttp_return_headers = true

local UrlEncode = function(str)
	str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])",
	   function (c) return string.format ("%%%02X", string.byte(c)) end)
	str = string.gsub (str, " ", "+")
	return str
 end;
 local UrlDecode = function(str)
	str = string.gsub (str, "+", " ")
	str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
	return str
 end;

local unpack = table.unpack or unpack

local function formatHeaders(headers)
	local tmp = {}
	for i,v in pairs(headers) do
		table.insert(tmp,{[i] = v})
	end
	return tmp
end

local function parseResponse(resp)
	if resp["Headers"] then
		resp["Headers"] = json.decode(resp["Headers"])
	end
	return resp
end

local http_get = http_get
local http_put = http_put
local http_delete = http_delete
local http_options = http_options
local http_post = http_post

http_get, http_put, http_delete, http_options, http_post = nil

http = {
	UrlEncode = UrlEncode;
	UrlDecode = UrlDecode;
	GetAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return parseResponse(http_get(url,unpack(headers)))
	end;
	PutAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return parseResponse(http_put(url,unpack(headers)))
	end;
	DeleteAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return parseResponse(http_delete(url,unpack(headers)))
	end;
	OptionsAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return parseResponse(http_options(url,unpack(headers)))
	end;
	PostAsync = function(url,body,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return parseResponse(http_post(url,body,unpack(headers)))
	end;
	PostAsyncA = function(url,body,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		local data = ""
		for k, v in pairs(body) do
			data = data .. ("&%s=%s"):format(
				UrlEncode(k),
				UrlEncode(v)
			)
		end
		data = data:sub(2)
		return parseResponse(http_post(url,data,unpack(headers)))
	end;
}