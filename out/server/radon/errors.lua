-- Compiled with roblox-ts v1.3.3
local radonCode
do
	local _inverse = {}
	radonCode = setmetatable({}, {
		__index = _inverse,
	})
	radonCode.success = "task completed successfully"
	_inverse["task completed successfully"] = "success"
	radonCode.noApiAccess = "unable to connect to datastore api. Is it enabled in game settings?"
	_inverse["unable to connect to datastore api. Is it enabled in game settings?"] = "noApiAccess"
	radonCode.unexpected = "An unexpected error occured"
	_inverse["An unexpected error occured"] = "unexpected"
	radonCode.objectCanNotBeSerialized = "Objects of type [x] can not be serialized"
	_inverse["Objects of type [x] can not be serialized"] = "objectCanNotBeSerialized"
	radonCode.noData = "No data has been saved to this key"
	_inverse["No data has been saved to this key"] = "noData"
end
return radonCode
