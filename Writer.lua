--- Microprojetinho RoomManager em Lua
--- Modulo Writer.lua
--- @author Bernardo Alkmim
--- @module manager
local writer = {}

local person = require("Person")

--- Passa para um arquivo texto os quartos organizados
function writer.writeOnFile(rooms, unassigned, filePath)
	local file = assert(io.open(filePath, "w"))

	file:write("People assigned (", (#rooms*2), "):\n")
	for i, room in ipairs(rooms) do
		file:write("Room ", i, ":\n", room[1]:toString(), "\n", room[2]:toString(), "\n")
	end

	file:write("People unassigned (", #unassigned, "):\n")
	for _, person in ipairs(unassigned) do
		file:write(person:toString(), "\n")
	end

	file:write("People total: ", (#rooms*2 + #unassigned), "\n")

	file:close()
end

return writer