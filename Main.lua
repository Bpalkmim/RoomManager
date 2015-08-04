--- Microprojetinho RoomManager em Lua
--- Modulo Main.lua
--- @author Bernardo Alkmim

local person = require("Person")
local manager = require("Manager")
local reader = require("Reader")
local writer = require("Writer")

print("Lendo do arquivo de entrada...")
local people = reader.readFile(arg[1])
print("Li do arquivo de entrada!")
print(#people, " pessoas lidas\n")
print("Organizando os quartos...")
local rooms, unassigned = manager.manage(people)
print("Organizei os quartos!\n")
print("Escrevendo resultado...")
writer.writeOnFile(rooms, unassigned, arg[2])
print("Escrevi o resultado!\n")
