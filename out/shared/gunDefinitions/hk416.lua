-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local gun = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "extended", "gun").default
local fireMode = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork").fireMode
local function hk416_definition(id)
	local g = gun.new(id, "ReplicatedStorage//guns//hk416&class=Model", {
		sight = {
			name = "holographic",
			path = "ReplicatedStorage//sights//holographic&class=Model",
			zOffset = .13,
		},
	}, {
		idle = "rbxassetid://9335189959",
	})
	g.firerate = {
		burst2 = 600,
		auto = 800,
		burst3 = 600,
		burst4 = 600,
		shotgun = 1000,
		semi = 800,
	}
	g.togglableFireModes = { fireMode.auto, fireMode.semi }
	g.reloadSpeed = 1.5
	return g
end
return {
	default = hk416_definition,
}
