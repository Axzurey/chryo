-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverItem = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "serverItem").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "rocast").default
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").newThread
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "space")
local _examine = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "examine")
local examine = _examine
local examineHitLocation = _examine.examineHitLocation
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork")
local itemTypeIdentifier = _gunwork.itemTypeIdentifier
local reloadType = _gunwork.reloadType
local entityType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "zeroDefinitions").entityType
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
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
	function serverGun:constructor(serverId, characterClass)
		super.constructor(self, serverId)
		self.characterClass = characterClass
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
		self.reloadType = reloadType.shell
		self.lastFeed = tick()
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
	function serverGun:feedSingle()
		if self.reloadType == reloadType.shell then
			if self.ammo >= self.maxAmmo then
				return nil
			end
			if tick() - self.lastFeed < .15 then
				return nil
			end
			self.lastFeed = tick()
			self.ammo += 1
		end
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
		local ammoLeftInReserve = self.reserveAmmo
		local ammoMaxInMag = self.maxAmmo + self.magazineOverload
		local current = self.maxAmmo
		local ammoDifference = ammoMaxInMag - current
		if ammoLeftInReserve >= ammoDifference then
			-- they have enough to reload a full mag
			ammoLeftInReserve -= ammoDifference
			self.ammo = ammoMaxInMag
		else
			-- they don't have enough to reload a full mag
			self.ammo += ammoLeftInReserve
			self.reserveAmmo = 0
		end
	end
	function serverGun:determineWhatToDoWithImpact(hit, v)
		if hit then
			local rx = hit[4]
			if rx then
				local _subHits = rx.subHits
				local _arg0 = function(vx)
					self:determineWhatToDoWithImpact({ vx.instance, vx.position, false, nil }, v)
				end
				for _k, _v in ipairs(_subHits) do
					_arg0(_v, _k - 1, _subHits)
				end
			end
			if hit[1].Mass < 1 then
				if hit[1].Anchored then
					return nil
				end
				local z = hit[1]:GetNetworkOwner()
				local r = hit[1]:GetConnectedParts()
				if #r > 1 then
					return nil
				end
				if not z then
					hit[1]:ApplyImpulseAtPosition(v.LookVector, hit[2])
				else
					system.remote.server.fireClient("clientFlingBasepart", z, hit[1], hit[2], v.LookVector)
				end
			else
				if hit[3] and hit[4] then
					self.source.images.normal:spawn(hit[4].position, hit[4].normal, 1)
				end
			end
		end
	end
	function serverGun:fireMulti(cameraCFrames)
		if not self.userEquipped then
			return nil
		end
		if self.reloading then
			return nil
		end
		if self.ammo <= 0 then
			return nil
		end
		if not self.characterClass:isAlive() then
			return nil
		end
		self.ammo -= 1
		local _arg0 = function(v)
			local hit = self:handleFire(v)
			self:determineWhatToDoWithImpact(hit, v)
		end
		for _k, _v in ipairs(cameraCFrames) do
			_arg0(_v, _k - 1, cameraCFrames)
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
		if not self.characterClass:isAlive() then
			return nil
		end
		self.ammo -= 1
		local hit = self:handleFire(cameraCFrame)
		self:determineWhatToDoWithImpact(hit, cameraCFrame)
	end
	function serverGun:handleFire(cameraCFrame)
		if not self.source.images then
			return nil
		end
		local caster = rocaster.new({
			from = cameraCFrame.Position,
			direction = cameraCFrame.LookVector,
			maxDistance = 999,
			ignore = { self:getUser().Character },
			ignoreNames = { "HumanoidRootPart", "imageBackdrop" },
			debug = false,
		})
		local castResult = caster:cast({
			canPierce = function(result)
				if result.Instance.Mass < 1 then
					return true
				end
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
			local nominal = true
			if entity and space.query.entityIsThatIfOfType(entity, entityType.human) then
				local location = examineHitLocation(castResult.instance)
				if location == examine.hitLocation.head then
					entity:takeDamage(self.damage.head)
				elseif location == examine.hitLocation.body then
					entity:takeDamage(self.damage.body)
				else
					entity:takeDamage(self.damage.limb)
				end
				nominal = false
			end
			return { castResult.instance, castResult.position, nominal, castResult }
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
