-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local utils = {}
do
	local _container = utils
	local function propertyExistsInObject(classlike, property)
		local _value = classlike[property]
		if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
			return true
		end
		return false
	end
	_container.propertyExistsInObject = propertyExistsInObject
	local function newThread(callback)
		task.spawn(callback)
	end
	_container.newThread = newThread
	local function later(when, callback)
		task.spawn(function()
			task.wait(when)
			callback()
		end)
	end
	_container.later = later
	local random = Random.new()
	_container.random = random
	local ease = {}
	do
		local _container_1 = ease
		local function repeatThis(callback, times)
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < times) then
						break
					end
					callback(times)
				end
			end
		end
		_container_1.repeatThis = repeatThis
		local function repeatThisThreadEach(callback, times)
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < times) then
						break
					end
					task.spawn(callback, i)
				end
			end
		end
		_container_1.repeatThisThreadEach = repeatThisThreadEach
	end
	_container.ease = ease
	local peripherals = {}
	do
		local _container_1 = peripherals
		local function isButtonDown(button)
			if button.EnumType == Enum.KeyCode then
				return UserInputService:IsKeyDown(button)
			else
				return UserInputService:IsMouseButtonPressed(button)
			end
		end
		_container_1.isButtonDown = isButtonDown
	end
	_container.peripherals = peripherals
	local dataTypeUtils = {}
	do
		local _container_1 = dataTypeUtils
		--[[
			*
			* returns a cframe position and orientation
		]]
		local function cframeToCFrames(cframe)
			local o = { cframe:ToOrientation() }
			return { CFrame.new(cframe.Position), CFrame.fromOrientation(o[1], o[2], o[3]) }
		end
		_container_1.cframeToCFrames = cframeToCFrames
	end
	_container.dataTypeUtils = dataTypeUtils
	local instanceUtils = {}
	do
		local _container_1 = instanceUtils
		--[[
			*
			* makes all children as if they aren't there(uninteractable)
		]]
		local function nominalizeAllChildren(parent)
			local _exp = parent:GetChildren()
			local _arg0 = function(v)
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.CanTouch = false
					v.CanQuery = false
				end
			end
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end
		_container_1.nominalizeAllChildren = nominalizeAllChildren
		local function nominalizeAllDescendants(parent)
			local _exp = parent:GetDescendants()
			local _arg0 = function(v)
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.CanTouch = false
					v.CanQuery = false
				end
			end
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end
		_container_1.nominalizeAllDescendants = nominalizeAllDescendants
		local function unanchorAllChildren(parent)
			local _exp = parent:GetChildren()
			local _arg0 = function(v)
				if v:IsA("BasePart") then
					v.Anchored = false
				end
			end
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end
		_container_1.unanchorAllChildren = unanchorAllChildren
		local function unanchorAllDescendants(parent)
			local _exp = parent:GetDescendants()
			local _arg0 = function(v)
				if v:IsA("BasePart") then
					v.Anchored = false
				end
			end
			for _k, _v in ipairs(_exp) do
				_arg0(_v, _k - 1, _exp)
			end
		end
		_container_1.unanchorAllDescendants = unanchorAllDescendants
	end
	_container.instanceUtils = instanceUtils
	local tableUtils = {}
	do
		local _container_1 = tableUtils
		local function firstNumberRangeContainingNumber(ranges, numberValue)
			for i, v in pairs(ranges) do
				if numberValue >= i.Min and numberValue <= i.Max then
					return v
				end
			end
			return nil
		end
		_container_1.firstNumberRangeContainingNumber = firstNumberRangeContainingNumber
		local function rangeUpperClamp(ranges)
			local max = nil
			for i, v in pairs(ranges) do
				if not (max ~= 0 and (max == max and max)) or i.Max >= max then
					max = i.Max
				end
			end
			return max
		end
		_container_1.rangeUpperClamp = rangeUpperClamp
		local function toMap(keys, values)
			local map = {}
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #keys) then
						break
					end
					local _map = map
					local _arg0 = keys[i + 1]
					local _arg1 = values[i + 1]
					_map[_arg0] = _arg1
				end
			end
			return map
		end
		_container_1.toMap = toMap
		local function fillDefaults(passed, fill)
			for i, v in pairs(fill) do
				local _value = passed[i]
				if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
					continue
				else
					passed[i] = v
				end
			end
			return passed
		end
		_container_1.fillDefaults = fillDefaults
		local function toArray(dictionary)
			local a = {}
			for _, v in pairs(dictionary) do
				table.insert(a, v)
			end
			return a
		end
		_container_1.toArray = toArray
		local function toKeysArray(dictionary)
			local a = {}
			for v, _ in pairs(dictionary) do
				table.insert(a, v)
			end
			return a
		end
		_container_1.toKeysArray = toKeysArray
		local function partToPosition(parts)
			local _arg0 = function(part)
				return part.Position
			end
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#parts)
			for _k, _v in ipairs(parts) do
				_newValue[_k] = _arg0(_v, _k - 1, parts)
			end
			-- ▲ ReadonlyArray.map ▲
			return _newValue
		end
		_container_1.partToPosition = partToPosition
		local function firstKeyOfValue(dictionary, value)
			for i, v in pairs(dictionary) do
				if value == v then
					return i
				end
			end
			return nil
		end
		_container_1.firstKeyOfValue = firstKeyOfValue
	end
	_container.tableUtils = tableUtils
end
return utils
