-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").newThread
local crosshairController = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "crosshairController").default
local hk416_definition = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunDefinitions", "hk416").default
local m870_definition = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunDefinitions", "m870").default
local clientConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientConfig").default
local rappel = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "rappel")
local vault = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "vault")
local _clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed")
local clientExposed = _clientExposed
local getCamera = _clientExposed.getCamera
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork")
local gunwork = _gunwork
local fireMode = _gunwork.fireMode
local reloadType = _gunwork.reloadType
local key = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "key").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "rocast").default
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
local drone = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "drone").default
local client = Players.LocalPlayer
local actionController
do
	actionController = setmetatable({}, {
		__tostring = function()
			return "actionController"
		end,
	})
	actionController.__index = actionController
	function actionController.new(...)
		local self = setmetatable({}, actionController)
		return self:constructor(...) or self
	end
	function actionController:constructor()
		self.itemBeingEquipped = false
		self.keybinds = {
			aim = Enum.UserInputType.MouseButton2,
			fire = Enum.UserInputType.MouseButton1,
			reload = Enum.KeyCode.R,
			leanRight = Enum.KeyCode.E,
			leanLeft = Enum.KeyCode.Q,
			prone = Enum.KeyCode.LeftControl,
			crouch = Enum.KeyCode.C,
			vault = Enum.KeyCode.Space,
			rappel = Enum.KeyCode.Space,
			reinforce = Enum.KeyCode.V,
			throwDrone = Enum.KeyCode.Six,
			toggleCameras = Enum.KeyCode.Five,
			primary = Enum.KeyCode.One,
			secondary = Enum.KeyCode.Two,
		}
		self.vaulting = false
		self.rappelling = false
		self.idlePrompts = {}
		self.crosshairController = crosshairController.new()
		self.start = Enum.UserInputState.Begin
		self["end"] = Enum.UserInputState.End
		self.cameras = {}
		self.actionMap = {
			aim = function(state)
				if self:equippedIsAGun(self.equippedItem) then
					print("aim switch!")
					local gun = self.equippedItem
					gun:cancelReload()
					gun:aim(if state == Enum.UserInputState.Begin then true else false)
					self.crosshairController:toggleVisible(state == Enum.UserInputState.Begin, gun.adsLength * .75)
				end
			end,
			fire = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					local firemode = gun.togglableFireModes[gun.currentFiremode + 1]
					if not firemode then
						firemode = gun.togglableFireModes[1]
					end
					if firemode == fireMode.semi or firemode == fireMode.shotgun then
						gun:manualFire()
					else
						gun:cancelReload()
						gun.fireButtonDown = true
						gun.currentClickId = HttpService:GenerateGUID()
					end
				elseif self:ending(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:cancelReload()
					gun.fireButtonDown = false
				end
			end,
			reload = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					if gun.reloading then
						return nil
					end
					if gun.reloadType == reloadType.mag then
						gun:startReload()
					elseif gun.reloadType == reloadType.shell then
						local diff = gun.maxAmmo - gun.ammo
						gun.reloading = true
						gun:initiateSingleAnimation()
						local shell = gun:loadShell()
						do
							local i = 0
							local _shouldIncrement = false
							while true do
								if _shouldIncrement then
									i += 1
								else
									_shouldIncrement = true
								end
								if not (i < diff) then
									break
								end
								gun:reloadSingle()
								-- task.wait(gun.reloadSpeed / gun.maxAmmo);
								if gun.maxAmmo - gun.ammo <= 0 then
									break
								end
							end
						end
						if shell then
							shell:Destroy()
						end
						gun.reloading = false
					end
				end
				return "TODO"
			end,
			leanLeft = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:lean(-1)
				end
			end,
			leanRight = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:lean(1)
				end
			end,
			crouch = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:changeStance(0)
				end
			end,
			prone = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:changeStance(-1)
				end
			end,
			vault = function(state)
				if self:starting(state) then
					local ignore = RaycastParams.new()
					ignore.FilterDescendantsInstances = { clientExposed.getCamera(), Players.LocalPlayer.Character }
					vault.Vault(ignore)
				end
			end,
			rappel = TS.async(function(state)
				if self:starting(state) then
					local ignore = RaycastParams.new()
					ignore.FilterDescendantsInstances = { clientExposed.getCamera(), Players.LocalPlayer.Character }
					if not rappel.check(ignore) then
						return nil
					end
					local _idlePrompts = self.idlePrompts
					table.insert(_idlePrompts, 0)
					local hold = TS.await(key:waitForKeyUp({
						key = self:getKey("rappel"),
						maxLength = 1,
						onUpdate = function(elapsedTime) end,
					}))
					local _exp = self.idlePrompts
					_exp[#_exp] = nil
					if hold < 1 then
						return nil
					end
					rappel.Rappel(ignore)
				end
			end),
			reinforce = TS.async(function(state)
				local reinforceRange = 8
				if self:starting(state) then
					local cameraCFrame = getCamera().CFrame
					local _lookVector = cameraCFrame.LookVector
					local _vector3 = Vector3.new(0, cameraCFrame.LookVector.Y, 0)
					local lookvector = _lookVector - _vector3
					local caster = rocaster.new({
						from = cameraCFrame.Position,
						direction = lookvector,
						maxDistance = reinforceRange,
						ignore = { client.Character },
						ignoreNames = { "HumanoidRootPart" },
						debug = false,
					})
					local wallCast = caster:cast({
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
					if not wallCast then
						print("there is no wall!")
						return nil
					end
					local attr = wallCast.instance:GetAttribute("reinforcable")
					if not (attr ~= 0 and (attr == attr and (attr ~= "" and attr))) then
						return nil
					end
					system.remote.client.fireServer("startReinforcement", getCamera().CFrame)
					local _idlePrompts = self.idlePrompts
					table.insert(_idlePrompts, 0)
					local hold = TS.await(key:waitForKeyUp({
						key = self:getKey("reinforce"),
						maxLength = 2.5,
						onUpdate = function(elapsedTime) end,
					}))
					local _exp = self.idlePrompts
					_exp[#_exp] = nil
					if hold < 2.3 then
						system.remote.client.fireServer("cancelReinforcement")
					end
				end
			end),
			throwDrone = function(state)
				if not self:starting(state) then
					return nil
				end
				system.remote.client.fireServer("throwDrone")
			end,
			toggleCameras = function(state)
				self.onCameras = not self.onCameras
				if self.onCameras then
					local cameraIndex = self.cameras[self.cameraIndex + 1]
				end
			end,
			primary = function(state)
				local gun = self.guns[1]
				if not self:equippedIsAGun(gun) then
					return nil
				end
				if self:starting(state) then
					gun:equip()
				end
			end,
			secondary = function(state)
				local gun = self.guns[2]
				if not self:equippedIsAGun(gun) then
					return nil
				end
				if self:starting(state) then
					gun:equip()
				end
			end,
		}
		self.onCameras = false
		self.cameraIndex = 0
		self.guns = {}
		self.character = Players.LocalPlayer.Character or (Players.LocalPlayer.CharacterAdded:Wait())
		if not self.character.PrimaryPart then
			self.character:GetPropertyChangedSignal("PrimaryPart"):Wait()
		end
		local clientSettings = clientConfig.new({})
		clientExposed.setActionController(self)
		clientExposed.setCamera(Workspace.CurrentCamera)
		clientExposed.setBaseWalkSpeed(12)
		clientExposed.setClientConfig(clientSettings)
		local item = m870_definition("Gun1")
		local item2 = hk416_definition("Gun2")
		local _guns = self.guns
		local _item = item
		table.insert(_guns, _item)
		local _guns_1 = self.guns
		local _item2 = item2
		table.insert(_guns_1, _item2)
		self.equippedItem = item
		RunService:BindToRenderStep("main_render", Enum.RenderPriority.Last.Value, function(dt)
			local equipped = self.equippedItem
			local humanoid = self.character:FindFirstChild("Humanoid")
			local camera = getCamera()
			if self.character.PrimaryPart then
				if self.vaulting or self.rappelling then
					self.character.PrimaryPart.Anchored = true
				else
					self.character.PrimaryPart.Anchored = false
				end
			end
			-- UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
			-- client.CameraMode = Enum.CameraMode.LockFirstPerson
			if self.onCameras then
				local index = self.cameraIndex
				local cameraChoice = if index < #self.cameras then self.cameras[self.cameraIndex + 1] else self.cameras[1]
				humanoid.WalkSpeed = 0
				camera.CFrame = cameraChoice.model.focus.CFrame
			elseif self:equippedIsAGun(equipped) then
				equipped:update(dt)
				local cx, cy, cz = camera.CFrame:ToOrientation()
				local recoilUpdated = equipped.springs.recoil:update(dt)
				local _cFrame = CFrame.new(camera.CFrame.Position)
				local _value = equipped.values.stanceOffset.Value
				local _arg0 = CFrame.fromOrientation(cx, cy, cz)
				local _value_1 = equipped.values.leanOffsetCamera.Value
				local _arg0_1 = CFrame.Angles(math.rad(recoilUpdated.Y), math.rad(recoilUpdated.X), 0)
				camera.CFrame = _cFrame * _value * _arg0 * _value_1 * _arg0_1
			end
			local _cameras = self.cameras
			local _arg0 = function(v)
				v:update()
			end
			for _k, _v in ipairs(_cameras) do
				_arg0(_v, _k - 1, _cameras)
			end
		end)
		UserInputService.MouseIconEnabled = false
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		local mainInputStart = UserInputService.InputBegan:Connect(function(input, gp)
			if gp then
				return nil
			end
			local keys = self:getKeybinds(input)
			if #keys > 0 then
				local _keys = keys
				local _arg0 = function(key)
					newThread(function()
						self.actionMap[key](input.UserInputState)
					end)
				end
				for _k, _v in ipairs(_keys) do
					_arg0(_v, _k - 1, _keys)
				end
			end
		end)
		local mainInputEnd = UserInputService.InputEnded:Connect(function(input)
			local keys = self:getKeybinds(input)
			if #keys > 0 then
				local _keys = keys
				local _arg0 = function(key)
					newThread(function()
						self.actionMap[key](input.UserInputState)
					end)
				end
				for _k, _v in ipairs(_keys) do
					_arg0(_v, _k - 1, _keys)
				end
			end
		end)
		system.remote.client.on("clientFlingBasepart", function(inst, pos, dir)
			inst:ApplyImpulseAtPosition(dir, pos)
		end)
		system.remote.client.on("throwDrone", function(id, owner, model)
			local d = drone.new(id, owner, model)
			print(id)
			print("drone created!")
			local _cameras = self.cameras
			local _d = d
			table.insert(_cameras, _d)
		end)
	end
	function actionController:starting(state)
		if state == Enum.UserInputState.Begin then
			return true
		end
		return false
	end
	function actionController:ending(state)
		if state == Enum.UserInputState.End then
			return true
		end
		return false
	end
	function actionController:getKeybinds(input)
		local g = {}
		for alias, key in pairs(self.keybinds) do
			if key.Name == input.KeyCode.Name or key.Name == input.UserInputType.Name then
				table.insert(g, alias)
			end
		end
		return g
	end
	function actionController:inputIs(input, check)
		local t = self.keybinds[check].Name
		if input.UserInputType.Name == t or input.KeyCode.Name == t then
			return true
		end
		return false
	end
	function actionController:getKey(keybind)
		return self.keybinds[keybind]
	end
	function actionController:equippedIsAGun(equipped)
		if equipped then
			if equipped.typeIdentifier == gunwork.itemTypeIdentifier.gun then
				return true
			end
		end
		return false
	end
	function actionController:getTransferCFrameValues()
		local g = self.equippedItem
		if not self:equippedIsAGun(g) then
			return nil
		end
		return g.values
	end
end
return {
	default = actionController,
}
