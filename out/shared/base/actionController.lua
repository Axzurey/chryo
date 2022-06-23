-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").newThread
local crosshairController = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "crosshairController").default
local m870_definition = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunDefinitions", "m870").default
local clientConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "local", "clientConfig").default
local rappel = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "rappel")
local vault = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "vault")
local _clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed")
local clientExposed = _clientExposed
local getCamera = _clientExposed.getCamera
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork")
local gunwork = _gunwork
local fireMode = _gunwork.fireMode
local key = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "key").default
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "system")
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
		}
		self.vaulting = false
		self.rappelling = false
		self.idlePrompts = {}
		self.crosshairController = crosshairController.new()
		self.start = Enum.UserInputState.Begin
		self["end"] = Enum.UserInputState.End
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
					gun:startReload()
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
				if self:starting(state) then
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
		}
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
		self.equippedItem = item
		RunService:BindToRenderStep("main_render", Enum.RenderPriority.Last.Value, function(dt)
			local equipped = self.equippedItem
			if self.character.PrimaryPart then
				if self.vaulting or self.rappelling then
					self.character.PrimaryPart.Anchored = true
				else
					self.character.PrimaryPart.Anchored = false
				end
			end
			if self:equippedIsAGun(equipped) then
				equipped:update(dt)
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
end
return {
	default = actionController,
}
