-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local gun = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "extended", "gun").default
local clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed").default
local _gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork")
local gunwork = _gunwork
local fireMode = _gunwork.fireMode
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
			prone = Enum.KeyCode.Z,
			crouch = Enum.KeyCode.C,
		}
		self.actionMap = {
			aim = function(state)
				if self:equippedIsAGun(self.equippedItem) then
					print("aim switch!")
					local gun = self.equippedItem
					gun:aim(if state == Enum.UserInputState.Begin then true else false)
				end
			end,
			fire = function(state)
				if self:starting(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun.fireButtonDown = true
				elseif self:ending(state) and self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun.fireButtonDown = false
				end
			end,
			reload = function(state)
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
		}
		if not Players.LocalPlayer.Character then
			Players.LocalPlayer.CharacterAdded:Wait()
			while not Players.LocalPlayer.Character.PrimaryPart do
				task.wait()
			end
			print("done! starting...")
		end
		clientExposed:setActionController(self)
		clientExposed:setCamera(Workspace.CurrentCamera)
		clientExposed:setBaseWalkSpeed(12)
		local item = gun.new("Gun1", "ReplicatedStorage//guns//hk416&class=Model", {
			sight = {
				name = "holographic",
				path = "ReplicatedStorage//sights//holographic&class=Model",
				zOffset = .13,
			},
		}, {
			idle = "rbxassetid://9335189959",
		})
		item.firerate = {
			burst2 = 600,
			auto = 800,
			burst3 = 600,
			burst4 = 600,
			shotgun = 1000,
			semi = 800,
		}
		item.togglableFireModes = { fireMode.auto, fireMode.semi }
		item.reloadSpeed = 1.5
		self.equippedItem = item
		local mainRender = RunService.RenderStepped:Connect(function(dt)
			local equipped = self.equippedItem
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
