-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "path").default
local serverDrone
do
	serverDrone = setmetatable({}, {
		__tostring = function()
			return "serverDrone"
		end,
	})
	serverDrone.__index = serverDrone
	function serverDrone.new(...)
		local self = setmetatable({}, serverDrone)
		return self:constructor(...) or self
	end
	function serverDrone:constructor(id, owner, serverDataPointer, position)
		self.id = id
		self.owner = owner
		self.serverDataPointer = serverDataPointer
		self.cameraQueue = {}
		self.internalAngle = CFrame.new()
		local model = path:getInstance("ReplicatedStorage//assets//drone&Model")
		model = model:Clone()
		self.model = model
		self.model:SetPrimaryPartCFrame(CFrame.new(position))
		self.model.Parent = Workspace
	end
	function serverDrone:getFirstAliveMemberFromQueue()
		for _, v in pairs(self.cameraQueue) do
			if self.serverDataPointer.playerConfiguration[v.UserId].characterClass:alive() then
				return v
			end
		end
	end
	function serverDrone:getController()
		local firstalivemember = self:getFirstAliveMemberFromQueue()
		local _cameraQueue = self.cameraQueue
		local _owner = self.owner
		local _condition = (table.find(_cameraQueue, _owner) or 0) - 1 ~= -1
		if _condition then
			_condition = self.serverDataPointer.playerConfiguration[self.owner.UserId].characterClass:alive()
		end
		return if _condition then self.owner else (if firstalivemember then firstalivemember else self.cameraQueue[1])
	end
	function serverDrone:update(dir)
		self.model.PrimaryPart:ApplyImpulse(dir)
	end
	function serverDrone:addToQueue(player)
		if (table.find(self.cameraQueue, player) or 0) - 1 == -1 then
			local _cameraQueue = self.cameraQueue
			table.insert(_cameraQueue, player)
		end
	end
	function serverDrone:removeFromQueue(player)
		local index = (table.find(self.cameraQueue, player) or 0) - 1
		if index ~= -1 then
			local _cameraQueue = self.cameraQueue
			local _index = index
			table.remove(_cameraQueue, _index + 1)
		end
	end
end
return {
	default = serverDrone,
}
