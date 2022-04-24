-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remoteProtocol = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "signals", "remoteProtocol").default
local protocols = {
	updateMovement = {
		protocol = remoteProtocol.new("player_cframe"),
		verify = function() end,
	},
	equipItem = {
		protocol = remoteProtocol.new("item_equip"),
		verify = function() end,
	},
}
return protocols
