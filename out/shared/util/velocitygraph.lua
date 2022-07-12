-- Compiled with roblox-ts v1.3.3
local velocityGraph
do
	velocityGraph = setmetatable({}, {
		__tostring = function()
			return "velocityGraph"
		end,
	})
	velocityGraph.__index = velocityGraph
	function velocityGraph.new(...)
		local self = setmetatable({}, velocityGraph)
		return self:constructor(...) or self
	end
	function velocityGraph:constructor(velocityClamp)
		if velocityClamp == nil then
			velocityClamp = math.huge
		end
		self.velocityClamp = velocityClamp
		self.initialTime = tick()
	end
	function velocityGraph:reset()
		self.initialTime = tick()
	end
	function velocityGraph:getVelocityNow()
		return math.clamp((tick() - self.initialTime) ^ 2, 0, self.velocityClamp)
	end
	function velocityGraph:getVelocityAtPoint(t, velocityClamp)
		if velocityClamp == nil then
			velocityClamp = math.huge
		end
		return math.clamp(t ^ 2, 0, velocityClamp)
	end
end
return {
	default = velocityGraph,
}
