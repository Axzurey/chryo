-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "types", "gunwork")
local serverItem
do
	serverItem = {}
	function serverItem:constructor(serverItemIdentification)
		self.serverItemIdentification = serverItemIdentification
		self.active = false
		self.typeIdentifier = gunwork.itemTypeIdentifier.none
		self.userEquipped = false
		self.userEquipping = false
		self.userUnequipping = false
		self.canUserEquip = false
		self.canUserUnequip = false
		self.equipOnAcquisition = false
		self.dropOnUserDeath = false
		self.canBeDropped = false
		self.canBeEquipped = true
		self.equipTime = 0
		self.equipTimeMargin = 0
	end
	function serverItem:getUser()
		return self.user
	end
	function serverItem:setUser(user)
		self.user = user
		self:userChanged(user)
	end
	function serverItem:equip()
	end
	function serverItem:forceEquip()
	end
	function serverItem:unequip()
	end
	function serverItem:forceUnequip()
	end
	function serverItem:drop()
	end
	function serverItem:forceDrop()
	end
	function serverItem:died()
	end
	function serverItem:userChanged(user)
	end
end
return {
	default = serverItem,
}
