-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils")
local newThread = _utils.newThread
local propertyExistsInObject = _utils.propertyExistsInObject
local space = {}
do
	local _container = space
	local entities = {}
	local ignoreInstances = {}
	_container.ignoreInstances = ignoreInstances
	local function verifyRemoteArgs(args, verify)
		local i = 0
		for _, value in ipairs(verify) do
			local against = args[i + 1]
			if not value(against) then
				return false
			end
			i += 1
		end
		return true
	end
	_container.verifyRemoteArgs = verifyRemoteArgs
	local life = {}
	do
		local _container_1 = life
		local function create(entityType)
			local e = entityType.new()
			local _e = e
			table.insert(entities, _e)
			return e
		end
		_container_1.create = create
		local lifeCycle = RunService.Heartbeat:Connect(function(dt)
			local _arg0 = function(e)
				newThread(function(dt)
					e:tick(dt)
				end, dt)
			end
			for _k, _v in ipairs(entities) do
				_arg0(_v, _k - 1, entities)
			end
		end)
	end
	_container.life = life
	local query = {}
	do
		local _container_1 = query
		local function entityIsThatIfOfType(entity, entityType)
			if entityType == entity.entityType then
				return true
			end
			return false
		end
		_container_1.entityIsThatIfOfType = entityIsThatIfOfType
		local function getAllWithProperty(property)
			local selected = {}
			local _arg0 = function(v)
				if propertyExistsInObject(v, property) then
					table.insert(selected, v)
				end
			end
			for _k, _v in ipairs(entities) do
				_arg0(_v, _k - 1, entities)
			end
			return selected
		end
		_container_1.getAllWithProperty = getAllWithProperty
		--[[
			*
			* note: for value(parameter 2) remember to throw in 'as const' to the end or else it will end up as a broad type
		]]
		local function getAllWithPropertyAs(property, value)
			local selected = {}
			local _arg0 = function(v)
				if propertyExistsInObject(v, property) and v[property] == value then
					table.insert(selected, v)
				end
			end
			for _k, _v in ipairs(entities) do
				_arg0(_v, _k - 1, entities)
			end
			return selected
		end
		_container_1.getAllWithPropertyAs = getAllWithPropertyAs
		local function entityHasPropertyOfType(entity, property, propertyType)
			local _condition = propertyExistsInObject(entity, property)
			if _condition then
				local _arg0 = entity[property]
				_condition = typeof(_arg0) == propertyType
			end
			if _condition then
				return true
			end
			return false
		end
		_container_1.entityHasPropertyOfType = entityHasPropertyOfType
		local function findFirstEntityWithVessel(vessel)
			for _, v in pairs(entities) do
				if v.vessel and vessel == v.vessel then
					return v
				end
			end
		end
		_container_1.findFirstEntityWithVessel = findFirstEntityWithVessel
		local function findFirstEntityWithVesselThatContainsInstance(instance)
			for _, v in pairs(entities) do
				if v.vessel and instance:IsDescendantOf(v.vessel) then
					return v
				end
			end
		end
		_container_1.findFirstEntityWithVesselThatContainsInstance = findFirstEntityWithVesselThatContainsInstance
	end
	_container.query = query
end
return space
