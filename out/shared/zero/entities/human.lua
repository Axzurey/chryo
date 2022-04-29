-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local entity = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "basic", "entity").default
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
		self.health = 0
	end
end
return {
	default = human,
}
