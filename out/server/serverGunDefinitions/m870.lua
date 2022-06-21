-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverGun = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverExtended", "serverGun").default
local _itemConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "itemConfig")
local itemConfig = _itemConfig
local itemClean = _itemConfig.itemClean
local images = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "source").images
local gunIdentifier = "m870"
local function m870_server_definition(id, clientClass)
	local gun = serverGun.new(id, clientClass)
	for p, v in pairs(itemClean(itemConfig.getProperties(gunIdentifier))) do
		if gun[p] ~= nil then
			gun[p] = v
		end
	end
	gun.source.images = {
		normal = images.bullet_hole_default,
		glass = images.bullet_hole_glass,
		metal = images.bullet_hole_default,
	}
	return gun
end
return {
	default = m870_server_definition,
}
