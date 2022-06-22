import { HttpService, Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import path from "shared/athena/path";
import { newThread } from "shared/athena/utils";
import crosshairController from "shared/classes/crosshairController";
import gun from "shared/extended/gun";
import hk416_definition from "shared/gunDefinitions/hk416";
import m870_definition from "shared/gunDefinitions/m870";
import clientConfig from "shared/local/clientConfig";
import rappel from "shared/mechanics/rappel";
import vault from "shared/mechanics/vault";
import clientExposed, { getCamera } from "shared/middleware/clientExposed";
import gunwork, { fireMode } from "shared/types/gunwork";
import key from "shared/util/key";
import system from "shared/zero/system";
import item from "./item";

const client = Players.LocalPlayer;

export default class actionController {
	private equippedItem: item | undefined;

	public keybinds = {
		aim: Enum.UserInputType.MouseButton2,
		fire: Enum.UserInputType.MouseButton1,
        reload: Enum.KeyCode.R,
		leanRight: Enum.KeyCode.E,
		leanLeft: Enum.KeyCode.Q,
		prone: Enum.KeyCode.LeftControl,
		crouch: Enum.KeyCode.C,
		vault: Enum.KeyCode.Space,
		rappel: Enum.KeyCode.Space,
		reinforce: Enum.KeyCode.V,
	}

	vaulting: boolean = false;
	rappelling: boolean = false;

	idlePrompts: 0[] = [];

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
				this.crosshairController.toggleVisible(state === Enum.UserInputState.Begin, gun.adsLength * .75)
			}
		},
		fire: (state) => {
			if (this.starting(state) && this.equippedIsAGun(this.equippedItem)) {
				let gun = this.equippedItem;

				let firemode = gun.togglableFireModes[gun.currentFiremode];
				if (!firemode) {
					firemode = gun.togglableFireModes[0];
				}

				if (firemode === fireMode.semi || firemode === fireMode.shotgun) {
					gun.manualFire();
				}
				else {
					gun.cancelReload();
					gun.fireButtonDown = true;
					gun.currentClickId = HttpService.GenerateGUID();
				}

				

				
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
		rappel: async (state) => {
			if (this.starting(state)) {

				let ignore = new RaycastParams();
				ignore.FilterDescendantsInstances = [clientExposed.getCamera(), Players.LocalPlayer.Character!];

				if (!rappel.check(ignore)) return; //check if they can even rappel
				
				this.idlePrompts.push(0); //make them unable to move

				let hold = await key.waitForKeyUp({
					key: this.getKey('rappel'),
					maxLength: 1,
					onUpdate: (elapsedTime) => {
						//update a gui or smth
					}
				});

				this.idlePrompts.pop(); //just remove an item from it.

				if (hold < 1) return;
				
				rappel.Rappel(ignore);
			}
		},
		reinforce: (state) => {
			if (this.starting(state)) {
				system.remote.client.fireServer('startReinforcement', getCamera().CFrame)
			}
			else {
				//ends
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

		const clientSettings = new clientConfig({});

		clientExposed.setActionController(this);
		clientExposed.setCamera(Workspace.CurrentCamera as Camera);
		clientExposed.setBaseWalkSpeed(12);

		clientExposed.setClientConfig(clientSettings);

		let item = m870_definition('Gun1');

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
			let keys = this.getKeybinds(input);
			if (keys.size() > 0) {
				keys.forEach((key) => {
					newThread(() => {
						this.actionMap[key](input.UserInputState);
					})
				})
			}
		})

		let mainInputEnd = UserInputService.InputEnded.Connect((input) => {
			let keys = this.getKeybinds(input);
			if (keys.size() > 0) {
				keys.forEach((key) => {
					newThread(() => {
						this.actionMap[key](input.UserInputState);
					})
				})
			}
		})

		system.remote.client.on('clientFlingBasepart', (inst, pos, dir) => {
			inst.ApplyImpulseAtPosition(dir, pos)
		})
	}

	getKeybinds(input: InputObject) {
		let g: (keyof typeof this.keybinds)[] = []
		for (const [alias, key] of pairs(this.keybinds)) {
			if (key.Name === input.KeyCode.Name || key.Name === input.UserInputType.Name) {
                g.push(alias);
            }
		}
		return g;
	}

	inputIs(input: InputObject, check: keyof typeof this.keybinds) {
		let t = this.keybinds[check].Name
		if (input.UserInputType.Name === t || input.KeyCode.Name === t) return true;
		return false;
	}

	getKey(keybind: keyof typeof this.keybinds) {
		return this.keybinds[keybind]
	}

	equippedIsAGun(equipped: item | undefined): equipped is gun {
		if (equipped) {
			if (equipped.typeIdentifier === gunwork.itemTypeIdentifier.gun) {
				return true;
			}
		}
		return false;
	}
}