-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local DataStoreService = TS.import(script, TS.getModule(script, "@rbxts", "services")).DataStoreService
local radonCode = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "errors")
local datastore = {}
do
	local _container = datastore
	--[[
		*
		* returns 0 if it saves successfully, otherwise, 1
	]]
	local function save(key, datastore, value)
		local store = DataStoreService:GetDataStore(datastore)
		local _exitType, _returns = TS.try(function()
			store:SetAsync(key, value)
			return TS.TRY_RETURN, { radonCode.success }
		end, function(e)
			local err = e
			if { string.find(err, "403") } then
				return TS.TRY_RETURN, { radonCode.noApiAccess }
			end
			return TS.TRY_RETURN, { radonCode.unexpected }
		end)
		if _exitType then
			return unpack(_returns)
		end
	end
	_container.save = save
	local function load(key, datastore, defaultValue)
		local store = DataStoreService:GetDataStore(datastore)
		local _exitType, _returns = TS.try(function()
			return TS.TRY_RETURN, { store:GetAsync(key) }
		end, function(e)
			local err = e
			if { string.find(err, "403") } then
				return TS.TRY_RETURN, { radonCode.noApiAccess }
			end
			return TS.TRY_RETURN, { if defaultValue ~= 0 and (defaultValue == defaultValue and (defaultValue ~= "" and defaultValue)) then defaultValue else radonCode.noData }
		end)
		if _exitType then
			return unpack(_returns)
		end
	end
	_container.load = load
end
return datastore
