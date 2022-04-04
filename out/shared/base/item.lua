-- Compiled with roblox-ts v1.3.3
local item
do
	item = {}
	function item:constructor(serverItemIdentification)
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
	function item:getUser()
		return self.user
	end
	function item:setUser(user)
		self.user = user
		self:userChanged(user)
	end
	function item:equip()
	end
	function item:forceEquip()
	end
	function item:unequip()
	end
	function item:forceUnequip()
	end
	function item:drop()
	end
	function item:forceDrop()
	end
	function item:died()
	end
	function item:userChanged(user)
	end
end
return {
	default = item,
}
