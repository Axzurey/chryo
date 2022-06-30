-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local getCamera = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed").getCamera
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
local observable = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "observable").default
local userContext = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "userContext")
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
		self.model = model
	end
	function drone:update()
		local camera = getCamera()
		if self.owner == Players.LocalPlayer then
			system.remote.client.fireServer("updateDroneRotation", self.id, camera.CFrame)
		end
		local v = userContext.moveDirectionFromKeys()
		self:move(v)
	end
	function drone:move(direction)
		system.remote.client.fireServer("moveDrone", self.id, direction)
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
