-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _model = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "model").model
local _schema = TS.import(script, game:GetService("ServerScriptService"), "TS", "radon", "schema").schema
local radon = {}
do
	local _container = radon
	local schema = _schema
	_container.schema = schema
	local model = _model
	_container.model = model
	local Types = radonTypes.Types
	_container.Types = Types
end
return radon
