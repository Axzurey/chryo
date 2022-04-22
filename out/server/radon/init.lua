-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local datastore = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "datastore")
local radonCode = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "errors")
local radon = {}
do
	local _container = radon
	local Types
	do
		local _inverse = {}
		Types = setmetatable({}, {
			__index = _inverse,
		})
		Types.String = "String"
		_inverse.String = "String"
		Types.Number = "Number"
		_inverse.Number = "Number"
		Types.Boolean = "Boolean"
		_inverse.Boolean = "Boolean"
		Types.Color3 = "Color3"
		_inverse.Color3 = "Color3"
		Types.Undefined = "Undefined"
		_inverse.Undefined = "Undefined"
	end
	_container.Types = Types
	local schema
	do
		schema = setmetatable({}, {
			__tostring = function()
				return "schema"
			end,
		})
		schema.__index = schema
		function schema.new(...)
			local self = setmetatable({}, schema)
			return self:constructor(...) or self
		end
		function schema:constructor(databaseKey, params)
			self.databaseKey = databaseKey
			self.params = params
		end
	end
	_container.schema = schema
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
	_container.model = model
end
return radon
