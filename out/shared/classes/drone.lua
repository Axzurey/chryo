-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local getCamera = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed").getCamera
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
local observable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "observable").default
local userContext = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "userContext")
local velocityGraph = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "velocitygraph").default
local drone
do
	local super = observable
	drone = setmetatable({}, {
		__tostring = function()
			return "drone"
		end,
		__index = super,
	})
	drone.__index = drone
	function drone.new(...)
		local self = setmetatable({}, drone)
		return self:constructor(...) or self
	end
	function drone:constructor(id, owner, model)
		super.constructor(self, id, owner, model)
		self.observationConnection = nil
		self.currentController = nil
		self.localVelocity = Vector3.new()
		self.graph = velocityGraph.new(3)
		self.model = model
		self.jumpConnection = UserInputService.InputBegan:Connect(function(key, gp)
			if gp then
				return nil
			end
			if key.KeyCode == Enum.KeyCode.Space then
				system.remote.client.fireServer("jumpDrone", self.id)
			end
		end)
	end
	function drone:update()
		local camera = getCamera()
		if self.owner == Players.LocalPlayer then
			system.remote.client.fireServer("updateDroneRotation", self.id, camera.CFrame)
		end
		local v = userContext.moveDirectionFromKeys()
		if v.Magnitude == 0 then
			self.graph:reset()
		end
		local _v = v
		local _arg0 = self.graph:getVelocityNow()
		self.localVelocity = _v * _arg0
		system.remote.client.fireServer("moveDrone", self.id, self.localVelocity)
	end
	function drone:observe(start)
		system.remote.client.fireServer("observeCamera", self.id, start)
		if self.observationConnection then
			self.observationConnection:Disconnect()
		end
		if start then
			local camera = getCamera()
			self.observationConnection = RunService.RenderStepped:Connect(function(dt)
				camera.CFrame = self.model.focus.CFrame
			end)
		end
	end
end
return {
	default = drone,
}
