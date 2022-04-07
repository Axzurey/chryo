-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local Workspace = _services.Workspace
local gun = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "extended", "gun").default
local clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed").default
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
				return "TODO"
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
		}
		local item = gun.new("$xoo", "ReplicatedStorage//guns//hk416&class=Model")
		self.equippedItem = item
		clientExposed:setCamera(Workspace.CurrentCamera)
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
		local mainRender = RunService.RenderStepped:Connect(function(dt)
			local equipped = self.equippedItem
			if self:equippedIsAGun(equipped) then
				equipped:update(dt)
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
