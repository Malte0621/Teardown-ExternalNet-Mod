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
	GetAsync = function(<url:string>) -> <body:string>
	PostAsyncA = function(<url:string>,<data:table>) -> <body:string>
	
	PostAsync = function(<url:string>,<data:string>) -> <body:string>
		
	UrlEncode = function(<str:string>) -> <output:string>
	UrlDecode = function(<str:string>) -> <output:string>
}
--------------------------
]]

local UrlEncode = function(str)
	str = string.gsub (str, "([^0-9a-zA-Z !'()*._~-])", -- locale independent
	   function (c) return string.format ("%%%02X", string.byte(c)) end)
	str = string.gsub (str, " ", "+")
	return str
 end;
 local UrlDecode = function(str)
	str = string.gsub (str, "+", " ")
	str = string.gsub (str, "%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
	return str
 end;

http = {
	UrlEncode = UrlEncode;
	UrlDecode = UrlDecode;
	GetAsync = function(url)
		return http_get(url)
	end;
	PostAsync = function(url,body)
		return http_post(url,body)
	end;
	PostAsyncA = function(url,body)
		local data = ""
		for k, v in pairs(dataFields) do
			data = data .. ("&%s=%s"):format(
				UrlEncode(k),
				UrlEncode(v)
			)
		end
		data = data:sub(2)
		return http_post(url,data)
	end;
}