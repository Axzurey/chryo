-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverGun = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverExtended", "serverGun").default
local function hk416_server_definition(id)
	local gun = serverGun.new(id)
	gun.ammo = 999
	gun.maxAmmo = 999
	gun.reserveAmmo = 999
	return gun
end
return {
	default = hk416_server_definition,
}
