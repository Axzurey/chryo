import path from "shared/athena/path";
import item from "shared/base/item";
import paths from "shared/constants/paths";
import clientExposed, { getActionController, getClientConfig } from "shared/middleware/clientExposed";
import gunwork, { fireMode, gunAnimationsConfig, gunAttachmentConfig, reloadType, sightModel } from "shared/types/gunwork";
import utils, { later, newThread, random, tableUtils } from 'shared/athena/utils';
import { HttpService, Players, TweenService, UserInputService } from "@rbxts/services";
import animationCompile from "shared/athena/animate";
import system from "shared/zero/system";
import mathf from "shared/athena/mathf";
import spring from "shared/base/spring";
import tracer from "shared/classes/tracer";

export default class gun extends item {

	//absolute
	typeIdentifier = gunwork.itemTypeIdentifier.gun

	//internal

	connections: Record<string, RBXScriptConnection> = {}

	cameraCFrame: CFrame = new CFrame()

	viewmodel: gunwork.gunViewmodel

	camera?: Camera;
	character: gunwork.basicCharacter;
	
	firePoint?: BasePart;

	lastFired: number = 0;

	currentFiremode: number = 0;
	lastFiremodeSwitch: number = 0;

	fireButtonDown: boolean = false;

	currentRecoilIndex: number = 0;

	currentReloadId?: string = undefined
	
	lastReload: number = 0;
	/**
	 * this value is increased with each shot taken and is multiplied with unads spread
	 */
	spreadDelta: number = 0;

	sprinting: boolean = false;
	togglingAim: boolean = false;
	aiming: boolean = false;
	reloading: boolean = false;
	stance: -1 | 0 | 1 = 1; //standing = 1; crouching = 0; prone = -1;
	lastLeanDirection: -1 | 0 | 1 = 0;
	leanDirection: -1 | 0 | 1 = 0;
	inspecting: boolean = false;
	sneaking: boolean = false;
	proneChanging: boolean = false;

	wantsToSprint: boolean = false;
	wantsToAim: boolean = false;

	lastClickIdUsed: string = '';
	currentClickId: string = '';

	cframes = {
		idle: new CFrame(),
		aimOffset: new CFrame(),
		sprintOffset: new CFrame(),
		cameraBob: new CFrame(),
		viewmodelBob: new CFrame(),
	}

	loadedAnimations: Partial<Record<keyof gunwork.gunAnimationsConfig, AnimationTrack>> = {}

