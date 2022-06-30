import serverItem from "../serverBase/serverItem";
import rocaster, { castResult } from 'shared/entities/rocast';
import { newThread } from "shared/modules/utils";
import space from "shared/entities/space";
import examine, { examineHitLocation } from "server/serverBase/examine";
import { bulletHoleLocation, itemTypeIdentifier, reloadType } from "shared/gunwork";
import { entityType } from "shared/constants/zeroDefinitions";
import human from "shared/entities/entityClasses/human";
import image from "shared/classes/image";
import system from "shared/entities/system";
import user from "server/serverClasses/user";

export default class serverGun extends serverItem {
    //internal

    ammo: number = 0;
    maxAmmo: number = 0;
    reserveAmmo: number = 0;
    magazineOverload: number = 0;

    source: {
        images?: Record<bulletHoleLocation, image>
    } = {};

    damage: {
        body: number,
        head: number,
        limb: number
    } = {
        body: 0,
        head: 0,
        limb: 0,
    };
    /**
     * how long it should take to reload
     */
    reloadSpeed: number = 1.5;
    /**
     * the least time since startreload it will accept
     */
    reloadSpeedMin: number = 1;
    /**
     * the most time since startreload it will accept
     */
    reloadSpeedMax: number = 3;

    reloadStarted: number = tick();

    reloading: boolean = false;

    reloadType: reloadType = reloadType.shell;

    constructor(serverId: string, public characterClass: user) {
        super(serverId);
        this.ammo = 10
        this.userEquipped = true
        this.typeIdentifier = itemTypeIdentifier.gun

        this.damage = {
            head: 1000,
            body: 32,
            limb: 20
        }
    }
    getRemotes() {
        
    }
    startReload() {
        if (this.reloading) return;
        if (this.maxAmmo - (this.ammo + this.magazineOverload) <= 0) return; //magazine is already full
        this.reloadStarted = tick();

        this.reloading = true;
    }
    cancelReload() {
        this.reloading = false;
    }
    lastFeed: number = tick()
    feedSingle() {
        if (this.reloadType === reloadType.shell) {
            if (this.ammo >= this.maxAmmo) return;
            if (tick() - this.lastFeed < .15) return;
            this.lastFeed = tick()
            this.ammo += 1
        }
    }
    finishReload() {
        if (this.maxAmmo - (this.ammo + this.magazineOverload) <= 0) return; //magazine is already full
        if (!this.reloading) return;

        let diff = tick() - this.reloadStarted;

        if (diff > this.reloadSpeedMax || diff < this.reloadSpeedMin ) return //reload took too short or too long!

        let ammoLeftInReserve = this.reserveAmmo;

        let ammoMaxInMag = this.maxAmmo + this.magazineOverload;

        let current = this.maxAmmo;

        let ammoDifference = ammoMaxInMag - current;

        if (ammoLeftInReserve >= ammoDifference) {
            //they have enough to reload a full mag
            ammoLeftInReserve -= ammoDifference;
            this.ammo = ammoMaxInMag;
        }
        else {
            //they don't have enough to reload a full mag
            this.ammo += ammoLeftInReserve;
            this.reserveAmmo = 0
        }
    }
    determineWhatToDoWithImpact(hit: [BasePart, Vector3, boolean, castResult | undefined] | undefined, v: CFrame) {
        if (hit) {
            let rx = hit[3]
            if (rx) {
                rx.subHits.forEach((vx) => {
                    this.determineWhatToDoWithImpact([vx.instance, vx.position, false, undefined], v);
                })
            }
            
            if (hit[0].Mass < 1) {
                if (hit[0].Anchored) return;

                let z = hit[0].GetNetworkOwner();
                let r = hit[0].GetConnectedParts();

                if (r.size() > 1) { return }; //the part is welded to something anchored, we can't fling it! //for some reason, r has hit[0] in it. ignore i guess.

                if (!z) {
                    hit[0].ApplyImpulseAtPosition(v.LookVector, hit[1])
                }
                else {
                    system.remote.server.fireClient('clientFlingBasepart', z, hit[0], hit[1], v.LookVector)
                }
            }
            else {
                if (hit[2] && hit[3]) {
                    this.source.images!.normal.spawn(hit[3].position, hit[3].normal, 1);
                }
            }
        }
    }
    fireMulti(cameraCFrames: CFrame[]) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;
        if (!this.characterClass.isAlive()) return;

        this.ammo --;
        
        cameraCFrames.forEach((v) => {
            let hit = this.handleFire(v)
            this.determineWhatToDoWithImpact(hit, v)
        })
    }
    fire(cameraCFrame: CFrame) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;

        if (!this.characterClass.isAlive()) return;

        this.ammo --;

        let hit = this.handleFire(cameraCFrame)
        this.determineWhatToDoWithImpact(hit, cameraCFrame)
    }
    handleFire(cameraCFrame: CFrame): [BasePart, Vector3, boolean, castResult] | undefined {

        if (!this.source.images) return;

        let caster = new rocaster({
            from: cameraCFrame.Position,
            direction: cameraCFrame.LookVector,
            maxDistance: 999,
            ignore: [this.getUser()!.Character as Model],
            ignoreNames: ['HumanoidRootPart', 'imageBackdrop'],
            debug: false
        });

        let castResult = caster.cast({
            canPierce: (result) => {
                if (result.Instance.Mass < 1) {
                    return true;
                }
                return undefined
                /*return {
                    damageMultiplier: 1,
                    weight: 1
                }*/
            }
        });

        if (castResult) {
            let entity = space.query.findFirstEntityWithVesselThatContainsInstance(castResult.instance);
            let nominal = true
            if (entity && space.query.entityIsThatIfOfType<human>(entity, entityType.human) ) {
                let location = examineHitLocation(castResult.instance);
                if (location === examine.hitLocation.head) {
                    entity.takeDamage(this.damage.head);
                }
                else if (location === examine.hitLocation.body) {
                    entity.takeDamage(this.damage.body);
                }
                else {
                    entity.takeDamage(this.damage.limb);
                }
                nominal = false
            }
            return [castResult.instance, castResult.position, nominal, castResult]
        }
    }
    equip() {
        newThread(() => {
            if (this.canBeEquipped && this.canUserEquip) {
                this.userEquipping = true;
                task.wait(this.equipTime);
                this.userEquipped = true;
            }
        })
    }
}