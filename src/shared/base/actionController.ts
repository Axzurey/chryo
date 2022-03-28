import { ContextActionService } from "@rbxts/services";
import gun from "shared/extended/gun";
import item from "./item";

export default class actionController {
	private equippedItem: item | undefined;

	private keybinds = {
		aim: Enum.UserInputType.MouseButton2,
		fire: Enum.UserInputType.MouseButton1,
        reload: Enum.KeyCode.R,
	}

	private actionMap: Record<keyof typeof this.keybinds, (state: Enum.UserInputState) => void> = {
		aim: (state) => {
			if (this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.aim(state === Enum.UserInputState.Begin? true: false);
			}
		},
		fire: () => {
			return 'TODO'
		},
        reload: () => {
            return 'TODO'
        }
	}

	constructor() {
		ContextActionService.BindAction('context:actionController', (_action, state, input) => {
			let key = this.getKeybind(input);
            if (key) {
                this.actionMap[key](state);
            }
		}, false)
	}

	private getKeybind(input: InputObject) {
		for (const [alias, key] of pairs(this.keybinds)) {
			if (key.Name === input.KeyCode.Name || key.Name === input.UserInputType.Name) {
                return alias;
            }
		}
	}

	private equippedIsAGun(equipped: item | undefined): equipped is gun {
		if (equipped) {
			if (equipped.typeIdentifier === gunwork.itemTypeIdentifier.gun) {
				return true;
			}
		}
		return false;
	}
}