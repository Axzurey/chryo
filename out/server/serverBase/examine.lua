-- Compiled with roblox-ts v1.3.3
local examine = {}
do
	local _container = examine
	local hitLocation
	do
		local _inverse = {}
		hitLocation = setmetatable({}, {
			__index = _inverse,
		})
		hitLocation.head = 0
		_inverse[0] = "head"
		hitLocation.body = 1
		_inverse[1] = "body"
		hitLocation.limb = 2
		_inverse[2] = "limb"
	end
	_container.hitLocation = hitLocation
	local headNames = { "head" }
	local bodyNames = { "UpperTorso", "LowerTorso", "Torso" }
	local limbNames = { "LeftLowerLeg", "LeftUpperLeg", "LeftFoot", "RightLowerLeg", "RightUpperLeg", "RightFoot", "LeftLowerArm", "LeftUpperArm", "LeftHand", "RightLowerArm", "RightUpperArm", "RightHand" }
	local function examineHitLocation(hit)
		local _name = hit.Name
		if (table.find(headNames, _name) or 0) - 1 ~= -1 then
			return hitLocation.head
		else
			local _name_1 = hit.Name
			if (table.find(bodyNames, _name_1) or 0) - 1 ~= -1 then
				return hitLocation.body
			else
				return hitLocation.limb
			end
		end
	end
	_container.examineHitLocation = examineHitLocation
end
return examine
