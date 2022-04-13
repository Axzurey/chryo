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
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local TweenService = _services.TweenService
local animationCompile = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "animate").default
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
	function gun:constructor(serverItemIdentification, pathToGun, attachments, animationIDS)
		super.constructor(self, serverItemIdentification)
		self.serverItemIdentification = serverItemIdentification
		self.pathToGun = pathToGun
		self.attachments = attachments
		self.animationIDS = animationIDS
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
			cameraBob = CFrame.new(),
			viewmodelBob = CFrame.new(),
		}
		local _object = {
			leanRight = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-25)),
			leanLeft = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(25)),
		}
		local _left = "leanRightCamera"
		local _cFrame = CFrame.new(.7, 0, 0)
		local _arg0 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-10))
		_object[_left] = _cFrame * _arg0
		local _left_1 = "leanLeftCamera"
		local _cFrame_1 = CFrame.new(-.7, 0, 0)
		local _arg0_1 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(10))
		_object[_left_1] = _cFrame_1 * _arg0_1
		_object.crouchOffset = CFrame.new(0, -1, 0)
		_object.proneOffset = CFrame.new(0, -3, 0)
		self.staticOffsets = _object
		self.values = {
			aimDelta = Instance.new("NumberValue"),
			leanOffsetViewmodel = Instance.new("CFrameValue"),
			leanOffsetCamera = Instance.new("CFrameValue"),
			stanceOffset = Instance.new("CFrameValue"),
		}
		self.multipliers = {
			speed = {
				prone = .2,
				crouch = .5,
			},
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
		self.crouchTranitionTime = .25
		self.proneTransitionTime = .5
		self.character = Players.LocalPlayer.Character
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
		utils.instanceUtils.unanchorAllDescendants(viewmodel)
		utils.instanceUtils.nominalizeAllDescendants(viewmodel)
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
		local m2 = Instance.new("Motor6D")
		m2.Part0 = vm.rootpart
		m2.Part1 = ap
		m2.Name = "rootMotor"
		m2.Parent = vm
		viewmodel.PrimaryPart = viewmodel.aimpart
		-- setup attachments if possible
		-- load animations!
		self.viewmodel = viewmodel
		self.viewmodel:SetPrimaryPartCFrame(clientExposed:getCamera().CFrame)
		local idleanim = animationCompile:create(animationIDS.idle):final()
		self.viewmodel.Parent = clientExposed:getCamera()
		self.loadedAnimations = {
			idle = viewmodel.controller.animator:LoadAnimation(idleanim),
		}
		self.viewmodel.Parent = nil
		if attachments.sight then
			local sightmodel = path:sure(attachments.sight.path):Clone()
			sightmodel:SetPrimaryPartCFrame(viewmodel.sightNode.CFrame)
			sightmodel.Parent = viewmodel
			local md = Instance.new("Motor6D")
			md.Part0 = viewmodel.sightNode
			md.Part1 = sightmodel.PrimaryPart
			md.Parent = sightmodel.PrimaryPart
			viewmodel.aimpart.Position = sightmodel.focus.Position
			print(viewmodel.aimpart.Position, "vs", sightmodel.focus.Position)
			task.wait(1)
			print(viewmodel.aimpart.Position, "vs", sightmodel.focus.Position)
			newThread(function()
				while true do
					task.wait(.25)
					print(viewmodel.aimpart.Position, "vs", sightmodel.focus.Position)
				end
			end)
		end
		utils.instanceUtils.unanchorAllDescendants(viewmodel)
		utils.instanceUtils.nominalizeAllDescendants(viewmodel)
		viewmodel.aimpart.Anchored = true
		self.viewmodel.Parent = clientExposed:getCamera()
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
			local info = TweenInfo.new(self.leanLength)
			local val = CFrame.new()
			local camval = CFrame.new()
			if t == self.leanDirection then
				t = 0
			end
			self.leanDirection = t
			if t == 1 then
				val = self.staticOffsets.leanRight
				camval = self.staticOffsets.leanRightCamera
			elseif t == -1 then
				val = self.staticOffsets.leanLeft
				camval = self.staticOffsets.leanLeftCamera
			end
			TweenService:Create(self.values.leanOffsetViewmodel, info, {
				Value = val,
			}):Play()
			TweenService:Create(self.values.leanOffsetCamera, info, {
				Value = camval,
			}):Play()
		end)
	end
	function gun:changeStance(t)
		newThread(function()
			if t == self.stance then
				if t == 0 then
					t = 1
				elseif t == -1 then
					t = 0
				end
			end
			local value = if t == 1 then CFrame.new() elseif t == 0 then self.staticOffsets.crouchOffset else self.staticOffsets.proneOffset
			local info = TweenInfo.new(if self.stance == -1 or t == -1 then self.proneTransitionTime else self.crouchTranitionTime)
			TweenService:Create(self.values.stanceOffset, info, {
				Value = value,
			}):Play()
			self.stance = t
			if t == -1 then
				self.proneChanging = true
				task.wait(info.Time)
				self.proneChanging = false
			end
		end)
	end
	function gun:update(dt)
		if not self.viewmodel.PrimaryPart then
			return nil
		end
		self.cframes.idle = self.viewmodel.offsets.idle.Value
		local movedirection = self.character.Humanoid.MoveDirection
		local camera = clientExposed:getCamera()
		local idleOffset = self.cframes.idle:Lerp(CFrame.new(0, 0, if self.attachments.sight then -self.attachments.sight.zOffset else 0), self.values.aimDelta.Value)
		local cx, cy, cz = camera.CFrame:ToOrientation()
		local function bobLemnBern(speed, intensity)
			local t = tick() * speed
			local scale = 2 / (3 - math.cos(2 * t))
			return { scale * math.cos(t) * intensity, scale * math.sin(2 * t) / 2 * intensity }
		end
		local oscMVMT = bobLemnBern(self.character.Humanoid.WalkSpeed * .4, self.character.Humanoid.WalkSpeed * .005)
		local _fn = self.cframes.viewmodelBob
		local _result
		if movedirection.Magnitude == 0 then
			_result = CFrame.new()
		else
			local _vector3 = Vector3.new(oscMVMT[2], oscMVMT[1], 0)
			local _arg0 = if self.aiming then 0.1 else 1
			_result = CFrame.new(_vector3 * _arg0)
		end
		self.cframes.viewmodelBob = _fn:Lerp(_result, .1)
		local _fn_1 = self.viewmodel
		local _cFrame = CFrame.new(camera.CFrame.Position)
		local _value = self.values.stanceOffset.Value
		local _arg0 = CFrame.fromOrientation(cx, cy, cz)
		local _idleOffset = idleOffset
		local _value_1 = self.values.leanOffsetCamera.Value
		local _value_2 = self.values.leanOffsetViewmodel.Value
		_fn_1:SetPrimaryPartCFrame(_cFrame * _value * _arg0 * _idleOffset * _value_1 * _value_2)
		local _cFrame_1 = CFrame.new(camera.CFrame.Position)
		local _value_3 = self.values.stanceOffset.Value
		local _arg0_1 = CFrame.fromOrientation(cx, cy, cz)
		local _value_4 = self.values.leanOffsetCamera.Value
		camera.CFrame = _cFrame_1 * _value_3 * _arg0_1 * _value_4
		self.viewmodel.Parent = camera
		self.character.Humanoid.WalkSpeed = clientExposed:getBaseWalkSpeed() * (if self.stance == -1 then self.multipliers.speed.prone else (if self.stance == 0 then self.multipliers.speed.crouch else 1))
		if not self.loadedAnimations.idle.IsPlaying then
			self.loadedAnimations.idle:Play()
		end
	end
end
return {
	default = gun,
}
