-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local plotInWorld = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "phantom", "graphRBX").plotInWorld
local SOFT_PADDING = .1
local GRAVITY_CONSTANT = -196.2
local TERMINAL_VELOCITY = 50
local function isHitboxType(form)
	if form:IsA("Model") then
		return true
	end
	return false
end
local function lerpV3(v0, v1, t)
	local _arg0 = (v1 - v0) * t
	return v0 + _arg0
end
local v3 = Vector3
local function getCorners(position, size)
	local _v3 = v3.new(-size.X / 2, size.Y / 2, size.Z / 2)
	local _exp = position + _v3
	local _v3_1 = v3.new(size.X / 2, size.Y / 2, -size.Z / 2)
	local _exp_1 = position + _v3_1
	local _v3_2 = v3.new(-size.X / 2, size.Y / 2, -size.Z / 2)
	local _exp_2 = position + _v3_2
	local _v3_3 = v3.new(size.X / 2, size.Y / 2, size.Z / 2)
	local _exp_3 = position + _v3_3
	local _v3_4 = v3.new(-size.X / 2, -size.Y / 2, size.Z / 2)
	local _exp_4 = position + _v3_4
	local _v3_5 = v3.new(size.X / 2, -size.Y / 2, -size.Z / 2)
	local _exp_5 = position + _v3_5
	local _v3_6 = v3.new(-size.X / 2, -size.Y / 2, -size.Z / 2)
	local _exp_6 = position + _v3_6
	local _v3_7 = v3.new(size.X / 2, -size.Y / 2, size.Z / 2)
	local p = { _exp, _exp_1, _exp_2, _exp_3, _exp_4, _exp_5, _exp_6, position + _v3_7 }
	return p
end
local function reflect(vector, normal)
	local _exp = normal * 2
	local _arg0 = vector:Dot(normal)
	return vector - (_exp * _arg0)
end
local physicsObject
do
	physicsObject = setmetatable({}, {
		__tostring = function()
			return "physicsObject"
		end,
	})
	physicsObject.__index = physicsObject
	function physicsObject.new(...)
		local self = setmetatable({}, physicsObject)
		return self:constructor(...) or self
	end
	function physicsObject:constructor(form, position)
		self.form = form
		self.position = position
		self.size = Vector3.new()
		self.velocity = Vector3.new()
		self.acceleration = Vector3.new()
		self.mass = 1
		self.restitution = 15
		if isHitboxType(self.form) then
			self.form:SetPrimaryPartCFrame(CFrame.new(position))
		else
			self.form.Position = position
		end
		self.size = if isHitboxType(form) then form.hitbox.Size else form.Size
	end
	function physicsObject:applyImpulse(v3)
		local _velocity = self.velocity
		local _mass = self.mass
		local _arg0 = v3 / _mass
		self.velocity = _velocity + _arg0
	end
	function physicsObject:update(dt)
		self.velocity = Vector3.new(math.clamp(self.velocity.X, -TERMINAL_VELOCITY, TERMINAL_VELOCITY), math.clamp(self.velocity.Y + GRAVITY_CONSTANT * dt, -TERMINAL_VELOCITY, TERMINAL_VELOCITY), math.clamp(self.velocity.Z, -TERMINAL_VELOCITY, TERMINAL_VELOCITY))
		local _exp = self.velocity * dt
		local _arg0 = self.acceleration * dt
		local targetAddition = _exp + _arg0
		self.acceleration = Vector3.new()
		local _position = self.position
		local _targetAddition = targetAddition
		local targetPosition = _position + _targetAddition
		local corners = getCorners(targetPosition, self.size)
		local originCorners = getCorners(self.position, self.size)
		local ignore = RaycastParams.new()
		ignore.FilterDescendantsInstances = { self.form }
		local cVector = targetPosition
		do
			local i = 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i <= #originCorners) then
					break
				end
				local v = originCorners[i - 1 + 1]
				local nextP = corners[i - 1 + 1]
				local _nextP = nextP
				local _v = v
				local direction = _nextP - _v
				local unitDir = direction.Unit
				local dirMag = direction.Magnitude
				local _fn = Workspace
				local _exp_1 = v
				local _unitDir = unitDir
				local _dirMag = dirMag
				local result = _fn:Raycast(_exp_1, _unitDir * _dirMag, ignore)
				if result then
					local _position_1 = self.position
					local _direction = direction
					local _position_2 = result.Position
					local _v_1 = v
					local _arg0_1 = (_position_2 - _v_1).Magnitude - SOFT_PADDING
					cVector = _position_1 + (_direction * _arg0_1)
					plotInWorld(cVector, Color3.fromRGB(255, 0, 255))
					local _velocity = self.velocity
					local _restitution = self.restitution
					self.velocity = reflect(_velocity * _restitution, result.Normal)
					self.position = cVector
					targetAddition = self.velocity * dt
					local _position_3 = self.position
					local _targetAddition_1 = targetAddition
					targetPosition = _position_3 + _targetAddition_1
					corners = getCorners(targetPosition, self.size)
					originCorners = getCorners(self.position, self.size)
				end
				plotInWorld(targetPosition, Color3.fromRGB(0, 255, 0), 3)
				print(targetPosition)
			end
		end
		self.position = cVector
		if isHitboxType(self.form) then
			self.form:SetPrimaryPartCFrame(CFrame.new(cVector))
		else
			self.form.Position = cVector
		end
	end
end
return {
	lerpV3 = lerpV3,
	default = physicsObject,
}
