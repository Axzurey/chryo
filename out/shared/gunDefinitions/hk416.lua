-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local tableUtils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").tableUtils
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
		auto = 500,
		burst3 = 600,
		burst4 = 600,
		shotgun = 1000,
		semi = 800,
	}
	g.maxAmmo = 9999
	g.ammo = 9999
	g.reserveAmmo = 120
	g.togglableFireModes = { fireMode.auto, fireMode.semi }
	g.reloadSpeed = 1.5
	g.recoilPattern = tableUtils.toMap({ NumberRange.new(0, 10), NumberRange.new(10, 20), NumberRange.new(20, 31) }, { { Vector2.new(.2, .3), Vector2.new(.7, 1) }, { Vector2.new(.2, .7), Vector2.new(.6, .8) }, { Vector2.new(.7, .9), Vector2.new(.5, .5) } })
	return g
end
return {
	default = hk416_definition,
}
