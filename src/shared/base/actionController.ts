import { Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import path from "shared/athena/path";
import { newThread } from "shared/athena/utils";
import crosshairController from "shared/classes/crosshairController";
import gun from "shared/extended/gun";
import hk416_definition from "shared/gunDefinitions/hk416";
import rappel from "shared/mechanics/rappel";
import vault from "shared/mechanics/vault";
import clientExposed from "shared/middleware/clientExposed";
import gunwork, { fireMode } from "shared/types/gunwork";
import item from "./item";

export default class actionController {
	private equippedItem: item | undefined;

	public keybinds = {
		aim: Enum.UserInputType.MouseButton2,
		fire: Enum.UserInputType.MouseButton1,
        reload: Enum.KeyCode.R,
		leanRight: Enum.KeyCode.E,
		leanLeft: Enum.KeyCode.Q,
		prone: Enum.KeyCode.Z,
		crouch: Enum.KeyCode.C,
		vault: Enum.KeyCode.Space,
		rappel: Enum.KeyCode.N
	}

	vaulting: boolean = false;
	rappelling: boolean = false;

	public crosshairController = new crosshairController();

	start = Enum.UserInputState.Begin;
	end = Enum.UserInputState.End;

	actionMap: Record<keyof typeof this.keybinds, (state: Enum.UserInputState) => void> = {
		aim: (state) => {
			if (this.equippedIsAGun(this.equippedItem)) {
				print('aim switch!')
				let gun = this.equippedItem;
				gun.cancelReload()
				gun.aim(state === Enum.UserInputState.Begin? true: false);
			}
		},
		fire: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.cancelReload()
				gun.fireButtonDown = true;
			}
			else if (this.ending(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.cancelReload()
				gun.fireButtonDown = false;
			}
		},
        reload: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.startReload();
			}
            return 'TODO'
        },
		leanLeft: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.lean(-1);
			}
		},
		leanRight: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.lean(1);
			}
		},
		crouch: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.changeStance(0);
			}
		},
		prone: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;
				gun.changeStance(-1);
			}
		},
		vault: (state) => {
			if (this.starting(state)) {
				let ignore = new RaycastParams();
				ignore.FilterDescendantsInstances = [clientExposed.getCamera(), Players.LocalPlayer.Character!];
				vault.Vault(ignore)
			}
		},
		rappel: (state) => {
			if (this.starting(state)) {
				let ignore = new RaycastParams();
				ignore.FilterDescendantsInstances = [clientExposed.getCamera(), Players.LocalPlayer.Character!];
				rappel.Rappel(ignore);
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

	character = Players.LocalPlayer.Character || Players.LocalPlayer.CharacterAdded.Wait()[0]

	constructor() {

		if (!this.character.PrimaryPart) {
			this.character.GetPropertyChangedSignal('PrimaryPart').Wait();
		}

		clientExposed.setActionController(this);
		clientExposed.setCamera(Workspace.CurrentCamera as Camera);
		clientExposed.setBaseWalkSpeed(12);

		let item = hk416_definition('Gun1')

		this.equippedItem = item;

		RunService.BindToRenderStep('main_render', Enum.RenderPriority.Last.Value, (dt) => {
			let equipped = this.equippedItem;

			if (this.character.PrimaryPart) {
				if (this.vaulting || this.rappelling) {
					this.character.PrimaryPart.Anchored = true;
				}
				else {
					this.character.PrimaryPart.Anchored = false;
				}
			}

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