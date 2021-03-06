import { HttpService, Players, RunService, UserInputService, Workspace } from "@rbxts/services";
import path from "shared/modules/path";
import { newThread } from "shared/modules/utils";
import crosshairController from "shared/classes/crosshairController";
import gun from "shared/global/gun";
import hk416_definition from "shared/gunDefinitions/hk416";
import m870_definition from "shared/gunDefinitions/m870";
import clientConfig from "shared/global/clientConfig";
import rappel from "shared/mechanics/rappel";
import vault from "shared/mechanics/vault";
import clientExposed, { getCamera } from "shared/global/clientExposed";
import gunwork, { fireMode, reloadType } from "shared/gunwork";
import key from "shared/util/key";
import rocaster from "shared/entities/rocast";
import system from "shared/entities/system";
import item from "./item";
import drone from "shared/classes/drone";
import observable from "shared/classes/observable";
import userContext from "shared/util/userContext";

const client = Players.LocalPlayer;

export default class actionController {
	public equippedItem: item | undefined;
	public itemBeingEquipped: boolean = false;

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
		throwDrone: Enum.KeyCode.Six,
		toggleCameras: Enum.KeyCode.Five,
		primary: Enum.KeyCode.One,
		secondary: Enum.KeyCode.Two
	}

	vaulting: boolean = false;
	rappelling: boolean = false;

	idlePrompts: 0[] = [];

	public crosshairController = new crosshairController();

	start = Enum.UserInputState.Begin;
	end = Enum.UserInputState.End;

	cameras: observable[] = [];

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
				if (gun.reloading) return;
				if (gun.reloadType === reloadType.mag) {
					gun.startReload();
				}
				else if (gun.reloadType === reloadType.shell) {
					let diff = gun.maxAmmo - gun.ammo;
					gun.reloading = true;
					gun.initiateSingleAnimation()
					let shell = gun.loadShell()
					for (let i = 0; i < diff; i++) {
						gun.reloadSingle();
						//task.wait(gun.reloadSpeed / gun.maxAmmo);
						if (gun.maxAmmo - gun.ammo <= 0) break;
					}

					if (shell) {
						shell.Destroy()
					}

					gun.reloading = false
				}
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
		reinforce: async (state) => {
			const reinforceRange = 8
			if (this.starting(state)) {

				let cameraCFrame = getCamera().CFrame;

				let lookvector = cameraCFrame.LookVector.sub(new Vector3(0, cameraCFrame.LookVector.Y, 0)); //remove the y, it's a bother.

				let caster = new rocaster({
					from: cameraCFrame.Position,
					direction: lookvector,
					maxDistance: reinforceRange,
					ignore: [client.Character as Model],
					ignoreNames: ['HumanoidRootPart'],
					debug: false
				});

				let wallCast = caster.cast({
					canPierce: (result) => {
						return undefined
						/*return {
							damageMultiplier: 1,
							weight: 1
						}*/
					}
				});

				if (!wallCast) {
					print('there is no wall!')
					return
				}

				let attr = wallCast.instance.GetAttribute('reinforcable');
				if (!attr) return;

				system.remote.client.fireServer('startReinforcement', getCamera().CFrame);

				this.idlePrompts.push(0); //make them unable to move

				let hold = await key.waitForKeyUp({
					key: this.getKey('reinforce'),
					maxLength: 2.5,
					onUpdate: (elapsedTime) => {
						//update a gui or smth
					}
				});

				this.idlePrompts.pop()

				if (hold < 2.3) {
					system.remote.client.fireServer('cancelReinforcement');
				}
			}
		},
		throwDrone: (state) => {
			if (!this.starting(state)) return;
			system.remote.client.fireServer('throwDrone')
		},
		toggleCameras: (state) => {
			this.onCameras = !this.onCameras;

			if (this.onCameras) {
				let cameraIndex = this.cameras[this.cameraIndex];
		
			}
		},
		primary: (state) => {
			let gun = this.guns[0];

			if (!this.equippedIsAGun(gun)) return;

			if (this.starting(state)) {
				gun.equip()
			}
		},
		secondary: (state) => {
			let gun = this.guns[1];

			if (!this.equippedIsAGun(gun)) return;

			if (this.starting(state)) {
				gun.equip()
			}
		}
	}

	onCameras: boolean = false;
	cameraIndex: number = 0;

	guns: gun[] = []

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
		let item2 = hk416_definition('Gun2');
		this.guns.push(item);
		this.guns.push(item2)

		this.equippedItem = item;

		RunService.BindToRenderStep('main_render', Enum.RenderPriority.Last.Value, (dt) => {
			let equipped = this.equippedItem;
			let humanoid = this.character.FindFirstChild("Humanoid") as Humanoid;
			let camera = getCamera();

			if (this.character.PrimaryPart) {
				if (this.vaulting || this.rappelling) {
					this.character.PrimaryPart.Anchored = true;
				}
				else {
					this.character.PrimaryPart.Anchored = false;
				}
			}

			//UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
			//client.CameraMode = Enum.CameraMode.LockFirstPerson

			if (this.onCameras) {
				let index = this.cameraIndex;
				let cameraChoice = index < this.cameras.size() ? this.cameras[this.cameraIndex] : this.cameras[0]

				humanoid.WalkSpeed = 0;

				camera.CFrame = cameraChoice.model.focus.CFrame;
			}
			else if (this.equippedIsAGun(equipped)) {
				equipped.update(dt);
				
				let [cx, cy, cz] = camera.CFrame.ToOrientation();

				let recoilUpdated = equipped.springs.recoil.update(dt);

				camera.CFrame = new CFrame(camera.CFrame.Position)
					.mul(equipped.values.stanceOffset.Value)
					.mul(CFrame.fromOrientation(cx, cy, cz))
					.mul(equipped.values.leanOffsetCamera.Value)
					.mul(CFrame.Angles(math.rad(recoilUpdated.Y), math.rad(recoilUpdated.X), 0));
			}

			this.cameras.forEach((v) => {
				v.update()
			})

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

		system.remote.client.on('throwDrone', (id: string, owner: Player, model: Model) => {
			let d = new drone(id, owner, model);
			print(id)
			print('drone created!')
			this.cameras.push(d);
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
	getTransferCFrameValues() {
		let g = this.equippedItem
		if (!this.equippedIsAGun(g)) return;
		
		return g.values;
	}
}