-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "path").default
local item = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "base", "item").default
local paths = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "paths")
local _clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed")
local clientExposed = _clientExposed
local getClientConfig = _clientExposed.getClientConfig
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork")
local gunwork = _gunwork
local fireMode = _gunwork.fireMode
local reloadType = _gunwork.reloadType
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils")
local utils = _utils
local later = _utils.later
local newThread = _utils.newThread
local random = _utils.random
local tableUtils = _utils.tableUtils
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local TweenService = _services.TweenService
local UserInputService = _services.UserInputService
local animationCompile = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "animate").default
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
local mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "mathf")
local spring = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "base", "spring")
local tracer = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "tracer").default
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
		self.cameraCFrame = CFrame.new()
		self.lastFired = 0
		self.currentFiremode = 0
		self.lastFiremodeSwitch = 0
		self.fireButtonDown = false
		self.currentRecoilIndex = 0
		self.currentReloadId = nil
		self.lastReload = 0
		self.spreadDelta = 0
		self.sprinting = false
		self.togglingAim = false
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
		self.lastClickIdUsed = ""
		self.currentClickId = ""
		self.cframes = {
			idle = CFrame.new(),
			aimOffset = CFrame.new(),
			sprintOffset = CFrame.new(),
			cameraBob = CFrame.new(),
			viewmodelBob = CFrame.new(),
		}
		self.loadedAnimations = {}
		local _object = {
			leanRight = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-16)),
			leanLeft = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(16)),
		}
		local _left = "leanRightCamera"
		local _cFrame = CFrame.new(1, 0, 0)
		local _arg0 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-5))
		_object[_left] = _cFrame * _arg0
		local _left_1 = "leanLeftCamera"
		local _cFrame_1 = CFrame.new(-1, 0, 0)
		local _arg0_1 = CFrame.fromEulerAnglesYXZ(0, 0, math.rad(5))
		_object[_left_1] = _cFrame_1 * _arg0_1
		_object.crouchOffset = CFrame.new(0, -1, 0)
		_object.proneOffset = CFrame.new(0, -3, 0)
		self.staticOffsets = _object
		self.springs = {
			recoil = spring:create(5, 75, 3, 4),
			viewmodelRecoil = spring:create(5, 85, 3, 10),
		}
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
		self.firerate = {
			auto = 0,
			semi = 0,
			burst2 = 0,
			burst3 = 0,
			burst4 = 0,
			shotgun = 0,
		}
		self.unaimAfterShot = false
		self.bulletsAShot = {
			[fireMode.auto] = 1,
			[fireMode.semi] = 1,
			[fireMode.burst2] = 2,
			[fireMode.burst3] = 3,
			[fireMode.burst4] = 4,
			[fireMode.shotgun] = 8,
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
		self.reloadType = reloadType.mag
		self.recoilPattern = {}
		self.recoilRegroupTime = 1
		self.penetrationDamageFalloff = 0
		self.tracerColor = Color3.new(0, 1, 1)
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
		self.shellPath = nil
		self.character = Players.LocalPlayer.Character
		self.lastPosition = self.character:GetPrimaryPartCFrame().Position
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
		self.viewmodel:SetPrimaryPartCFrame(clientExposed.getCamera().CFrame)
		self.viewmodel.Parent = clientExposed.getCamera()
		for name, id in pairs(animationIDS) do
			local anim = animationCompile:create(id)
			local final = anim:final()
			self.loadedAnimations[name] = viewmodel.controller.animator:LoadAnimation(final)
			anim:cleanUp()
		end
		if attachments.sight then
			local sightmodel = path:sure(attachments.sight.path):Clone()
			sightmodel:SetPrimaryPartCFrame(viewmodel.sightNode.CFrame)
			sightmodel.Parent = viewmodel
			local md = Instance.new("Motor6D")
			md.Part0 = viewmodel.sightNode
			md.Part1 = sightmodel.PrimaryPart
			md.Parent = sightmodel.PrimaryPart
			viewmodel.aimpart.Position = sightmodel.focus.Position
		end
		utils.instanceUtils.unanchorAllDescendants(viewmodel)
		utils.instanceUtils.nominalizeAllDescendants(viewmodel)
		self.viewmodel.Parent = nil
	end
	function gun:manualFire()
		local firemode = self.togglableFireModes[self.currentFiremode + 1]
		if not firemode then
			firemode = self.togglableFireModes[1]
		end
		if tick() - self.lastFired < 60 / self.firerate[firemode] then
			return nil
		end
		self:fire()
	end
	function gun:fire()
		newThread(function()
			if self.ammo <= 0 then
				self:startReload()
				return nil
			end
			self.camera = clientExposed.getCamera()
			if not self.firePoint and not self.camera then
				error("fire can not be called without a character or camera")
			end
			self.ammo -= 1
			self.lastFired = tick()
			self.lastClickIdUsed = self.currentClickId
			self.viewmodel.audio.fire:Play()
			local controller = clientExposed.getActionController()
			self.spreadDelta += self.spreadUpPerShot
			local spread = self.spreadDelta * (1 - self.values.aimDelta.Value * self.spreadHipfirePenalty) * (self.spreadMovementHipfirePenalty * self.character.Humanoid.MoveDirection.Magnitude + 1)
			spread = math.clamp(spread, 0, self.maxAllowedSpread)
			later(self.spreadPopTime, function()
				self.spreadDelta -= self.spreadUpPerShot
			end)
			local firemode = self.togglableFireModes[self.currentFiremode + 1]
			if not firemode then
				firemode = self.togglableFireModes[1]
			end
			local effectOrigin = self.viewmodel.barrel.muzzle.WorldPosition
			local cases
			cases = {
				[fireMode.shotgun] = function()
					local fireCFrame = self.cameraCFrame
					local cframes = {}
					do
						local i = 0
						local _shouldIncrement = false
						while true do
							if _shouldIncrement then
								i += 1
							else
								_shouldIncrement = true
							end
							if not (i < self.bulletsAShot.shotgun) then
								break
							end
							local spreadDirection = controller.crosshairController:getSpreadDirection(self.camera)
							local newFireCFrame = CFrame.lookAt(fireCFrame.Position, fireCFrame.Position + spreadDirection)
							local _cframes = cframes
							local _newFireCFrame = newFireCFrame
							table.insert(_cframes, _newFireCFrame)
							tracer.new(effectOrigin, spreadDirection, 1.5, self.tracerColor)
						end
					end
					controller.crosshairController:pushRecoil(spread, self.recoilRegroupTime)
					system.remote.client.fireServer("fireMultiContext", self.serverItemIdentification, cframes)
				end,
				[fireMode.auto] = function()
					local fireCFrame = self.cameraCFrame
					local spreadDirection = controller.crosshairController:getSpreadDirection(self.camera)
					local newFireCFrame = CFrame.lookAt(fireCFrame.Position, fireCFrame.Position + spreadDirection)
					tracer.new(effectOrigin, spreadDirection, 1.5, self.tracerColor)
					controller.crosshairController:pushRecoil(spread, self.recoilRegroupTime)
					system.remote.client.fireServer("fireContext", self.serverItemIdentification, newFireCFrame)
				end,
				[fireMode.semi] = function()
					local _ = cases[fireMode.auto]
				end,
				[fireMode.burst2] = function()
					local _ = cases[fireMode.auto]
				end,
				[fireMode.burst3] = function()
					local _ = cases[fireMode.auto]
				end,
				[fireMode.burst4] = function()
					local _ = cases[fireMode.auto]
				end,
			}
			if self.unaimAfterShot then
				controller.actionMap.aim(Enum.UserInputState.End)
				later(60 / self.firerate[firemode], function()
					if utils.peripherals.isButtonDown(controller:getKey("aim")) and not self.togglingAim then
						controller.actionMap.aim(Enum.UserInputState.Begin)
					end
				end)
				-- for user convenience, make this aim them back in if they still holding the button after a bit.
			end
			if self.loadedAnimations.pump then
				self.loadedAnimations.pump:Play()
				self.loadedAnimations.pump:GetMarkerReachedSignal("boltForward"):Connect(function()
					self.viewmodel.audio.boltforward:Play()
				end)
				self.loadedAnimations.pump:GetMarkerReachedSignal("boltBackward"):Connect(function()
					self.viewmodel.audio.boltback:Play()
				end)
			end
			cases[firemode]()
			local t = tick()
			self.lastFired = t
			local max = tableUtils.rangeUpperClamp(self.recoilPattern)
			local recoilIndex = if self.currentRecoilIndex >= max then max else self.currentRecoilIndex
			self.currentRecoilIndex += 1
			local add = utils.tableUtils.firstNumberRangeContainingNumber(self.recoilPattern, recoilIndex)
			local pickX = random:NextNumber(math.min(add[1].X, add[2].X), math.max(add[1].X, add[2].X)) * 1
			local pickY = random:NextNumber(math.min(add[1].Y, add[2].Y), math.max(add[1].Y, add[2].Y)) * 1
			local pickZ = random:NextNumber(math.min(add[1].Z, add[2].Z), math.max(add[1].Z, add[2].Z)) / 2
			self.springs.recoil:shove(Vector3.new(-pickX, pickY, pickZ))
			later(self.recoilRegroupTime, function()
				if self.lastFired ~= t then
					return nil
				end
				self.currentRecoilIndex -= 1
			end)
		end)
	end
	function gun:initiateSingleAnimation()
		if self.loadedAnimations.reloadStart then
			self.loadedAnimations.reloadStart:Play()
			task.wait(self.loadedAnimations.reloadStart.Length - .1)
		end
	end
	function gun:loadShell()
		local _value = self.shellPath
		if _value ~= "" and _value then
			local c = path:getInstance(self.shellPath)
			if c then
				c = c:Clone()
				c.Parent = self.viewmodel
				local m6d = Instance.new("Motor6D")
				m6d.Part0 = self.viewmodel.aimpart
				m6d.Part1 = c.PrimaryPart
				m6d.Parent = self.viewmodel.aimpart
			else
				error("path " .. (self.shellPath .. " is invalid"))
			end
			return c
		end
	end
	function gun:reloadSingle()
		system.remote.client.fireServer("reloadFeedSingleContext", self.serverItemIdentification)
		if self.loadedAnimations.reloadFill then
			self.loadedAnimations.reloadFill:Play()
			task.wait(self.loadedAnimations.reloadFill.Length)
		end
	end
	function gun:startReload()
		newThread(function()
			if self.reloading then
				return nil
			end
			local reloadId = HttpService:GenerateGUID()
			self.currentReloadId = reloadId
			self.reloading = true
			system.remote.client.fireServer("reloadStartContext", self.serverItemIdentification)
			task.wait(self.reloadSpeed)
			local _condition = self.reloading
			if _condition then
				_condition = self.currentReloadId
				if _condition ~= "" and _condition then
					_condition = self.currentReloadId == reloadId
				end
			end
			if _condition ~= "" and _condition then
				self:finishReload()
			end
		end)
	end
	function gun:finishReload()
		if self.reloading then
			system.remote.client.fireServer("reloadEndContext", self.serverItemIdentification)
		end
	end
	function gun:cancelReload()
		if not self.reloading then
			return nil
		end
		self.reloading = false
		self.currentReloadId = nil
		system.remote.client.fireServer("reloadCancelContext", self.serverItemIdentification)
	end
	function gun:aim(t)
		newThread(function()
			self.togglingAim = true
			local diff = if t then self.adsLength - mathf.lerp(0, self.adsLength, self.values.aimDelta.Value) else self.adsLength
			local info = TweenInfo.new(diff, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			TweenService:Create(self.values.aimDelta, info, {
				Value = if t then 1 else 0,
			}):Play()
			task.wait(diff)
			self.togglingAim = false
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
		self.viewmodel.aimpart.Anchored = true
		local firemode = self.togglableFireModes[self.currentFiremode + 1]
		if not firemode then
			firemode = self.togglableFireModes[1]
		end
		newThread(function()
			if not self.fireButtonDown then
				return nil
			end
			if firemode == fireMode.semi or firemode == fireMode.shotgun then
				return nil
			end
			self:manualFire()
			-- the server will verify firemode separately. fire needs only be called once
			--[[
				*
				switch (firemode) {
				case fireMode.auto:
				this.fire();
				break;
				case fireMode.burst2:
				for (let i = 0; i < 2; i++) {
				this.fire();
				task.wait(this.firerate.burst4);
				}
				break;
				case fireMode.burst3:
				for (let i = 0; i < 3; i++) {
				this.fire();
				task.wait(this.firerate.burst4);
				}
				break;
				case fireMode.burst4:
				for (let i = 0; i < 4; i++) {
				this.fire();
				task.wait(this.firerate.burst4);
				}
				break;
				case fireMode.semi:
				this.fire();
				break;
				default:
				break;
				}
			]]
		end)
		self.cframes.idle = self.viewmodel.offsets.idle.Value
		local movedirection = self.character.Humanoid.MoveDirection
		local camera = clientExposed.getCamera()
		local idleOffset = self.cframes.idle:Lerp(CFrame.new(0, 0, if self.attachments.sight then -self.attachments.sight.zOffset else 0), self.values.aimDelta.Value)
		local cx, cy, cz = camera.CFrame:ToOrientation()
		local t = tick()
		local velocity = self.character.PrimaryPart.AssemblyLinearVelocity
		local roundedMagXZ = math.round(Vector2.new(velocity.X, velocity.Z).Magnitude)
		local f = t * roundedMagXZ / 1.5 + tick()
		local tx = math.cos(f) * .05
		local ty = math.abs(math.sin(f)) * .05
		local _fn = self.cframes.viewmodelBob
		local _vector3 = Vector3.new(tx, ty)
		local _arg0 = 1 - self.values.aimDelta.Value + (roundedMagXZ / 50 * (1 - self.values.aimDelta.Value))
		self.cframes.viewmodelBob = _fn:Lerp(CFrame.new(_vector3 * _arg0), .1)
		local recoilUpdated = self.springs.recoil:update(dt)
		local _fn_1 = self.viewmodel
		local _cFrame = CFrame.new(camera.CFrame.Position)
		local _value = self.values.stanceOffset.Value
		local _arg0_1 = CFrame.fromOrientation(cx, cy, cz)
		local _idleOffset = idleOffset
		local _value_1 = self.values.leanOffsetCamera.Value
		local _value_2 = self.values.leanOffsetViewmodel.Value
		local _viewmodelBob = self.cframes.viewmodelBob
		local _cFrame_1 = CFrame.new(0, 0, recoilUpdated.Z)
		_fn_1:SetPrimaryPartCFrame(_cFrame * _value * _arg0_1 * _idleOffset * _value_1 * _value_2 * _viewmodelBob * _cFrame_1)
		local _cFrame_2 = CFrame.new(camera.CFrame.Position)
		local _value_3 = self.values.stanceOffset.Value
		local _arg0_2 = CFrame.fromOrientation(cx, cy, cz)
		local _value_4 = self.values.leanOffsetCamera.Value
		local _arg0_3 = CFrame.Angles(math.rad(recoilUpdated.Y), math.rad(recoilUpdated.X), 0)
		camera.CFrame = _cFrame_2 * _value_3 * _arg0_2 * _value_4 * _arg0_3
		self.cameraCFrame = camera.CFrame
		self.viewmodel.Parent = camera
		self.character.Humanoid.WalkSpeed = clientExposed.getBaseWalkSpeed() * (if self.stance == -1 then self.multipliers.speed.prone else (if self.stance == 0 then self.multipliers.speed.crouch else 1))
		local generalSettings = getClientConfig().settings.general
		local lerpedADS = mathf.lerp(generalSettings.sensitivity, generalSettings.adsSensitivity, self.values.aimDelta.Value)
		UserInputService.MouseDeltaSensitivity = lerpedADS
		if self.loadedAnimations.idle and not self.loadedAnimations.idle.IsPlaying then
			self.loadedAnimations.idle:Play()
		end
	end
end
return {
	default = gun,
}