	staticOffsets = {
		leanRight: CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-25)),
		leanLeft: CFrame.fromEulerAnglesYXZ(0, 0, math.rad(25)),
		leanRightCamera: new CFrame(.7, 0, 0).mul(CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-10))),
		leanLeftCamera: new CFrame(-.7, 0, 0).mul(CFrame.fromEulerAnglesYXZ(0, 0, math.rad(10))),
		crouchOffset: new CFrame(0, -1, 0),
		proneOffset: new CFrame(0, -3, 0),
	}

	springs = {
		recoil: spring.create(5, 75, 3, 4),
		viewmodelRecoil: spring.create(5, 85, 3, 10)
	}

	values = {
        aimDelta: new Instance("NumberValue"),
		leanOffsetViewmodel: new Instance("CFrameValue"),
		leanOffsetCamera: new Instance("CFrameValue"),
		stanceOffset: new Instance("CFrameValue"),
    }

	multipliers = {
		speed: {
			prone: .2,
			crouch: .5,
		}
	}

	lastPosition: Vector3

	firerate = {
		auto: 0,
		semi: 0,
		burst2: 0,
		burst3: 0,
		burst4: 0,
		shotgun: 0
	}

	unaimAfterShot: boolean = false;

	bulletsAShot: Record<fireMode, number> = {
		[fireMode.auto]: 1,
		[fireMode.semi]: 1,
		[fireMode.burst2]: 2,
		[fireMode.burst3]: 3,
		[fireMode.burst4]: 4,
		[fireMode.shotgun]: 8,
	}

	reloadSpeed: number = 0;
	penetration: number = 0;

	bodyDamage: number = 0;
	limbDamage: number = 0;
	headDamage: number = 0;

	canAimWith: boolean = true;
	canLeanWith: boolean = true;
	canSprintWith: boolean = true;

	togglableFireModes: gunwork.fireMode[] = [gunwork.fireMode.auto, gunwork.fireMode.semi];
	firemodeSwitchCooldown: number = .75;
	reloadType: reloadType = reloadType.mag;

	recoilPattern: Map<NumberRange, [Vector3, Vector3]> = new Map();
	recoilRegroupTime: number = 1;

	/**objects can have different penetration difficulty. this a multiplier to that, which gets subtracted from damage */
	penetrationDamageFalloff: number = 0;

	/**
	 * the color of the tracer
	 */
	tracerColor: Color3 = new Color3(0, 1, 1)

	ammo: number = 0;
	maxAmmo: number = 0;
	initialAmmo: number = 0;
	reserveAmmo: number = 0;
	/**
	 * if they reload with their ammo equal to maxAmmo, this amount is how many extra bullets are allowed.
	 * if this is 0, the mechanism is ignored
	 */
	ammoOverload: number = 0;

	/**
	 * how heavy the weapon is as a multiplier of the default character speed
	 */
	weightMultiplier: number = 0;
	/**
	 * a multiplier to spread if the character is not aiming
	 */
	spreadHipfirePenalty: number = 0;
	/**
	 * a multiplier to further increase spread if the character is moving without aiming
	 */
	spreadMovementHipfirePenalty: number = 0;
	/**
	 * how much spread is added per shot taken
	 */
	spreadUpPerShot: number = 0;
	/**
	 * calculated spread is clamped between both negative and positive of this value. keep this value above 0
	 */
	maxAllowedSpread: number = 0;
	/**
	 * how much time it takes for spread to decrease after a shot
	 */
	spreadPopTime: number = 0;
	/**
	 * how long it takes to ads
	 */
	adsLength: number = .5;
	/**
	 * how long it takes to lean
	 */
	leanLength: number = .35;
	/**
	 * time to crouch / uncrouch
	 */
	crouchTranitionTime: number = .25;
	/**
	 * time to prone / unprone
	 */
	proneTransitionTime: number = .5;

	shellPath?: string = undefined;

	constructor(public serverItemIdentification: string, 
		private pathToGun: pathLike, 
		private attachments: gunAttachmentConfig, 
		private animationIDS: gunAnimationsConfig
		){
		super(serverItemIdentification);

		this.character = Players.LocalPlayer.Character as gunwork.basicCharacter;

		this.lastPosition = this.character.GetPrimaryPartCFrame().Position;

		//get the gun model from path
		let gun = path.sure(pathToGun).Clone();

		//get the viewmodel from path
		let viewmodel = path.sure(paths.fps.standard_viewmodel).Clone() as gunwork.gunViewmodel;

		//copy gun stuff to the viewmodel
		gun.GetChildren().forEach((v) => {
			v.Parent = viewmodel;
		})

		utils.instanceUtils.unanchorAllDescendants(viewmodel);
		utils.instanceUtils.nominalizeAllDescendants(viewmodel);

		let ap = viewmodel.aimpart;
		let vm = viewmodel;

		let m0 = new Instance("Motor6D");
		m0.Part0 = ap;
		m0.Name = 'rightMotor';
		m0.Part1 = vm.rightArm;
		m0.Parent = vm;

		let m1 = new Instance("Motor6D");
		m1.Part0 = ap;
		m1.Part1 = vm.leftArm;
		m1.Name = 'leftMotor';
		m1.Parent = vm;

		let m2 = new Instance("Motor6D");
		m2.Part0 = vm.rootpart;
		m2.Part1 = ap;
		m2.Name = 'rootMotor';
		m2.Parent = vm;

		viewmodel.PrimaryPart = viewmodel.aimpart;

		//setup attachments if possible

		//load animations!

		this.viewmodel = viewmodel as gunwork.gunViewmodel;
		this.viewmodel.SetPrimaryPartCFrame(clientExposed.getCamera().CFrame);

		this.viewmodel.Parent = clientExposed.getCamera()

		for (const [name, id] of pairs(animationIDS)) {
			let anim = animationCompile.create(id)
			let final = anim.final()
			this.loadedAnimations[name] = viewmodel.controller.animator.LoadAnimation(final)

			anim.cleanUp()
		}

		if (attachments.sight) {
			let sightmodel = path.sure(attachments.sight.path).Clone() as sightModel;
			sightmodel.SetPrimaryPartCFrame(viewmodel.sightNode.CFrame)
			sightmodel.Parent = viewmodel;

			let md = new Instance('Motor6D');
			md.Part0 = viewmodel.sightNode;
			md.Part1 = sightmodel.PrimaryPart;
			md.Parent = sightmodel.PrimaryPart;

			viewmodel.aimpart.Position = sightmodel.focus.Position;
		}

		utils.instanceUtils.unanchorAllDescendants(viewmodel);
		utils.instanceUtils.nominalizeAllDescendants(viewmodel);

		this.viewmodel.Parent = undefined;

	}
	manualFire() {

		let firemode = this.togglableFireModes[this.currentFiremode];
		if (!firemode) {
			firemode = this.togglableFireModes[0];
		}

		if (tick() - this.lastFired < 60 / this.firerate[firemode]) return;

		this.fire();
	}
	fire() {
		newThread(() => {
			if (this.ammo <= 0) {this.startReload(); return;}

			this.camera = clientExposed.getCamera();
			if (!this.firePoint && !this.camera) throw `fire can not be called without a character or camera`;

			this.ammo --;
			this.lastFired = tick();

			this.lastClickIdUsed = this.currentClickId;

			this.viewmodel.audio.fire.Play()

			let controller = clientExposed.getActionController();

			this.spreadDelta += this.spreadUpPerShot;
			
			let spread = this.spreadDelta
			* (1 - this.values.aimDelta.Value * this.spreadHipfirePenalty)
			* (this.spreadMovementHipfirePenalty * this.character.Humanoid.MoveDirection.Magnitude + 1);
			

			spread = math.clamp(spread, 0, this.maxAllowedSpread);

			later(this.spreadPopTime, () => {
				this.spreadDelta -= this.spreadUpPerShot;
			})

			let firemode = this.togglableFireModes[this.currentFiremode];
			if (!firemode) {
				firemode = this.togglableFireModes[0];
			}

			let effectOrigin = this.viewmodel.barrel.muzzle.WorldPosition;

			const cases = {
				[fireMode.shotgun]: () => {
					const fireCFrame = this.cameraCFrame;

					let cframes: CFrame[] = [];

					for (let i = 0; i < this.bulletsAShot.shotgun; i++) {
						const spreadDirection = controller.crosshairController.getSpreadDirection(this.camera!);
		
						let newFireCFrame = CFrame.lookAt(fireCFrame.Position, 
							fireCFrame.Position.add(spreadDirection));

						cframes.push(newFireCFrame);

						new tracer(effectOrigin, spreadDirection, 1.5, this.tracerColor);
					}
						
		
					controller.crosshairController.pushRecoil(spread, this.recoilRegroupTime);
		
					system.remote.client.fireServer('fireMultiContext', this.serverItemIdentification, cframes);
				},
				[fireMode.auto]: () => {
					const fireCFrame = this.cameraCFrame;

					const spreadDirection = controller.crosshairController.getSpreadDirection(this.camera!);
		
					let newFireCFrame = CFrame.lookAt(fireCFrame.Position, 
						fireCFrame.Position.add(spreadDirection));

					new tracer(effectOrigin, spreadDirection, 1.5, this.tracerColor);

					controller.crosshairController.pushRecoil(spread, this.recoilRegroupTime);
		
					system.remote.client.fireServer('fireContext', this.serverItemIdentification, newFireCFrame);
				},
				[fireMode.semi]: () => {
					cases[fireMode.auto]
				},
				[fireMode.burst2]: () => {
					cases[fireMode.auto]
				},
				[fireMode.burst3]: () => {
					cases[fireMode.auto]
				},
				[fireMode.burst4]: () => {
					cases[fireMode.auto]
				}
			}

			if (this.unaimAfterShot) {
				controller.actionMap.aim(Enum.UserInputState.End);
				later(60 / this.firerate[firemode], () => {
					if (utils.peripherals.isButtonDown(controller.getKey('aim')) && !this.togglingAim) {
						controller.actionMap.aim(Enum.UserInputState.Begin);
					}
				})
				//for user convenience, make this aim them back in if they still holding the button after a bit.
			}

			if (this.loadedAnimations.pump) {
				this.loadedAnimations.pump.Play()
				this.loadedAnimations.pump.GetMarkerReachedSignal('boltForward').Connect(() => {
					this.viewmodel.audio.boltforward.Play()
				})
				this.loadedAnimations.pump.GetMarkerReachedSignal('boltBackward').Connect(() => {
					this.viewmodel.audio.boltback.Play()
				})
			}

			cases[firemode]()

			let t = tick()

			this.lastFired = t;

			let max = tableUtils.rangeUpperClamp(this.recoilPattern)!

			let recoilIndex = this.currentRecoilIndex >= 
			max? max: this.currentRecoilIndex;

			this.currentRecoilIndex ++

			let add = utils.tableUtils.firstNumberRangeContainingNumber(this.recoilPattern, recoilIndex)!;

			let pickX = random.NextNumber(math.min(add[0].X, add[1].X), math.max(add[0].X, add[1].X)) * 1;
			let pickY = random.NextNumber(math.min(add[0].Y, add[1].Y), math.max(add[0].Y, add[1].Y)) * 1;
			let pickZ = random.NextNumber(math.min(add[0].Z, add[1].Z), math.max(add[0].Z, add[1].Z)) / 2;

			this.springs.recoil.shove(new Vector3(-pickX, pickY, pickZ));

			later(this.recoilRegroupTime, () => {
				if (this.lastFired !== t) return;
				this.currentRecoilIndex --;
			});
		})
	}
	initiateSingleAnimation() {
		if (this.loadedAnimations.reloadStart) {
			this.loadedAnimations.reloadStart.Play();
			task.wait(this.loadedAnimations.reloadStart.Length - .1)
		}
	}
	loadShell() {
		if (this.shellPath) {
			let c = path.getInstance(this.shellPath) as Model;
			if (c) {
				c = c.Clone();

				c.Parent = this.viewmodel;

				let m6d = new Instance('Motor6D')
				m6d.Part0 = this.viewmodel.aimpart;
				m6d.Part1 = c.PrimaryPart;
				m6d.Parent = this.viewmodel.aimpart
			}
			else {
				throw `path ${this.shellPath} is invalid`
			}
			return c;
		}
	}
	reloadSingle() {
		system.remote.client.fireServer('reloadFeedSingleContext', this.serverItemIdentification);
		if (this.loadedAnimations.reloadFill) {
			this.loadedAnimations.reloadFill.Play();
			task.wait(this.loadedAnimations.reloadFill.Length)
		}
	}
	startReload() {
		newThread(() => {
			if (this.reloading) return;
			let reloadId = HttpService.GenerateGUID();
			this.currentReloadId = reloadId;
			this.reloading = true;
			system.remote.client.fireServer('reloadStartContext', this.serverItemIdentification);
			task.wait(this.reloadSpeed);
			if (this.reloading && this.currentReloadId && this.currentReloadId === reloadId) {
				this.finishReload();
			}
		})
	}
	finishReload() {
		if (this.reloading) {
			system.remote.client.fireServer('reloadEndContext', this.serverItemIdentification);
		}
	}
	cancelReload() {
		if (!this.reloading) return;
		this.reloading = false;
		this.currentReloadId = undefined;
		system.remote.client.fireServer('reloadCancelContext', this.serverItemIdentification);
	}
	aim(t: boolean) {
		newThread(() => {
			this.togglingAim = true
			let diff = t? this.adsLength - mathf.lerp(0, this.adsLength, this.values.aimDelta.Value): this.adsLength;

			let info = new TweenInfo(diff, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);

			TweenService.Create(this.values.aimDelta, info, {
				Value: t? 1: 0
			}).Play();

			task.wait(diff);

			this.togglingAim = false

			this.aiming = t;
		})
		
	}
	lean(t: 1 | 0 | -1) {
		newThread(() => {
			let info = new TweenInfo(this.leanLength);
			let val = new CFrame();
			let camval = new CFrame();

			if (t === this.leanDirection) {
				t = 0;
			}

			this.leanDirection = t;

			if (t === 1) {
				val = this.staticOffsets.leanRight;
				camval = this.staticOffsets.leanRightCamera;
			}
			else if (t === -1) {
				val = this.staticOffsets.leanLeft;
				camval = this.staticOffsets.leanLeftCamera;
			}

			TweenService.Create(this.values.leanOffsetViewmodel, info, {
				Value: val
			}).Play()
			
			TweenService.Create(this.values.leanOffsetCamera, info, {
				Value: camval
			}).Play()
		})
	}
	changeStance(t: 1 | 0 | -1) {
		newThread(() => {
			if (t === this.stance) {
				if (t === 0) {
					t = 1;
				}
				else if (t === -1) {
					t = 0;
				}
			}
	
			let value = t === 1? new CFrame(): t === 0? this.staticOffsets.crouchOffset: this.staticOffsets.proneOffset;
			let info = new TweenInfo(this.stance === -1 || t === -1? this.proneTransitionTime: this.crouchTranitionTime);
	
			TweenService.Create(this.values.stanceOffset, info, {
				Value: value
			}).Play()
	
			this.stance = t;
			if (t === -1) {
				this.proneChanging = true;
				task.wait(info.Time)
				this.proneChanging = false;
			}
		})
	}
    update(dt: number) {
		
		if (!this.viewmodel.PrimaryPart) return;

		this.viewmodel.aimpart.Anchored = true;

		let firemode = this.togglableFireModes[this.currentFiremode];
		if (!firemode) {
			firemode = this.togglableFireModes[0];
		}

		newThread(() => {
			if (!this.fireButtonDown) return;

			if (firemode === fireMode.semi || firemode === fireMode.shotgun) return //these will be handled separately

			this.manualFire()
			//the server will verify firemode separately. fire needs only be called once
			/**
			switch (firemode) {
				case fireMode.auto:
					this.fire();
					break;
				case fireMode.burst2:
					for (let i = 0; i < 2; i++) {
						this.fire();
						task.wait(this.firerate.burst4);
					}
					break;
				case fireMode.burst3:
					for (let i = 0; i < 3; i++) {
						this.fire();
						task.wait(this.firerate.burst4);
					}
					break;
				case fireMode.burst4:
					for (let i = 0; i < 4; i++) {
						this.fire();
						task.wait(this.firerate.burst4);
					}
					break;
				case fireMode.semi:
					this.fire();
					break;
				default:
					break;
			}*/
		})

		this.cframes.idle = this.viewmodel.offsets.idle.Value;

		let movedirection = this.character.Humanoid.MoveDirection;

		const camera = clientExposed.getCamera();

		let idleOffset = this.cframes.idle.Lerp(new CFrame(0, 0, this.attachments.sight? -this.attachments.sight.zOffset: 0), this.values.aimDelta.Value);

		let [cx, cy, cz] = camera.CFrame.ToOrientation();

		let t = tick();

		let velocity = this.character.PrimaryPart!.AssemblyLinearVelocity;

		let roundedMagXZ = math.round(new Vector2(velocity.X, velocity.Z).Magnitude)

		let f = t * roundedMagXZ / 1.5 + tick();

		let tx = math.cos(f) * .05;
		let ty = math.abs(math.sin(f)) * .05;
		
		this.cframes.viewmodelBob = this.cframes.viewmodelBob.Lerp(
			new CFrame(new Vector3(tx, ty).mul(1 - this.values.aimDelta.Value + (roundedMagXZ / 50 * (1 - this.values.aimDelta.Value)))),
			.1
		)

		let recoilUpdated = this.springs.recoil.update(dt);

		this.viewmodel.SetPrimaryPartCFrame(
			new CFrame(camera.CFrame.Position)
			.mul(this.values.stanceOffset.Value)
			.mul(CFrame.fromOrientation(cx, cy, cz))
			.mul(idleOffset)
			.mul(this.values.leanOffsetCamera.Value)
			.mul(this.values.leanOffsetViewmodel.Value)
			.mul(this.cframes.viewmodelBob)
			.mul(new CFrame(0, 0, recoilUpdated.Z))
		);

		camera.CFrame = new CFrame(camera.CFrame.Position)
			.mul(this.values.stanceOffset.Value)
			.mul(CFrame.fromOrientation(cx, cy, cz))
			.mul(this.values.leanOffsetCamera.Value)
			.mul(CFrame.Angles(math.rad(recoilUpdated.Y), math.rad(recoilUpdated.X), 0));

		this.cameraCFrame = camera.CFrame;

		this.viewmodel.Parent = camera;

		this.character.Humanoid.WalkSpeed = clientExposed.getBaseWalkSpeed() 
			* (this.stance === -1? this.multipliers.speed.prone: (this.stance === 0? this.multipliers.speed.crouch: 1))

		let generalSettings = getClientConfig().settings.general
		let lerpedADS = mathf.lerp(generalSettings.sensitivity, generalSettings.adsSensitivity, this.values.aimDelta.Value);

		UserInputService.MouseDeltaSensitivity = lerpedADS;

		if (this.loadedAnimations.idle && !this.loadedAnimations.idle.IsPlaying) {
			this.loadedAnimations.idle.Play()
		}
    }
}