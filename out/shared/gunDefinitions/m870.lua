-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local gun = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "extended", "gun").default
local _itemConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "itemConfig")
local itemConfig = _itemConfig
local itemClean = _itemConfig.itemClean
local gunIdentifier = "m870"
local function m870_definition(id)
	local g = gun.new(id, "ReplicatedStorage//guns//m870&class=Model", {
		sight = {
			name = "holographic",
			path = "ReplicatedStorage//sights//holographic&class=Model",
			zOffset = .13,
		},
	}, {
		idle = "rbxassetid://9708823676",
		pump = "rbxassetid://9708836982",
	})
	for p, v in pairs(itemClean(itemConfig.getProperties(gunIdentifier))) do
		g[p] = v
	end
	return g
end
return {
	default = m870_definition,
}
