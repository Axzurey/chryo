-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local positionTracker = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverMechanics", "positionTracker")
local environment = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "environment")
local itemTypeIdentifier = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork").itemTypeIdentifier
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
local m870_server_definition = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverGunDefinitions", "m870").default
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "space")
local user = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverClasses", "user").default
local reinforcement = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverMechanics", "reinforcement")
local serverDrone = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverClasses", "serverDrone").default
local serverData = {
	playerConfiguration = {},
}
local dotenv = environment.getSharedEnvironment()
local internalIdentification = {}
local internalDrones = {}
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
		currentReinforcement = nil,
		player = client,
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
system.remote.server.on("reloadFeedSingleContext", function(player, itemId)
	local fromMap = internalIdentification[itemId]
	if not fromMap then
	end
	if fromMap.owner and fromMap.owner == player then
		local obj = fromMap.object
		if obj.typeIdentifier == itemTypeIdentifier.gun then
			if obj.userEquipped then
				obj:feedSingle()
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
	local lr = serverData.playerConfiguration[player.UserId]
	if lr.currentReinforcement then
		return nil
	end
	local r = reinforcement.reinforce(player, cam)
	lr.currentReinforcement = r
end)
system.remote.server.on("cancelReinforcement", function(player)
	local r = serverData.playerConfiguration[player.UserId].currentReinforcement
	if r then
		r.cancel()
	end
	serverData.playerConfiguration[player.UserId].currentReinforcement = nil
end)
system.remote.server.on("throwDrone", function(player)
	local id = HttpService:GenerateGUID()
	local drone = serverDrone.new(id, player, serverData, player.Character:GetPrimaryPartCFrame().Position)
	internalDrones[id] = {
		object = drone,
	}
	system.remote.server.fireClient("throwDrone", player, id, player, drone.model)
end)
system.remote.server.on("observeCamera", function(player, id, view)
	local d = internalDrones[id]
	if not d then
		return nil
	end
	if view then
		d.object:addToQueue(player)
	else
		d.object:removeFromQueue(player)
	end
end)
system.remote.server.on("moveDrone", function(player, id, dir)
	local d = internalDrones[id]
	print("this", id)
	if not d then
		return nil
	end
	d.object:update(dir)
	print("updated!", dir)
end)
