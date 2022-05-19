-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local tableUtils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").tableUtils
local fireMode = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork").fireMode
local hk416_config = {
	firerate = {
		burst2 = 600,
		auto = 500,
		burst3 = 600,
		burst4 = 600,
		shotgun = 1000,
		semi = 800,
	},
	adsLength = .5,
	ammo = 9999,
	maxAmmo = 9999,
	reserveAmmo = 9999,
	togglableFireModes = { fireMode.auto, fireMode.semi },
	reloadSpeed = 1.5,
	recoilRegroupTime = 1.5,
	spreadHipfirePenalty = 1.1,
	spreadMovementHipfirePenalty = 1.2,
	spreadDelta = 1.15,
	spreadPopTime = 1.5,
	spreadUpPerShot = .25,
	maxAllowedSpread = 35,
	recoilPattern = tableUtils.toMap({ NumberRange.new(0, 10), NumberRange.new(10, 20), NumberRange.new(20, 31) }, { { Vector3.new(.2, .3, .2), Vector3.new(.7, 1, .2) }, { Vector3.new(.2, .7, .3), Vector3.new(.6, .8, .3) }, { Vector3.new(.7, .9, .2), Vector3.new(.5, .5, .4) } }),
}
return hk416_config
