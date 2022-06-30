-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local human = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "entityClasses", "human").default
local connection = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "connection").default
local characterState
do
	local _inverse = {}
	characterState = setmetatable({}, {
		__index = _inverse,
	})
	characterState.alive = 0
	_inverse[0] = "alive"
	characterState.dead = 1
	_inverse[1] = "dead"
	characterState.dbno = 2
	_inverse[2] = "dbno"
end
local downDamageDifferenceFromZero = 20
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
		self.state = characterState.alive
		self.characterStateChanged = connection.new()
	end
	function user:heal(hp)
	end
	function user:takeDamage(damage, definiteDowns)
		if self.state == characterState.dead then
			return nil
		end
		local diff = self.health - damage
		if diff > downDamageDifferenceFromZero and (self.state ~= characterState.dbno and not definiteDowns) then
			self.state = characterState.alive
		else
			-- they can be downed
			self.characterStateChanged:fire(self.state, characterState.dbno)
			self.state = characterState.dbno
			self.health = 10
		end
	end
	function user:isAlive()
		return self.state == characterState.alive
	end
	function user:isDBNO()
		return self.state == characterState.dbno
	end
	function user:setClient(client)
		self.client = client
	end
	function user:setCharacter(character)
		self.character = character
		self.vessel = character
	end
	function user:tick(dt)
		if self.state == characterState.dbno then
			self.health -= 45 * dt
		end
		if not self.character then
			return nil
		end
		self.character.Humanoid.MaxHealth = self.maxHealth
		self.character.Humanoid.Health = self.health
	end
end
return {
	characterState = characterState,
	default = user,
}
