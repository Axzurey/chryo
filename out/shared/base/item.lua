-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getActionController = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed").getActionController
local gunwork = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "gunwork")
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
	function item:equip()
		if not self.canBeEquipped then
			return nil
		end
		if self.userEquipped or self.userEquipping then
			return nil
		end
		local ac = getActionController()
		self.userEquipping = true
		if ac.equippedItem then
			ac.equippedItem:unequip()
		end
		ac.itemBeingEquipped = true
		task.wait(self.equipTime)
		self.userEquipping = false
		self.userEquipped = true
		ac.itemBeingEquipped = false
		ac.equippedItem = self
	end
	function item:forceEquip()
		self.userEquipped = true
		self.userEquipping = false
	end
	function item:unequip()
		self.userEquipped = false
		self.userEquipping = false
	end
	function item:forceUnequip()
		self.userEquipped = false
		self.userEquipping = false
	end
	function item:drop()
	end
	function item:forceDrop()
	end
	function item:died()
	end
end
return {
	default = item,
}
