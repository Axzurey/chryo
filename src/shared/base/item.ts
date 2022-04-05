import gunwork from "shared/types/gunwork";

export default abstract class item {

	//absolute
	active: boolean = false;

	/**
	 * can be used to vaguely know the "type" of the item
	 */
	typeIdentifier: gunwork.itemTypeIdentifier = gunwork.itemTypeIdentifier.none;

	//internal
	//maybe this can have another type, like a bot type?
	private user?: Player;

	getUser() {
		return this.user
	}

	setUser(user: Player | undefined) {
		this.user = user
		this.userChanged(user)
	}

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
	equip() {/**todo */}
	forceEquip() {/**todo */}
	unequip() {/**todo */}
	forceUnequip() {/**todo */}
	drop() {/**todo */}
	forceDrop() {/**todo */}
	died() {/**todo */}
	userChanged(user: Player | undefined) {/**todo */}
}