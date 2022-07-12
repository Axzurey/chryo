-- Compiled with roblox-ts v1.3.3
local observableType
do
	local _inverse = {}
	observableType = setmetatable({}, {
		__index = _inverse,
	})
	observableType.drone = 0
	_inverse[0] = "drone"
	observableType.camera = 1
	_inverse[1] = "camera"
end
local observable
do
	observable = setmetatable({}, {
		__tostring = function()
			return "observable"
		end,
	})
	observable.__index = observable
	function observable.new(...)
		local self = setmetatable({}, observable)
		return self:constructor(...) or self
	end
	function observable:constructor(id, owner, model)
		self.id = id
		self.owner = owner
		self.model = model
		self.observableType = observableType.camera
	end
	function observable:observe(start)
	end
	function observable:update()
	end
	function observable:isADrone()
		return self.observableType == observableType.drone
	end
	function observable:isACamera()
		return self.observableType == observableType.camera
	end
end
return {
	default = observable,
}
