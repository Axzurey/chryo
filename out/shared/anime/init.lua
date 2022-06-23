-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local anime = {}
do
	local _container = anime
	local function lerp(v0, v1, t)
		return v0 + (v1 - v0) * t
	end
	local INTERPOLATIONS = {
		Vector3 = function(v0, v1, t)
			return v0:Lerp(v1, t)
		end,
		Vector2 = function(v0, v1, t)
			return v0:Lerp(v1, t)
		end,
		number = function(v0, v1, t)
			return lerp(v0, v1, t)
		end,
		CFrame = function(v0, v1, t)
			return v0:Lerp(v1, t)
		end,
		Color3 = function(v0, v1, t)
			return v0:Lerp(v1, t)
		end,
		UDim2 = function(v0, v1, t)
			return v0:Lerp(v1, t)
		end,
		UDim = function(v0, v1, t)
			return UDim.new(lerp(v0.Scale, v1.Scale, t), lerp(v0.Offset, v1.Offset, t))
		end,
	}
	local loopType = if RunService:IsServer() then RunService.Stepped else RunService.RenderStepped
	local invocationList = {}
	local mainLoop = loopType:Connect(function(dt, _dt2)
		if _dt2 ~= 0 and (_dt2 == _dt2 and _dt2) then
			dt = _dt2
		end
		local _arg0 = function(invocation)
			task.spawn(function()
				local t = invocation.elapsedTime + 1 * dt
				local _exp = INTERPOLATIONS
				local _current = invocation.current
				local index = _exp[typeof(_current)]
				invocation.current = index(invocation.origin, invocation.target, t)
				invocation.elapsedTime = t
			end)
		end
		for _k, _v in ipairs(invocationList) do
			_arg0(_v, _k - 1, invocationList)
		end
	end)
	local animeInstanceClass
	do
		animeInstanceClass = setmetatable({}, {
			__tostring = function()
				return "animeInstanceClass"
			end,
		})
		animeInstanceClass.__index = animeInstanceClass
		function animeInstanceClass.new(...)
			local self = setmetatable({}, animeInstanceClass)
			return self:constructor(...) or self
		end
		function animeInstanceClass:constructor(instance, invocable)
			self.instance = instance
			self.invocable = invocable
			self.propertyConnections = {}
		end
		function animeInstanceClass:bindPropertyToValue(property)
			if self.propertyConnections[property] then
				error("property " .. (tostring(property) .. " is already bound."))
			end
			local connection = loopType:Connect(function(dt, _dt2)
				if _dt2 ~= 0 and (_dt2 == _dt2 and _dt2) then
					dt = _dt2
				end
				self.instance[property] = self:getCurrentValue()
			end)
		end
		function animeInstanceClass:getCurrentValue()
			return self.invocable.current
		end
	end
	local origin = Vector3.new()
	local l = animeInstanceClass.new(Instance.new("Part"), {
		target = origin,
		origin = origin,
		current = origin,
		time = 1,
		elapsedTime = 0,
	})
	local function animateModel(model, to, time)
		if not model.PrimaryPart then
			error("model can not be animated without a primarypart set")
		end
		local origin = model:GetPrimaryPartCFrame().Position
		local invoc = {
			target = to,
			origin = origin,
			current = origin,
			time = time,
			elapsedTime = 0,
		}
		local animationClass = animeInstanceClass.new(model, invoc)
		local _invoc = invoc
		table.insert(invocationList, _invoc)
		return animationClass
	end
	_container.animateModel = animateModel
end
return anime
