import { getActionController } from "shared/global/clientExposed";
import gunwork from "shared/gunwork";

export default abstract class item {

	//absolute
	active: boolean = false;

	/**
	 * can be used to vaguely know the "type" of the item
	 */
	typeIdentifier: gunwork.itemTypeIdentifier = gunwork.itemTypeIdentifier.none;

	//internal

	userEquipped: boolean = false;
	userEquipping: boolean = false;
	userUnequipping: boolean = false;

	canUserEquip: boolean = false;
	canUserUnequip: boolean = false;

	//config
	/**
	 * determines if the item is automatically equipped when it's user changes
	 */
	equipOnAcquisition: boolean = false;
	/**
	 * determines if the item is dropped when the user dies[method died] or the user 
	 */
	dropOnUserDeath: boolean = false;
	/**
	 * determines if the item can be dropped
	 */
	canBeDropped: boolean = false;
	/**
	 * determines if the item can be equipped
	 */
	canBeEquipped: boolean = true;

	/**
	 * time it takes for the item to be fully equipped after [method equip] was called
	 */
	equipTime: number = 0;
	/**
	 * leeway given for methods that depend on the item being equipped to work while the item is not fully equipped
	 */
	equipTimeMargin: number = 0;

	constructor(
		public serverItemIdentification: string
	) {
		
	}

	//methods
	equip() {
		if (!this.canBeEquipped) return;
		if (this.userEquipped || this.userEquipping) return;

		let ac = getActionController()

		this.userEquipping = true;
		
		if (ac.equippedItem) {
			ac.equippedItem.unequip()
		}

		ac.itemBeingEquipped = true;

		task.wait(this.equipTime);

		this.userEquipping = false;
		this.userEquipped = true;

		ac.itemBeingEquipped = false;
		ac.equippedItem = this;
	}
	forceEquip() {
		this.userEquipped = true;
		this.userEquipping = false;
	}
	unequip() {
		this.userEquipped = false;
		this.userEquipping = false;
	}
	forceUnequip() {
		this.userEquipped = false;
		this.userEquipping = false;
	}
	drop() {/**todo */}
	forceDrop() {/**todo */}
	died() {/**todo */}
}