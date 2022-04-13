-- Compiled with roblox-ts v1.3.3
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
