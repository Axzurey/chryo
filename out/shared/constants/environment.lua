-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local tree = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "tree").default
local environment = {}
do
	local _container = environment
	--[[
		*
		*
		* @returns it waits for the server to create the environment and then returns it
	]]
	local env
	local function getSharedEnvironment()
		return env
	end
	_container.getSharedEnvironment = getSharedEnvironment
	local bothType = {
		Remotes = {
			["$className"] = "Folder",
			["$properties"] = {
				Name = "Remotes",
			},
		},
	}
	env = if RunService:IsServer() then tree:createTree(tree:createFolder("sharedEnvironment", ReplicatedStorage), bothType) else ReplicatedStorage:WaitForChild("sharedEnvironment")
	_container.env = env
end
return environment
