-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "path").default
local item = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "base", "item").default
local paths = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "paths")
local gun
do
	local super = item
	gun = setmetatable({}, {
		__tostring = function()
			return "gun"
		end,
		__index = super,
	})
	gun.__index = gun
	function gun:constructor(serverItemIndentification, pathToGun)
		super.constructor(self, serverItemIndentification)
		self.typeIdentifier = gunwork.itemTypeIdentifier.gun
		self.connections = {}
		self.lastFired = 0
		self.currentFiremode = 0
		self.lastFiremodeSwitch = 0
		self.lastRecoil = 0
		self.currentRecoilIndex = 0
		self.lastReload = 0
		self.spreadDelta = 0
		self.values = {
			aimDelta = Instance.new("NumberValue"),
		}
		self.sprinting = false
		self.aiming = false
		self.reloading = false
		self.stance = 1
		self.lastLeanDirection = 0
		self.leanDirection = 0
		self.inspecting = false
		self.sneaking = false
		self.proneChanging = false
		self.wantsToSprint = false
		self.wantsToAim = false
		self.cframes = {
			idle = CFrame.new(),
			leanOffset = CFrame.new(),
			aimOffset = CFrame.new(),
			sprintOffset = CFrame.new(),
		}
		self.spread = 0
		self.firerate = {
			auto = 0,
			semi = 0,
			burst2 = 0,
			burst3 = 0,
			burst4 = 0,
			shotgun = 0,
		}
		self.reloadSpeed = 0
		self.penetration = 0
		self.bodyDamage = 0
		self.limbDamage = 0
		self.headDamage = 0
		self.canAimWith = true
		self.canLeanWith = true
		self.canSprintWith = true
		self.togglableFireModes = { gunwork.fireMode.auto, gunwork.fireMode.semi }
		self.firemodeSwitchCooldown = .75
		self.recoilPattern = {}
		self.recoilRegroupTime = 1
		self.penetrationDamageFalloff = 0
		self.ammo = 0
		self.maxAmmo = 0
		self.initialAmmo = 0
		self.reserveAmmo = 0
		self.ammoOverload = 0
		self.weightMultiplier = 0
		self.spreadHipfirePenalty = 0
		self.spreadMovementHipfirePenalty = 0
		self.spreadUpPerShot = 0
		self.maxAllowedSpread = 0
		self.spreadPopTime = 0
		-- get the gun model from path
		local gun = path:sure(pathToGun):Clone()
		-- get the viewmodel from path
		local viewmodel = path:sure(paths.fps.standard_viewmodel):Clone()
		-- copy gun stuff to the viewmodel
		local _exp = gun:GetChildren()
		local _arg0 = function(v)
			v.Parent = viewmodel
			if v.Name == "aimpart" then
				viewmodel.PrimaryPart = v
			end
		end
		for _k, _v in ipairs(_exp) do
			_arg0(_v, _k - 1, _exp)
		end
		-- setup attachments if possible
		-- connect motor6ds
		-- set viewmodel far below!
		-- load animations!
		self.viewmodel = viewmodel
	end
	function gun:fire()
		if not self.firePoint and not self.camera then
			error("fire can not be called without a character or camera")
		end
		local fireCFrame = if self.camera then self.camera.CFrame else (self.firePoint).CFrame
	end
	function gun:aim(t)
	end
	function gun:update(dt)
	end
end
return {
	default = gun,
}
