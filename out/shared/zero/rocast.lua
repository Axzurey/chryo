-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local fastcast = TS.import(script, TS.getModule(script, "@rbxts", "fastcast").src).default
local space = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space")
-- https://etithespir.it/FastCastAPIDocs/fastcast-objects/caster/
local castType
do
	local _inverse = {}
	castType = setmetatable({}, {
		__index = _inverse,
	})
	castType.hitscan = 0
	_inverse[0] = "hitscan"
	castType.projectile = 1
	_inverse[1] = "projectile"
end
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
		self.caster = fastcast.new()
		self.behavior = fastcast:newBehavior()
		fastcast.VisualizeCasts = params.debug
		local behavior = self.behavior
		behavior.MaxDistance = params.maxDistance
		behavior.CanPierceFunction = function(_, result)
			return if self.params.canPierce(result) then true else false
		end
		if params.castType == castType.projectile then
			self.caster.RayHit:Connect(function(caster, result, velocity, cosmetic)
				params.onHit(result)
			end)
			self.caster.RayPierced:Connect(function(caster, result, velocity, cosmetic) end)
			self.caster.CastTerminating:Connect(function(caster) end)
		elseif params.castType == castType.hitscan then
		end
	end
	function rocaster:recastHitscan(from, direction, pierces, distanceTraveled)
		local distanceLeft = self.params.maxDistance - distanceTraveled
		local ignore = RaycastParams.new()
		ignore.FilterDescendantsInstances = space.ignoreInstances
		local _fn = Workspace
		local _distanceLeft = distanceLeft
		local result = _fn:Raycast(from, direction * _distanceLeft, ignore)
		if result then
			local out = self.params.canPierce(result)
			-- check if can reflect
			if out then
				local _position = result.Position
				local distance = (from - _position).Magnitude
				if distance > 0 then
					result = self:recastHitscan(result.Position, direction, 0, distance)
				end
			end
		end
		return result
	end
	function rocaster:rayCast()
		local cast = self:recastHitscan(self.params.origin, self.params.direction, 0, 0)
		if cast then
		end
	end
	function rocaster:cast()
		local cast = self.caster:Fire(self.params.origin, self.params.direction, self.params.velocity, self.behavior)
	end
end
local softAliases = {
	wood_wall = {
		pierce = 1,
		damagePercentage = .85,
	},
	wood_floor = {
		pierce = 1,
		damagePercentage = .85,
	},
	crate = {
		pierce = 1,
		damagePercentage = .85,
	},
}
local function canPierce(result)
	local alias = softAliases[result.Instance.Name]
	if alias then
		-- keep track of the alias internally
		return alias
	else
		return nil
	end
end
return {
	default = rocaster,
}
