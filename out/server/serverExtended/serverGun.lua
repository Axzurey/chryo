-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local serverItem = TS.import(script, game:GetService("ServerScriptService"), "TS", "serverBase", "serverItem").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "rocast").default
local serverGun
do
	local super = serverItem
	serverGun = setmetatable({}, {
		__tostring = function()
			return "serverGun"
		end,
		__index = super,
	})
	serverGun.__index = serverGun
	function serverGun.new(...)
		local self = setmetatable({}, serverGun)
		return self:constructor(...) or self
	end
	function serverGun:constructor(serverId)
		super.constructor(self, serverId)
	end
	function serverGun:fire(from, direction)
		local caster = rocaster.new({
			from = from,
			direction = direction,
			maxDistance = 999,
			ignore = {},
		})
		local result = caster:cast({
			canPierce = function(result)
				return {
					damageMultiplier = 1,
					weight = 1,
				}
			end,
		})
	end
end
return {
	default = serverGun,
}
