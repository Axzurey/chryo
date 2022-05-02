import { Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import { newThread } from "shared/athena/utils";
import gun from "shared/extended/gun";
import clientExposed from "shared/middleware/clientExposed";
import gunwork, { fireMode } from "shared/types/gunwork";
import item from "./item";

export default class actionController {
	private equippedItem: item | undefined;

	private keybinds = {
		aim: Enum.UserInputType.MouseButton2,
		fire: Enum.UserInputType.MouseButton1,
        reload: Enum.KeyCode.R,
		leanRight: Enum.KeyCode.E,
		leanLeft: Enum.KeyCode.Q,
		prone: Enum.KeyCode.Z,
		crouch: Enum.KeyCode.C
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
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.fireButtonDown = true;
			}
			else if (this.ending(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.fireButtonDown = false;
			}
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
		},
		crouch: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.changeStance(0)
			}
		},
		prone: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.changeStance(-1)
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

		if (!Players.LocalPlayer.Character) {
			Players.LocalPlayer.CharacterAdded.Wait();
			while (!Players.LocalPlayer.Character!.PrimaryPart) {
				task.wait();
			}
			print("done! starting...")
		}

		clientExposed.setActionController(this);
		clientExposed.setCamera(Workspace.CurrentCamera as Camera);
		clientExposed.setBaseWalkSpeed(12);

		let item = new gun('Gun1', 'ReplicatedStorage//guns//hk416&class=Model', {
			sight: {
				name: 'holographic',
				path: 'ReplicatedStorage//sights//holographic&class=Model',
				zOffset: .13
			}
		}, {
			idle: 'rbxassetid://9335189959'
		});

		item.firerate = {
			burst2: 600,
			auto: 800,
			burst3: 600,
			burst4: 600,
			shotgun: 1000,
			semi: 800
		}

		item.togglableFireModes = [fireMode.auto, fireMode.semi]

		item.reloadSpeed = 1.5;

		this.equippedItem = item;

		let mainRender = RunService.RenderStepped.Connect((dt) => {
			let equipped = this.equippedItem;
			if (this.equippedIsAGun(equipped)) {
				equipped.update(dt);
			}
		})

		UserInputService.MouseIconEnabled = false;
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
		
		let mainInputStart = UserInputService.InputBegan.Connect((input, gp) => {
			if (gp) return;
			let key = this.getKeybind(input);
			if (key) {
				this.actionMap[key](input.UserInputState);
			}
		})

		let mainInputEnd = UserInputService.InputEnded.Connect((input) => {
			let key = this.getKeybind(input);
			if (key) {
				this.actionMap[key](input.UserInputState);
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