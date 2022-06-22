-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local positionTracker = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverMechanics", "positionTracker")
local environment = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "environment")
local itemTypeIdentifier = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork").itemTypeIdentifier
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "system")
local m870_server_definition = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverGunDefinitions", "m870").default
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space")
local user = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverClasses", "user").default
local reinforcement = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverMechanics", "reinforcement")
local serverData = {
	playerConfiguration = {},
}
local dotenv = environment.getSharedEnvironment()
local internalIdentification = {}
Players.PlayerAdded:Connect(function(client)
	positionTracker.addPlayer(client)
	local characterClass = space.life.create(user)
	characterClass:setClient(client)
	local character = client.Character or (client.CharacterAdded:Wait())
	characterClass:setCharacter(character)
	local newCharacterConnection = client.CharacterAdded:Connect(function(character)
		characterClass:setCharacter(character)
	end)
	local mix = {
		items = {
			primary = m870_server_definition("Gun1", characterClass),
		},
		currentEquipped = nil,
		characterClass = characterClass,
		connections = {
			newCharacterConnection = newCharacterConnection,
		},
	}
	mix.items.primary:setUser(client)
	internalIdentification.Gun1 = {
		owner = client,
		object = mix.items.primary,
	}
	serverData.playerConfiguration[client.UserId] = mix
end)
system.remote.server.on("equipContext", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
		return nil
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
system.remote.server.on("reloadStartContext", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:startReload()
			end
		end
	end
end)
system.remote.server.on("reloadEndContext", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
		return nil
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:finishReload()
			end
		end
	end
end)
system.remote.server.on("reloadCancelContext", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
		return nil
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:cancelReload()
			end
		end
	end
end)
system.remote.server.on("fireContext", function(player, itemId, cframe)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
		return nil
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:fire(cframe)
			end
		end
	end
end)
system.remote.server.on("fireMultiContext", function(player, itemId, cframes)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
		return nil
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:fireMulti(cframes)
			end
		end
	end
end)
system.remote.server.on("updateMovement", function(player, newcframe)
	local result = positionTracker.setPosition(player, newcframe)
end)
system.remote.server.on("startReinforcement", function(player, cam)
	reinforcement.reinforce(player, cam)
end)
