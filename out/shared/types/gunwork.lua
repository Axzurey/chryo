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
		fireMode.auto = 0
		_inverse[0] = "auto"
		fireMode.semi = 1
		_inverse[1] = "semi"
		fireMode.burst2 = 2
		_inverse[2] = "burst2"
		fireMode.burst3 = 3
		_inverse[3] = "burst3"
		fireMode.burst4 = 4
		_inverse[4] = "burst4"
		fireMode.shotgun = 5
		_inverse[5] = "shotgun"
	end
	_container.fireMode = fireMode
end
return gunwork
