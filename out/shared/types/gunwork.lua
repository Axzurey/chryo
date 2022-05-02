-- Compiled with roblox-ts v1.3.3
local gunwork = {}
do
	local _container = gunwork
	local itemTypeIdentifier
	do
		local _inverse = {}
		itemTypeIdentifier = setmetatable({}, {
			__index = _inverse,
		})
		itemTypeIdentifier.none = 0
		_inverse[0] = "none"
		itemTypeIdentifier.gun = 1
		_inverse[1] = "gun"
	end
	_container.itemTypeIdentifier = itemTypeIdentifier
	local fireMode
	do
		local _inverse = {}
		fireMode = setmetatable({}, {
			__index = _inverse,
		})
		fireMode.auto = "auto"
		_inverse.auto = "auto"
		fireMode.semi = "semi"
		_inverse.semi = "semi"
		fireMode.burst2 = "burst2"
		_inverse.burst2 = "burst2"
		fireMode.burst3 = "burst3"
		_inverse.burst3 = "burst3"
		fireMode.burst4 = "burst4"
		_inverse.burst4 = "burst4"
		fireMode.shotgun = "shotgun"
		_inverse.shotgun = "shotgun"
	end
	_container.fireMode = fireMode
end
return gunwork
