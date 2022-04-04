-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local propertyExistsInObject = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").propertyExistsInObject
local space = {}
do
	local _container = space
	local entityMaps = {}
	local ignoreInstances = {}
	_container.ignoreInstances = ignoreInstances
	local query = {}
	do
		local _container_1 = query
		local function findAllWithComponents(components)
			local index = entityMaps[components]
			if index then
				return index
			end
			return {}
		end
		_container_1.findAllWithComponents = findAllWithComponents
		--[[
			*
			*
			* @param property
			* @param value
			* @param useComponents if this is not provided, it searches through every entity in the game
			* @returns
		]]
		local function filterAllWithPropertyAs(property, value, useComponents)
			local selected = {}
			if useComponents then
				local _arg0 = function(v)
					if propertyExistsInObject(v, property) and v[property] == value then
						table.insert(selected, v)
					end
				end
				for _k, _v in ipairs(useComponents) do
					_arg0(_v, _k - 1, useComponents)
				end
			else
				local _arg0 = function(comparr)
					local _arg0_1 = function(v)
						if propertyExistsInObject(v, property) and v[property] == value then
							table.insert(selected, v)
						end
					end
					for _k, _v in ipairs(comparr) do
						_arg0_1(_v, _k - 1, comparr)
					end
				end
				for _k, _v in pairs(entityMaps) do
					_arg0(_v, _k, entityMaps)
				end
			end
			return selected
		end
		_container_1.filterAllWithPropertyAs = filterAllWithPropertyAs
	end
	_container.query = query
end
return space
