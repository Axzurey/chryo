-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local environment = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "environment")
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "system")
local serverData = {
	playerConfiguration = {},
}
local env = environment.getSharedEnvironment()
system.remote.server.on("updateMovement", function() end)
