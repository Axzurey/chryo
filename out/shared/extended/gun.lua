-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "path").default
local item = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "base", "item").default
local paths = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "paths")
local clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed").default
local gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork")
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils")
local utils = _utils
local newThread = _utils.newThread
local TweenService = TS.import(script, TS.getModule(script, "@rbxts", "services")).TweenService
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
	function gun.new(...)
		local self = setmetatable({}, gun)
		return self:constructor(...) or self
	end
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
			aimOffset = CFrame.new(),
			sprintOffset = CFrame.new(),
		}
		local _object = {}
		local _left = "leanRight"
		local _cFrame = CFrame.new(.1, 0, 0)
		local _arg0 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-35))
		_object[_left] = _cFrame * _arg0
		local _left_1 = "leanLeft"
		local _cFrame_1 = CFrame.new(-.1, 0, 0)
		local _arg0_1 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(35))
		_object[_left_1] = _cFrame_1 * _arg0_1
		self.staticOffsets = _object
		self.values = {
			aimDelta = Instance.new("NumberValue"),
			leanOffsetViewmodel = Instance.new("CFrameValue"),
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
		self.adsLength = .5
		self.leanLength = .35
		-- get the gun model from path
		local gun = path:sure(pathToGun):Clone()
		-- get the viewmodel from path
		local viewmodel = path:sure(paths.fps.standard_viewmodel):Clone()
		-- copy gun stuff to the viewmodel
		local _exp = gun:GetChildren()
		local _arg0_2 = function(v)
			v.Parent = viewmodel
		end
		for _k, _v in ipairs(_exp) do
			_arg0_2(_v, _k - 1, _exp)
		end
		utils.instanceUtils.anchorAllChildren(viewmodel)
		utils.instanceUtils.nominalizeAllChildren(viewmodel)
		local ap = viewmodel.aimpart
		local vm = viewmodel
		local m0 = Instance.new("Motor6D")
		m0.Part0 = ap
		m0.Name = "rightMotor"
		m0.Part1 = vm.rightArm
		m0.Parent = vm
		local m1 = Instance.new("Motor6D")
		m1.Part0 = ap
		m1.Part1 = vm.leftArm
		m1.Name = "leftMotor"
		m1.Parent = vm
		viewmodel.PrimaryPart = viewmodel.aimpart
		-- setup attachments if possible
		-- load animations!
		self.viewmodel = viewmodel
		self.viewmodel:SetPrimaryPartCFrame(CFrame.new(0, 10000, 0))
	end
	function gun:fire()
		newThread(function()
			if not self.firePoint and not self.camera then
				error("fire can not be called without a character or camera")
			end
			local fireCFrame = if self.camera then self.camera.CFrame else (self.firePoint).CFrame
		end)
	end
	function gun:aim(t)
		newThread(function()
			local info = TweenInfo.new(self.adsLength, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			TweenService:Create(self.values.aimDelta, info, {
				Value = if t then 1 else 0,
			}):Play()
			task.wait(self.adsLength)
			self.aiming = t
		end)
	end
	function gun:lean(t)
		newThread(function()
			local info = TweenInfo.new(self.leanLength, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
			local val = CFrame.new()
			if t == self.leanDirection then
				t = 0
			end
			self.leanDirection = t
			if t == 1 then
				val = self.staticOffsets.leanRight
			elseif t == -1 then
				val = self.staticOffsets.leanLeft
			end
			TweenService:Create(self.values.leanOffsetViewmodel, info, {
				Value = val,
			}):Play()
		end)
	end
	function gun:update(dt)
		if not self.viewmodel.PrimaryPart then
			return nil
		end
		self.cframes.idle = self.viewmodel.offsets.idle.Value
		local camera = clientExposed:getCamera()
		local idleOffset = self.cframes.idle:Lerp(CFrame.new(), self.values.aimDelta.Value)
		local _idleOffset = idleOffset
		local _value = self.values.leanOffsetViewmodel.Value
		idleOffset = _idleOffset * _value
		local _cFrame = camera.CFrame
		local _idleOffset_1 = idleOffset
		local finalCameraCframe = _cFrame * _idleOffset_1
		self.viewmodel:SetPrimaryPartCFrame(finalCameraCframe)
		self.viewmodel.Parent = camera
	end
end
return {
	default = gun,
}
