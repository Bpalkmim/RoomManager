--- Microprojetinho RoomManager em Lua
--- Modulo Person.lua
--- @author Bernardo Alkmim
--- @module manager
local manager = {}

local person = require("Person")

--- Verifica se ha algum nome repetido na lista de pessoas.
local function validate(people)
	table.sort(people, function (person1, person2)
		return person1:getName() < person2:getName()
	end)

	for i in 1, (#people - 1) do
		if people[i]:getName() == people[i + 1]:getName() then
			return false
		end
	end

	return true
end

--- Preenche as listas de possiveis roommates de cada pessoa
local function fillPossibleRoommates(people)
	for _, person1 in pairs(people) do
		for _, person2 in pairs(people) do
			if person1 ~= person2 and person1:canShareRoomWith(person2) then
				person1:addPossibleRoommate(person2)
			end
		end
	end

	return people
end

--- Remove uma pessoa do array de pessoas, atualizando os roommates disponiveis de todos os outros
local function removePerson(people, index)
	local removed = people[index]
	table.remove(people, index)
	
	for _, person1 in ipairs(people) do
		for k, possibleRoomie in pairs(person1:getPossibleRoommates()) do
			if removed == possibleRoomie then
				table.remove(person1:getPossibleRoommates(), k)
			end
		end
	end
	return removed, people
end

--- Encontra o indice de uma pessoa no array de pessoas
local function findIndex(people, person1)
	for k, v in pairs(people) do
		if v == person1 then
			return k
		end
	end
	return -1
end

--- Copia uma tabela
function shallowCopy(origin)
    local copy
    if type(origin) == 'table' then
        copy = {}
        for k, v in pairs(origin) do
            copy[k] = v
        end
    else
        copy = origin
    end
    return copy
end

--- Faz os pares de pessoas, atualizando o array de pessoas que ainda nao tem quarto
--- Nem de longe um algoritmo otimo
--- TODO APARENTEMENTE BUGADO TAMBEM :C
local function assignRooms(people)
	local rooms = {}

	for _, value in pairs(people) do
		if 	#(value:getPossibleRoommates()) > 0 then
			for _, roomie in pairs(value:getPossibleRoommates()) do
				if not value:getIsPaired() and not roomie:getIsPaired() then
					local p1
					p1, people = removePerson(people, findIndex(people, value))
					_, people = removePerson(people, findIndex(people, roomie))
					table.insert(rooms, {p1, roomie})
					value:setIsPaired(true)
					roomie:setIsPaired(true)
				elseif value:getIsPaired() then
					_, people = removePerson(people, findIndex(people, value))
				elseif roomie:getIsPaired() then
					_, people = removePerson(people, findIndex(people, roomie))
				end
			end
		end
	end

	return rooms, people
end

--- Funçao principal, que recebe um array de pessoas e retorna um array com uma 
--- das possiveis configuracoes dos quartos (a primeira que encontrar).
function manager.manage(people)
	if not validate(people) then
		error("Ha pessoas com nome repetido. Modifique nos nomes")
	end

	people = fillPossibleRoommates(people)

	table.sort(people, function (person1, person2)
		if person1:getPossibleRoommates() == nil then
			return true
		elseif person2:getPossibleRoommates() == nil then
			return false
		else
			return #(person1:getPossibleRoommates()) < #(person2:getPossibleRoommates())
		end
	end)

	return assignRooms(people)
end

return manager
