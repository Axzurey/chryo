-- Compiled with roblox-ts v1.3.3
local mathf = {}
do
	local _container = mathf
	-- local
	local randomGenerator = Random.new()
	local sin = math.sin
	local tan = math.tan
	local abs = math.abs
	local cos = math.cos
	local atan2 = math.atan2
	local asin = math.asin
	local acos = math.acos
	local rad = math.rad
	local deg = math.deg
	local pi = math.pi
	-- types
	-- constants
	local inf = math.huge
	_container.inf = inf
	local e = 2.718281
	_container.e = e
	local tau = pi * 2
	_container.tau = tau
	local phi = 2.618033
	_container.phi = phi
	local earthGravity = 9.807
	_container.earthGravity = earthGravity
	local lightSpeed = 299792458
	_container.lightSpeed = lightSpeed
	-- functions
	local function angleBetween(v1, v2)
		return acos(math.clamp(v1:Dot(v2), -1, 1))
	end
	_container.angleBetween = angleBetween
	local function vectorIsClose(v1, v2, limit)
		return if (v1 - v2).Magnitude <= limit then true else false
	end
	_container.vectorIsClose = vectorIsClose
	local function vector2IsSimilar(v1, v2, limit)
		if math.abs(v1.X - v2.X) > limit then
			return false
		end
		if math.abs(v1.Y - v2.Y) > limit then
			return false
		end
		return true
	end
	_container.vector2IsSimilar = vector2IsSimilar
	local function random(min, max, count)
		if min == nil then
			min = 0
		end
		if max == nil then
			max = 1
		end
		if count == nil then
			count = 1
		end
		if count == 1 then
			return randomGenerator:NextNumber(min, max)
		else
			local numbers = {}
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < count) then
						break
					end
					local _numbers = numbers
					local _arg0 = randomGenerator:NextNumber(min, max)
					table.insert(_numbers, _arg0)
				end
			end
			return numbers
		end
	end
	_container.random = random
	local function pointsOnCircle(radius, points, center)
		local parray = {}
		local cpo = 360 / points
		do
			local i = 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i <= points) then
					break
				end
				local theta = math.rad(cpo * i)
				local x = cos(theta) * radius
				local y = sin(theta) * radius
				local _parray = parray
				local _arg0 = if center then Vector2.new(x, y) + center else Vector2.new(x, y)
				table.insert(_parray, _arg0)
			end
		end
		return parray
	end
	_container.pointsOnCircle = pointsOnCircle
	local function translationRequired(a, b)
		return a:Inverse() * b
	end
	_container.translationRequired = translationRequired
	local function vector2FromAngle(angle, radius)
		local _exp = rad(angle)
		local _condition = radius
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 1
		end
		local _exp_1 = cos(_exp * _condition)
		local _exp_2 = sin(rad(angle))
		local _condition_1 = radius
		if not (_condition_1 ~= 0 and (_condition_1 == _condition_1 and _condition_1)) then
			_condition_1 = 1
		end
		return Vector2.new(_exp_1, _exp_2 * _condition_1)
	end
	_container.vector2FromAngle = vector2FromAngle
	local function angleFromVector2(v)
		return atan2(v.Y, v.X)
	end
	_container.angleFromVector2 = angleFromVector2
	local function normalize(min, max, value)
		if value > max then
			return max
		end
		if value < min then
			return min
		end
		return (value - min) / (max - min)
	end
	_container.normalize = normalize
	local function denormalize(min, max, value)
		return value * (max - min) + min
	end
	_container.denormalize = denormalize
	local function uExtendingSpiral(t)
		return Vector2.new(t * cos(t), t * sin(t))
	end
	_container.uExtendingSpiral = uExtendingSpiral
	--[[
		*
		*
		* @param x1 line 1 x1
		* @param x2 line 1 x2
		* @param y1 line 1 y1
		* @param y2 line 1 y2
		* @param x3 line 2 x1
		* @param x4 line 2 x2
		* @param y3 line 2 y1
		* @param y4 line 2 y2
		* [x, y], [x, y] --line1
		* [x, y], [x, y] --line2
		* @returns the x and y co-ordinates that the lines intersect at. If they do not intersect, it returns undefined.
	]]
	local function getConvergence(x1, x2, y1, y2, x3, x4, y3, y4)
		local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
		if den == 0 then
			return nil
		end
		local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
		local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den
		return { u, t }
	end
	_container.getConvergence = getConvergence
	local function uSquare(rotation, radius)
		if rotation == nil then
			rotation = 0
		end
		local cx = 0
		local cy = 0
		local function rotate(v1)
			local tx = v1.X - cx
			local ty = v1.Y - cy
			local rotatedX = tx * cos(rotation) - ty * sin(rotation)
			local rotatedY = tx * sin(rotation) - ty * cos(rotation)
			return Vector2.new(rotatedX + cx, rotatedY + cy)
		end
		local x1 = Vector2.new(1, 1) * radius
		local x2 = Vector2.new(1, -1) * radius
		local x3 = Vector2.new(-1, -1) * radius
		local x4 = Vector2.new(-1, 1) * radius
		return { rotate(x1), rotate(x2), rotate(x3), rotate(x4) }
	end
	_container.uSquare = uSquare
	local function slope(v1, v2)
		return (v2.Y - v1.Y) / (v2.X - v1.X)
	end
	_container.slope = slope
	local function lerp(v0, v1, t)
		return v0 + (v1 - v0) * t
	end
	_container.lerp = lerp
	local function lerpV3(v0, v1, t)
		local _arg0 = (v1 - v0) * t
		return v0 + _arg0
	end
	_container.lerpV3 = lerpV3
	local function degToRad(args)
		local newargs = { -1, -1, -1 }
		local _arg0 = function(v, i)
			newargs[i + 1] = math.rad(v)
		end
		for _k, _v in ipairs(args) do
			_arg0(_v, _k - 1, args)
		end
		return newargs
	end
	_container.degToRad = degToRad
	local function computeDistanceFromLineSegment(a, b, c)
		local px = (a - b):Cross(c - b).Magnitude
		local py = (c - b).Magnitude
		return px / py
	end
	_container.computeDistanceFromLineSegment = computeDistanceFromLineSegment
	local function percentToDegrees(percent)
		return percent * 360 / 100
	end
	_container.percentToDegrees = percentToDegrees
	local function xToDegrees(x, clamp)
		return x * 360 / clamp
	end
	_container.xToDegrees = xToDegrees
	local function degreesToPercent(degrees)
		return degrees / 360 * 100
	end
	_container.degreesToPercent = degreesToPercent
	local function bezierQuadratic(t, p0, p1, p2)
		return bit32.bxor(bit32.bxor((1 - t), 2 * p0 + 2 * (1 - t) * t * p1 + t), 2 * p2)
	end
	_container.bezierQuadratic = bezierQuadratic
	local function bezierQuadraticV3(t, p0, p1, p2)
		local l1 = lerpV3(p0, p1, t)
		local l2 = lerpV3(p1, p2, t)
		local q = lerpV3(l1, l2, t)
		return q
	end
	_container.bezierQuadraticV3 = bezierQuadraticV3
	--[[
		*
		*
		* @param part the part to check for the point on
		* @param point the point to get the closest vector on the part to
		* @returns
	]]
	local function closestPointOnPart(part, point)
		local t = part.CFrame:PointToObjectSpace(point)
		local hs = part.Size / 2
		local _cFrame = part.CFrame
		local _vector3 = Vector3.new(math.clamp(t.X, -hs.X, hs.X), math.clamp(t.Y, -hs.Y, hs.Y), math.clamp(t.Z, -hs.Z, hs.Z))
		return _cFrame * _vector3
	end
	_container.closestPointOnPart = closestPointOnPart
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
end
return mathf
