-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local entity = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "basic", "entity").default
local entityType = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "define", "zeroDefinitions").entityType
local connection = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "signals", "connection").default
local human
do
	local super = entity
	human = setmetatable({}, {
		__tostring = function()
			return "human"
		end,
		__index = super,
	})
	human.__index = human
	function human.new(...)
		local self = setmetatable({}, human)
		return self:constructor(...) or self
	end
	function human:constructor(...)
		super.constructor(self, ...)
		self.entityType = entityType.human
		self.health = 0
		self.damaged = connection.new()
	end
	function human:takeDamage(damage)
		if self.health - damage < 0 then
			local diff = self.health - damage
			self.damaged:fire(self.health, 0, damage, diff)
			self.health = 0
			return diff
		else
			self.damaged:fire(self.health, 0, self.health - damage, 0)
			self.health -= damage
			return -1
		end
	end
end
return {
	default = human,
}
