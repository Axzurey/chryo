-- Compiled with roblox-ts v1.3.3
local mathf = {}
do
	local _container = mathf
	local function pointsOnSphere(fidelity)
		local points = {}
		local goldenRatio = 1 + math.sqrt(5) / 4
		local angleIncrement = math.pi * 2 * goldenRatio
		local multiplier = 10
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < fidelity) then
					break
				end
				local distance = i / fidelity
				local incline = math.acos(1 - 2 * distance)
				local azimuth = angleIncrement * i
				local x = math.sin(incline) * math.cos(azimuth) * multiplier
				local y = math.sin(incline) * math.sin(azimuth) * multiplier
				local z = math.cos(incline) * multiplier
				local _points = points
				local _vector3 = Vector3.new(x, y, z)
				table.insert(_points, _vector3)
			end
		end
		return points
	end
	_container.pointsOnSphere = pointsOnSphere
	local function lerp(v0, v1, t)
		return (1 - t) * v0 + t * v1
	end
	_container.lerp = lerp
end
return mathf
