-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local system = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "system")
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
			print(result)
			local r = castParams.canPierce(result)
			system.poly.drawLine(from, result.Position)
			if r then
				local _instance = result.Instance
				table.insert(ignore, _instance)
				return self:loopCast(result.Position, direction, distance + distancePassed, ignore, castParams)
			else
				return result
			end
		else
			local _fn_1 = system.poly
			local _arg0_1 = self.params.maxDistance - distancePassed
			_fn_1.drawLine(from, direction * _arg0_1)
		end
		return nil
	end
	function rocaster:cast(params)
		local result = self:loopCast(self.params.from, self.params.direction, 0, self.params.ignore, params)
		if result then
			return {
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
