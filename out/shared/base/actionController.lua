-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local crosshairController = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "crosshairController").default
local hk416_definition = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunDefinitions", "hk416").default
local clientConfig = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "local", "clientConfig").default
local rappel = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "rappel")
local vault = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "mechanics", "vault")
local clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed")
local gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork")
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
			rappel = Enum.KeyCode.N,
		}
		self.vaulting = false
		self.rappelling = false
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
					gun:cancelReload()
					gun.fireButtonDown = true
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
			rappel = function(state)
				if self:starting(state) then
					local ignore = RaycastParams.new()
					ignore.FilterDescendantsInstances = { clientExposed.getCamera(), Players.LocalPlayer.Character }
					rappel.Rappel(ignore)
				end
			end,
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
		local item = hk416_definition("Gun1")
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
			local key = self:getKeybind(input)
			if key then
				self.actionMap[key](input.UserInputState)
			end
		end)
		local mainInputEnd = UserInputService.InputEnded:Connect(function(input)
			local key = self:getKeybind(input)
			if key then
				self.actionMap[key](input.UserInputState)
			end
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
	function actionController:getKeybind(input)
		for alias, key in pairs(self.keybinds) do
			if key.Name == input.KeyCode.Name or key.Name == input.UserInputType.Name then
				return alias
			end
		end
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
