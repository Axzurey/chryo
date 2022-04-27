import path from "shared/athena/path";
import item from "shared/base/item";
import paths from "shared/constants/paths";
import clientExposed from "shared/middleware/clientExposed";
import gunwork, { gunAnimationsConfig, gunAttachmentConfig, sightModel } from "shared/types/gunwork";
import utils, { newThread } from 'shared/athena/utils';
import { Players, TweenService } from "@rbxts/services";
import animationCompile from "shared/athena/animate";
import system from "shared/zero/system";

export default class gun extends item {

	//absolute
	typeIdentifier = gunwork.itemTypeIdentifier.gun

	//internal

	connections: Record<string, RBXScriptConnection> = {}

	viewmodel: gunwork.gunViewmodel

	camera?: Camera;
	character: gunwork.basicCharacter;
	
	firePoint?: BasePart;

	lastFired: number = 0;

	currentFiremode: number = 0;
	lastFiremodeSwitch: number = 0;

	lastRecoil: number = 0;
	currentRecoilIndex: number = 0;
	
	lastReload: number = 0;
	/**
	 * this value is increased with each shot taken and is multiplied with unads spread
	 */
	spreadDelta: number = 0;

	sprinting: boolean = false;
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

	cframes = {
		idle: new CFrame(),
		aimOffset: new CFrame(),
		sprintOffset: new CFrame(),
		cameraBob: new CFrame(),
		viewmodelBob: new CFrame(),
	}

	loadedAnimations: {idle: AnimationTrack}

	staticOffsets = {
		leanRight: CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-25)),
		leanLeft: CFrame.fromEulerAnglesYXZ(0, 0, math.rad(25)),
		leanRightCamera: new CFrame(.7, 0, 0).mul(CFrame.fromEulerAnglesYXZ(0, 0, math.rad(-10))),
		leanLeftCamera: new CFrame(-.7, 0, 0).mul(CFrame.fromEulerAnglesYXZ(0, 0, math.rad(10))),
		crouchOffset: new CFrame(0, -1, 0),
		proneOffset: new CFrame(0, -3, 0),
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

	//config

	spread: number = 0;

	firerate = {
		auto: 0,
		semi: 0,
		burst2: 0,
		burst3: 0,
		burst4: 0,
		shotgun: 0
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

	recoilPattern: {x: number, y: number}[] = [];
	recoilRegroupTime: number = 1;

	/**objects can have different penetration difficulty. this a multiplier to that, which gets subtracted from damage */
	penetrationDamageFalloff: number = 0;

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

		let idleanim = animationCompile.create(animationIDS.idle).final();

		this.viewmodel.Parent = clientExposed.getCamera()

		this.loadedAnimations = {
			idle: viewmodel.controller.animator.LoadAnimation(idleanim)
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
	fire() {
		newThread(() => {
			if (!this.firePoint && !this.camera) throw `fire can not be called without a character or camera`
			const fireCFrame = this.camera? this.camera.CFrame: (this.firePoint as BasePart).CFrame;
		})
	}
	aim(t: boolean) {
		newThread(() => {
			let info = new TweenInfo(this.adsLength, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);

			TweenService.Create(this.values.aimDelta, info, {
				Value: t? 1: 0
			}).Play();

			task.wait(this.adsLength);

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

		this.cframes.idle = this.viewmodel.offsets.idle.Value;

		let movedirection = this.character.Humanoid.MoveDirection;

		const camera = clientExposed.getCamera();

		let idleOffset = this.cframes.idle.Lerp(new CFrame(0, 0, this.attachments.sight? -this.attachments.sight.zOffset: 0), this.values.aimDelta.Value);

		let [cx, cy, cz] = camera.CFrame.ToOrientation();

		let t = tick();

		let velocity = this.character.PrimaryPart!.AssemblyLinearVelocity;

		let roundedMagXZ = math.round(new Vector2(velocity.X, velocity.Z).Magnitude)

		let f = ((t * roundedMagXZ / 1.5 + tick()) * (roundedMagXZ === 0? 1 - this.values.aimDelta.Value: 1));

		let tx = math.cos(f) * .05;
		let ty = math.abs(math.sin(f)) * .05;
		
		this.cframes.viewmodelBob = this.cframes.viewmodelBob.Lerp(
			new CFrame(new Vector3(tx, ty).mul(1 - this.values.aimDelta.Value + .1)),
			.1
		)

		this.viewmodel.SetPrimaryPartCFrame(
			new CFrame(camera.CFrame.Position)
			.mul(this.values.stanceOffset.Value)
			.mul(CFrame.fromOrientation(cx, cy, cz))
			.mul(idleOffset)
			.mul(this.values.leanOffsetCamera.Value)
			.mul(this.values.leanOffsetViewmodel.Value)
			.mul(this.cframes.viewmodelBob)
		);

		camera.CFrame = new CFrame(camera.CFrame.Position)
			.mul(this.values.stanceOffset.Value)
			.mul(CFrame.fromOrientation(cx, cy, cz))
			.mul(this.values.leanOffsetCamera.Value)

		this.viewmodel.Parent = camera;

		this.character.Humanoid.WalkSpeed = clientExposed.getBaseWalkSpeed() 
			* (this.stance === -1? this.multipliers.speed.prone: (this.stance === 0? this.multipliers.speed.crouch: 1))

		if (!this.loadedAnimations.idle.IsPlaying) {
			this.loadedAnimations.idle.Play()
		}
    }
}