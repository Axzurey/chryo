-- Compiled with roblox-ts v1.3.3
local zeroDefinitions = {}
do
	local _container = zeroDefinitions
	local entityType
	do
		local _inverse = {}
		entityType = setmetatable({}, {
			__index = _inverse,
		})
		entityType.human = "human"
		_inverse.human = "human"
		entityType.unknown = "unknown"
		_inverse.unknown = "unknown"
	end
	_container.entityType = entityType
end
return zeroDefinitions
