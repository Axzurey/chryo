-- Compiled with roblox-ts v1.3.3
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
	end
	function observable:observe(start)
	end
	function observable:update()
	end
end
return {
	default = observable,
}
