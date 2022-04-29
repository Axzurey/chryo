-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local human = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "entities", "human").default
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space")
local bots = Workspace:WaitForChild("bots"):GetChildren()
local _bots = bots
local _arg0 = function(v)
	local entity = space.life.create(v, human)
	entity.health = 100
end
for _k, _v in ipairs(_bots) do
	_arg0(_v, _k - 1, _bots)
end
