-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ContextActionService = TS.import(script, TS.getModule(script, "@rbxts", "services")).ContextActionService
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
		}
		self.actionMap = {
			aim = function(state)
				if self:equippedIsAGun(self.equippedItem) then
					local gun = self.equippedItem
					gun:aim(if state == Enum.UserInputState.Begin then true else false)
				end
			end,
			fire = function()
				return "TODO"
			end,
			reload = function()
				return "TODO"
			end,
		}
		ContextActionService:BindAction("context:actionController", function(_action, state, input)
			local key = self:getKeybind(input)
			if key then
				self.actionMap[key](state)
			end
		end, false)
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
