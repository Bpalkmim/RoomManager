--- Microprojetinho RoomManager em Lua
--- Modulo Person.lua
--- @author Bernardo Alkmim
--- @module person
local person = {}

--- Tabela da classe
local Person = {}

--- Construtor
function person.new(personName, personGender, personSexuality)
	local self = {}
	setmetatable(self, { __index = Person })

	self:setName(personName)
	self:setGender(personGender)
	self:setSexuality(personSexuality)
	self:setPossibleRoommates({})
	self:setIsPaired(false)

	return self
end

--- Verifica se suas pessoas podem namorar
function Person:canDate(person2)
	for _,v in ipairs(person2:getSexuality()) do
		if v == self:getGender() then
			for _,val in ipairs(self:getSexuality()) do
				if val == person2:getGender() then
					return true
				end
			end
		end
	end
	return false
end

--- Verifica se esta de acordo com as restricoes de person2 e vice-versa
--- Regra de negocio: somente pessoas de mesmo genero podem dividir o quarto,
--- independente de sexualidade
function Person:canShareRoomWith(person2)
	if (self:getGender() ~= person2:getGender()) or self:canDate(person2) or self:getIsPaired() or person2:getIsPaired() then
		return false
	end
	return true
end

--- Mostra a pessoa
function Person:toString()
	nameAndGender = string.format("%s\t%s", self:getName(), self:getGender())
	
	sexuality = ""
	for k,v in pairs(self:getSexuality()) do
		sexuality = sexuality .. v
	end

	return nameAndGender .. "\t" .. sexuality
end

--- Adiciona pessoa para a lista de possiveis roommates
function Person:addPossibleRoommate(person1)
	local list = self:getPossibleRoommates()
	table.insert(list, person1)
	self:setPossibleRoommates(list)
end

--- Remove a primeira pessoa da lista de possiveis roommates
function Person:removePossibleRoommate(index)
	local list = self:getPossibleRoommates()
	table.remove(list, index)
	self:setPossibleRoommates(list)
end

---- Setters
--- Setter do nome dessa pessoa
function Person:setName(name)
	self.name = name
end

--- Setter do genero dessa pessoa
function Person:setGender(gender)
	self.gender = gender
end

--- Setter da sexualidade dessa pessoa
function Person:setSexuality(sexuality)
	self.sexuality = sexuality
end

--- Setter da lista dos possiveis roommates
function Person:setPossibleRoommates(list)
	self.possibleRoommates = list
end

--- Setter do booleano que diz se ja tem roommate ou nao
function Person:setIsPaired(x)
	self.isPaired = x
end

---- Getters
--- Getter do nome dessa pessoa
function Person:getName()
	return self.name
end

--- Getter do genero dessa pessoa
function Person:getGender()
	return self.gender
end

--- Getter da sexualidade dessa pessoa
function Person:getSexuality()
	return self.sexuality
end

--- Getter da lista dos possiveis roommates
function Person:getPossibleRoommates()
	return self.possibleRoommates
end

--- Getter do booleano que diz se ja tem roommate ou nao 
function Person:getIsPaired()
	return self.isPaired
end

return person