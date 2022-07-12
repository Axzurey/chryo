-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local radonCode = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "errors")
local datastore = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "datastore")
local function model(key, schema)
	local radonModel
	do
		radonModel = setmetatable({}, {
			__tostring = function()
				return "radonModel"
			end,
		})
		radonModel.__index = radonModel
		function radonModel.new(...)
			local self = setmetatable({}, radonModel)
			return self:constructor(...) or self
		end
		function radonModel:constructor()
		end
		radonModel.get = TS.async(function(self)
			return TS.Promise.new(function(resolve, reject)
				local data = datastore.load(key, schema.databaseKey)
				if data ~= 0 and (data == data and (data ~= "" and data)) then
					local d = data
					for i, v in pairs(schema.params) do
						local t = self
						t[i] = d[i]
					end
					resolve(radonCode.success)
				else
					reject(radonCode.noData)
				end
			end)
		end)
		radonModel.save = TS.async(function(self)
			return TS.Promise.new(function(resolve, reject)
				local save = {}
				for i, v in pairs(schema.params) do
					local t = self
					save[i] = t[i]
				end
				save = save
				local value = datastore.save(key, schema.databaseKey, save)
				if value == radonCode.success then
					resolve(true)
				else
					reject(value)
				end
			end)
		end)
	end
	return radonModel
end
return {
	model = model,
}
