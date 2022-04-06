import { ContextActionService, RunService, Workspace } from "@rbxts/services";
import gun from "shared/extended/gun";
import clientExposed from "shared/middleware/clientExposed";
import gunwork from "shared/types/gunwork";
import item from "./item";

export default class actionController {
	private equippedItem: item | undefined;

	private keybinds = {
		aim: Enum.UserInputType.MouseButton2,
		fire: Enum.UserInputType.MouseButton1,
        reload: Enum.KeyCode.R,
		leanRight: Enum.KeyCode.E,
		leanLeft: Enum.KeyCode.Q
	}

	private actionMap: Record<keyof typeof this.keybinds, (state: Enum.UserInputState) => void> = {
		aim: (state) => {
			if (this.equippedIsAGun(this.equippedItem)) {
				print('aim switch!')
				let gun = this.equippedItem;
				gun.aim(state === Enum.UserInputState.Begin? true: false);
			}
		},
		fire: (state) => {
			return 'TODO'
		},
        reload: (state) => {
            return 'TODO'
        },
		leanLeft: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.lean(-1)
			}
		},
		leanRight: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.lean(1)
			}
		}
	}

	private starting(state: Enum.UserInputState): state is Enum.UserInputState.Begin {
		if (state === Enum.UserInputState.Begin) return true;
		return false;
	}

	private ending(state: Enum.UserInputState): state is Enum.UserInputState.End {
		if (state === Enum.UserInputState.End) return true;
		return false;
	}

	constructor() {
		
		let item = new gun('$xoo', 'ReplicatedStorage//guns//hk416');
		this.equippedItem = item;

		clientExposed.setCamera(Workspace.CurrentCamera as Camera);
		
		ContextActionService.BindAction('context:actionController', (_action, state, input) => {
			let key = this.getKeybind(input);
            if (key) {
                this.actionMap[key](state);
            }
			return Enum.ContextActionResult.Pass
		}, false, ...[...Enum.KeyCode.GetEnumItems(), ...Enum.UserInputType.GetEnumItems()]);

		let render = RunService.RenderStepped.Connect((dt) => {
			let equipped = this.equippedItem;
			if (this.equippedIsAGun(equipped)) {
				equipped.update(dt);
			}
		})
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