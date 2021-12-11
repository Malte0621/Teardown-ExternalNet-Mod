--[[
Malte0621's ExternalHttp Module (V2).

--> Usage
#include "mhttp.lua"

local body = http.PostAsyncA("http://localhost/",{msg = "hello"}) -- PostAsyncA urlencodes for you. While PostAsync does not and requires manual urlencoding. 
-- local body = http.GetAsync("http://localhost/")	

--> API
--------------------------
"mhttp.lua"
--------------------------
http = {
	GetAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}
	PostAsyncA = function(<url:string>,<data:table>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}
	
	PutAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}
	DeleteAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}
	OptionsAsync = function(<url:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}

	PostAsync = function(<url:string>,<data:string>,<headers:table>) -> {Success = <success:bool>, (Error = <error:string>), Body = <body:string>, StatusCode = <statuscode:int>}
	
	UrlEncode = function(<str:string>) -> <output:string>
	UrlDecode = function(<str:string>) -> <output:string>
}

## headers example ##
{["key"] = "value"}
--------------------------
]]

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

http = {
	UrlEncode = UrlEncode;
	UrlDecode = UrlDecode;
	GetAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return http_get(url,unpack(headers))
	end;
	PutAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return http_put(url,unpack(headers))
	end;
	DeleteAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return http_delete(url,unpack(headers))
	end;
	OptionsAsync = function(url,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return http_options(url,unpack(headers))
	end;
	PostAsync = function(url,body,headers)
		if not headers then headers = {} end
		headers = formatHeaders(headers)
		return http_post(url,body,unpack(headers))
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
		return http_post(url,data,unpack(headers))
	end;
}