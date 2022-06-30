-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverGun = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverClasses", "serverGun").default
local images = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "source").images
local function hk416_server_definition(id, characterClass)
	local gun = serverGun.new(id, characterClass)
	gun.ammo = 999
	gun.maxAmmo = 999
	gun.reserveAmmo = 999
	gun.source.images = {
		normal = images.bullet_hole_default,
		glass = images.bullet_hole_glass,
		metal = images.bullet_hole_default,
	}
	return gun
end
return {
	default = hk416_server_definition,
}
