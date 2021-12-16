#include "mudp.lua"

local udpSocket = udp.connect("127.0.0.1",1621)
DebugPrint("Connected")
local sent = udpSocket.send("Hello!")
DebugPrint(sent and "true" or "false")
local data = udpSocket.recv(1024)
DebugPrint(data)
udpSocket.close()