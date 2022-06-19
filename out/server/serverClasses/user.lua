-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local human = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "entities", "human").default
local user
do
	local super = human
	user = setmetatable({}, {
		__tostring = function()
			return "user"
		end,
		__index = super,
	})
	user.__index = user
	function user.new(...)
		local self = setmetatable({}, user)
		return self:constructor(...) or self
	end
	function user:constructor()
		super.constructor(self)
		self.character = nil
		self.client = nil
	end
	function user:setClient(client)
		self.client = client
	end
	function user:setCharacter(character)
		self.character = character
		self.vessel = character
	end
end
return {
	default = user,
}
