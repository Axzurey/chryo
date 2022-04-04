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
	local both
	local function getSharedEnvironment()
		while not both do
			task.wait()
		end
		return both
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
	both = if RunService:IsServer() then tree:createTree(tree:createFolder("sharedEnvironment", ReplicatedStorage), bothType) else ReplicatedStorage:WaitForChild("sharedEnvironment")
	_container.both = both
end
return environment
