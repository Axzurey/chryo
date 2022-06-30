-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "system")
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
	function rocaster:loopCast(from, direction, distancePassed, ignore, castParams, subHits)
		local i = RaycastParams.new()
		i.FilterDescendantsInstances = ignore
		local _fn = Workspace
		local _arg0 = self.params.maxDistance - distancePassed
		local result = _fn:Raycast(from, direction * _arg0, i)
		if result then
			local distance = (result.Position - from).Magnitude
			local _ignoreNames = self.params.ignoreNames
			local _name = result.Instance.Name
			if (table.find(_ignoreNames, _name) or 0) - 1 ~= -1 then
				local _instance = result.Instance
				table.insert(ignore, _instance)
				return self:loopCast(from, direction, distancePassed, ignore, castParams, subHits)
			end
			local r = castParams.canPierce(result)
			if self.params.debug then
				system.poly.drawLine(from, result.Position)
			end
			if r then
				local _instance = result.Instance
				table.insert(ignore, _instance)
				local _arg0_1 = {
					instance = result.Instance,
					normal = result.Normal,
					position = result.Position,
					material = result.Material,
				}
				table.insert(subHits, _arg0_1)
				return self:loopCast(result.Position, direction, distance + distancePassed, ignore, castParams, subHits)
			else
				return { result, subHits }
			end
		else
			if self.params.debug then
				local _fn_1 = system.poly
				local _arg0_1 = self.params.maxDistance - distancePassed
				_fn_1.drawLine(from, direction * _arg0_1)
			end
		end
		return nil
	end
	function rocaster:cast(params)
		local result = self:loopCast(self.params.from, self.params.direction, 0, self.params.ignore, params, {})
		if result then
			return {
				instance = result[1].Instance,
				normal = result[1].Normal,
				position = result[1].Position,
				material = result[1].Material,
				subHits = result[2],
			}
		end
	end
end
return {
	default = rocaster,
}
