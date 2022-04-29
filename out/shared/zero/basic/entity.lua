-- Compiled with roblox-ts v1.3.3
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
	end
end
return {
	default = entity,
}
