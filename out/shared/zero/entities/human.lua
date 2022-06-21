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
		self.maxHealth = 0
		self.damaged = connection.new()
		self.healed = connection.new()
		self.died = connection.new()
	end
	function human:takeDamage(damage, ...)
		local args = { ... }
		if self.health - damage < 0 then
			local diff = self.health - damage
			self.damaged:fire(self.health, 0, damage, diff)
			self.health = 0
		else
			self.damaged:fire(self.health, 0, self.health - damage, 0)
			self.health -= damage
		end
	end
	function human:heal(hp)
		local increase = self.health + hp
		local og = increase
		if increase > self.maxHealth then
			increase = self.maxHealth
		end
		local diff = math.abs(og - increase)
		self.healed:fire(self.health, increase, diff)
		self.health = increase
	end
	function human:alive()
		return self.health > 0
	end
end
return {
	default = human,
}
