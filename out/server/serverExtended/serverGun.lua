-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverItem = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "serverItem").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "rocast").default
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").newThread
local serverGun
do
	local super = serverItem
	serverGun = setmetatable({}, {
		__tostring = function()
			return "serverGun"
		end,
		__index = super,
	})
	serverGun.__index = serverGun
	function serverGun.new(...)
		local self = setmetatable({}, serverGun)
		return self:constructor(...) or self
	end
	function serverGun:constructor(serverId)
		super.constructor(self, serverId)
		self.ammo = 0
		self.maxAmmo = 0
		self.reserveAmmo = 0
		self.magazineOverload = 0
		self.damage = {
			body = 0,
			head = 0,
			limb = 0,
		}
		self.reloadSpeed = 1.5
		self.reloadSpeedMin = 1
		self.reloadSpeedMax = 3
		self.reloadStarted = tick()
		self.reloading = false
	end
	function serverGun:getRemotes()
	end
	function serverGun:startReload()
		if self.reloading then
			return nil
		end
		if self.maxAmmo - (self.ammo + self.magazineOverload) <= 0 then
			return nil
		end
		self.reloadStarted = tick()
		self.reloading = true
	end
	function serverGun:cancelReload()
		self.reloading = false
	end
	function serverGun:finishReload()
		if self.maxAmmo - (self.ammo + self.magazineOverload) <= 0 then
			return nil
		end
		if not self.reloading then
			return nil
		end
		local diff = tick() - self.reloadStarted
		if diff > self.reloadSpeedMax or diff < self.reloadSpeedMin then
			return nil
		end
	end
	function serverGun:fire(from, direction)
		if not self.userEquipped then
			return nil
		end
		if self.reloading then
			return nil
		end
		if self.ammo <= 0 then
			return nil
		end
		self.ammo -= 1
		local caster = rocaster.new({
			from = from,
			direction = direction,
			maxDistance = 999,
			ignore = {},
		})
		local castResult = caster:cast({
			canPierce = function(result)
				return {
					damageMultiplier = 1,
					weight = 1,
				}
			end,
		})
		if not castResult then
			return nil
		end
	end
	function serverGun:equip()
		newThread(function()
			if self.canBeEquipped and self.canUserEquip then
				self.userEquipping = true
				task.wait(self.equipTime)
				self.userEquipped = true
			end
		end)
	end
end
return {
	default = serverGun,
}
