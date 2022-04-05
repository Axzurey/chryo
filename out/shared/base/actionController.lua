-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local ContextActionService = _services.ContextActionService
local RunService = _services.RunService
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
		}
		self.actionMap = {
			aim = function(state)
				if self:equippedIsAGun(self.equippedItem) then
					print("aim switch!")
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
		clientExposed:setCamera(Workspace.CurrentCamera)
		local _fn = ContextActionService
		local _exp = function(_action, state, input)
			local key = self:getKeybind(input)
			if key then
				self.actionMap[key](state)
			end
		end
		local _array = {}
		local _length = #_array
		local _array_1 = Enum.KeyCode:GetEnumItems()
		local _Length = #_array_1
		table.move(_array_1, 1, _Length, _length + 1, _array)
		_length += _Length
		local _array_2 = Enum.UserInputType:GetEnumItems()
		table.move(_array_2, 1, #_array_2, _length + 1, _array)
		_fn:BindAction("context:actionController", _exp, false, unpack(_array))
		local render = RunService.RenderStepped:Connect(function(dt)
			local equipped = self.equippedItem
			if self:equippedIsAGun(equipped) then
				equipped:update(dt)
			end
		end)
		local item = gun.new("$xoo", "ReplicatedStorage//guns//hk416")
		self.equippedItem = item
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
