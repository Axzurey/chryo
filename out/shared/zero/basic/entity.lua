-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local entityType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "define", "zeroDefinitions").entityType
local entity
do
	entity = setmetatable({}, {
		__tostring = function()
			return "entity"
		end,
	})
	entity.__index = entity
	function entity.new(...)
		local self = setmetatable({}, entity)
		return self:constructor(...) or self
	end
	function entity:constructor(vessel)
		self.vessel = vessel
		self.entityType = entityType.unknown
	end
end
return {
	default = entity,
}
