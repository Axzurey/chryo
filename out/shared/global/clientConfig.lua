-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local tableUtils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").tableUtils
local defaultSettings = {
	general = {
		sightColor = Color3.new(),
		sensitivity = .5,
		adsSensitivity = 1,
	},
}
local clientConfig
do
	clientConfig = setmetatable({}, {
		__tostring = function()
			return "clientConfig"
		end,
	})
	clientConfig.__index = clientConfig
	function clientConfig.new(...)
		local self = setmetatable({}, clientConfig)
		return self:constructor(...) or self
	end
	function clientConfig:constructor(providedSettings)
		self.settings = defaultSettings
		self.settings = tableUtils.fillDefaults(providedSettings, defaultSettings)
	end
end
return {
	default = clientConfig,
}
