-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local tableUtils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").tableUtils
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork")
local fireMode = _gunwork.fireMode
local reloadType = _gunwork.reloadType
local m870_config = {
	firerate = {
		burst2 = 0,
		auto = 0,
		burst3 = 0,
		burst4 = 0,
		shotgun = 75,
		semi = 0,
	},
	adsLength = .5,
	ammo = 9999,
	maxAmmo = 9999,
	reserveAmmo = 9999,
	togglableFireModes = { fireMode.shotgun },
	reloadSpeed = 1.5,
	recoilRegroupTime = 1.5,
	spreadHipfirePenalty = 1.1,
	spreadMovementHipfirePenalty = 1.2,
	spreadDelta = 1.15,
	spreadPopTime = 1.5,
	spreadUpPerShot = .25,
	maxAllowedSpread = 35,
	recoilPattern = tableUtils.toMap({ NumberRange.new(0, 90) }, { { Vector3.new(.4, .5, -.4 * 5), Vector3.new(.8, .8, -.6 * 5) } }),
	reloadType = reloadType.shell,
	unaimAfterShot = true,
	shellPath = "ReplicatedStorage//gunAddons//blue_shotgun_shell",
}
return m870_config
