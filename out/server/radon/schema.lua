-- Compiled with roblox-ts v1.3.3
local schema
do
	schema = setmetatable({}, {
		__tostring = function()
			return "schema"
		end,
	})
	schema.__index = schema
	function schema.new(...)
		local self = setmetatable({}, schema)
		return self:constructor(...) or self
	end
	function schema:constructor(databaseKey, params)
		self.databaseKey = databaseKey
		self.params = params
	end
end
return {
	schema = schema,
}
