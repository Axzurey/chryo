-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local serverGun = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverExtended", "serverGun").default
local environment = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "environment")
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "system")
local serverData = {
	playerConfiguration = {},
}
local dotenv = environment.getSharedEnvironment()
local internalIdentification = {}
Players.PlayerAdded:Connect(function(client)
	local mix = {
		items = {
			primary = serverGun.new("$serverGun1"),
		},
		currentEquipped = nil,
	}
	internalIdentification["$serverGun1"] = {
		owner = client,
		object = mix.items.primary,
	}
	serverData.playerConfiguration[client.UserId] = mix
end)
system.remote.server.on("equipItem", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		for i, v in pairs(serverData.playerConfiguration[player.UserId].items) do
			if v.serverItemIdentification == itemId then
				v:equip()
			else
				v:unequip()
			end
		end
	end
end)
system.remote.server.on("updateMovement", function() end)
