-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space")
local rocaster
do
	rocaster = setmetatable({}, {
		__tostring = function()
			return "rocaster"
		end,
	})
	rocaster.__index = rocaster
	function rocaster.new(...)
		local self = setmetatable({}, rocaster)
		return self:constructor(...) or self
	end
	function rocaster:constructor(params)
		self.params = params
	end
	function rocaster:loopCast(from, direction, distancePassed, ignore, castParams)
		local i = RaycastParams.new()
		i.FilterDescendantsInstances = ignore
		local _fn = Workspace
		local _arg0 = self.params.maxDistance - distancePassed
		local result = _fn:Raycast(from, direction * _arg0, i)
		if result then
			local distance = (result.Position - from).Magnitude
			local r = castParams.canPierce(result)
			if r then
				return self:loopCast(result.Position, direction, distance + distancePassed, ignore, castParams)
			else
				return result
			end
		end
		return nil
	end
	function rocaster:cast(params)
		local result = self:loopCast(self.params.from, self.params.direction, 0, self.params.ignore, params)
		if result then
			local entity = space.query.findFirstEntityWithVesselThatContainsInstance(result.Instance)
			return {
				entity = entity,
				instance = result.Instance,
				normal = result.Normal,
				position = result.Position,
				material = result.Material,
			}
		end
	end
end
return {
	default = rocaster,
}
