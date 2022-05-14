-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverItem = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "serverItem").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "rocast").default
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").newThread
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space")
local _examine = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "examine")
local examine = _examine
local examineHitLocation = _examine.examineHitLocation
local itemTypeIdentifier = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork").itemTypeIdentifier
local entityType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "define", "zeroDefinitions").entityType
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
		self.source = {}
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
		self.ammo = 10
		self.userEquipped = true
		self.typeIdentifier = itemTypeIdentifier.gun
		self.damage = {
			head = 1000,
			body = 32,
			limb = 20,
		}
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
	function serverGun:fire(cameraCFrame)
		if not self.userEquipped then
			return nil
		end
		if self.reloading then
			return nil
		end
		if self.ammo <= 0 then
			return nil
		end
		if not self.source.images then
			return nil
		end
		self.ammo -= 1
		local caster = rocaster.new({
			from = cameraCFrame.Position,
			direction = cameraCFrame.LookVector,
			maxDistance = 999,
			ignore = { self:getUser().Character },
			ignoreNames = { "HumanoidRootPart" },
			debug = false,
		})
		local castResult = caster:cast({
			canPierce = function(result)
				return nil
				--[[
					return {
					damageMultiplier: 1,
					weight: 1
					}
				]]
			end,
		})
		if castResult then
			local entity = space.query.findFirstEntityWithVesselThatContainsInstance(castResult.instance)
			if entity and space.query.entityIsThatIfOfType(entity, entityType.human) then
				local location = examineHitLocation(castResult.instance)
				if location == examine.hitLocation.head then
					entity:takeDamage(self.damage.head)
				elseif location == examine.hitLocation.body then
					entity:takeDamage(self.damage.body)
				else
					entity:takeDamage(self.damage.limb)
				end
			else
				self.source.images.normal:spawn(castResult.position, castResult.normal, 1)
			end
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
