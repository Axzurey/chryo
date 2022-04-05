import path from "shared/athena/path";
import item from "shared/base/item";
import paths from "shared/constants/paths";
import clientExposed from "shared/middleware/clientExposed";
import gunwork from "shared/types/gunwork";
import utils, { newThread } from 'shared/athena/utils';
import { TweenService } from "@rbxts/services";

export default class gun extends item {

	//absolute
	typeIdentifier = gunwork.itemTypeIdentifier.gun

	//internal

	connections: Record<string, RBXScriptConnection> = {}

	viewmodel: gunwork.viewmodel

	camera?: Camera;
	character?: Model;
	
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
		leanOffset: new CFrame(),
		aimOffset: new CFrame(),
		sprintOffset: new CFrame(),
	}

	values = {
        aimDelta: new Instance("NumberValue"),
    }

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
	constructor(serverItemIndentification: string, pathToGun: pathLike) {
		super(serverItemIndentification);

		//get the gun model from path
		let gun = path.sure(pathToGun).Clone();

		//get the viewmodel from path
		let viewmodel = path.sure(paths.fps.standard_viewmodel).Clone() as gunwork.viewmodel;

		//copy gun stuff to the viewmodel
		gun.GetChildren().forEach((v) => {
			v.Parent = viewmodel;
			if (v.Name === 'aimpart') {
				viewmodel.PrimaryPart = v as BasePart;
				print('set aimpart')
			}
		})


		print(viewmodel.GetChildren())
		utils.instanceUtils.anchorAllChildren(viewmodel);
		utils.instanceUtils.nominalizeAllChildren(viewmodel);

		//setup attachments if possible

		//connect motor6ds

		//set viewmodel far below!

		//load animations!

		this.viewmodel = viewmodel as gunwork.gunViewmodel;
		this.viewmodel.SetPrimaryPartCFrame(new CFrame(0, 10000, 0))
	}
	fire() {
		newThread(() => {
			if (!this.firePoint && !this.camera) throw `fire can not be called without a character or camera`
			const fireCFrame = this.camera? this.camera.CFrame: (this.firePoint as BasePart).CFrame;
		})
	}
	aim(t: boolean) {
		newThread(() => {
			let calculated = math.abs(this.values.aimDelta.Value - .5)
			let info = new TweenInfo(this.adsLength - calculated, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);

			TweenService.Create(this.values.aimDelta, info, {
				Value: t? 1: 0
			});

			task.wait(this.adsLength);

			this.aiming = t;
		})
	}
    update(dt: number) {
		if (!this.viewmodel.PrimaryPart) return;
        //todo
		const camera = clientExposed.getCamera();

		let idleOffset = this.cframes.idle.Lerp(new CFrame(), this.values.aimDelta.Value);

		let finalCameraCframe = camera.CFrame.mul(idleOffset);

		this.viewmodel.SetPrimaryPartCFrame(finalCameraCframe);

		this.viewmodel.Parent = camera;
    }
}