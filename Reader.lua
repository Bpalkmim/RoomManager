--- Microprojetinho RoomManager em Lua
--- Modulo Reader.lua
--- @author Bernardo Alkmim
--- @module manager
local reader = {}

local person = require("Person")

--- Le as pessoas de um arquivo texto e vai montando o array de pessoas
function reader.readFile(filePath)
	local file = assert(io.open(filePath, "r"))

	local people = {}
	local pattern1 = "%s*([%a ]+)%s+([MF])%s+([MF])%s*$"
	local pattern2 = "%s*([%a ]+)%s+([MF])%s+([MF])%s+([MF])%s*$"
	for line in file:lines() do
		local alreadyDone = false
		for name, gender, sexuality1, sexuality2 in string.gfind(line, pattern2) do
			local sexuality = {sexuality1, sexuality2}
			table.insert(people, person.new(name, gender, sexuality))
			alreadyDone = true
		end

		if not alreadyDone then
			for name, gender, sexuality1 in string.gfind(line, pattern1) do
				local sexuality = {sexuality1}
				table.insert(people, person.new(name, gender, sexuality))
			end
		end
	end

	file:close()
	return people
end

return reader