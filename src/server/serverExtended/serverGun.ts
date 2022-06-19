import serverItem from "../serverBase/serverItem";
import rocaster, { castResult } from 'shared/zero/rocast';
import { newThread } from "shared/athena/utils";
import space from "shared/zero/space";
import examine, { examineHitLocation } from "server/serverBase/examine";
import { bulletHoleLocation, itemTypeIdentifier } from "shared/types/gunwork";
import { entityType } from "shared/zero/define/zeroDefinitions";
import human from "shared/zero/entities/human";
import image from "shared/classes/image";
import breach from "server/serverMechanics/breach";
import { e } from "shared/athena/mathf";
import system from "shared/zero/system";

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

    constructor(serverId: string) {
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
    finishReload() {
        if (this.maxAmmo - (this.ammo + this.magazineOverload) <= 0) return; //magazine is already full
        if (!this.reloading) return;

        let diff = tick() - this.reloadStarted;

        if (diff > this.reloadSpeedMax || diff < this.reloadSpeedMin ) return //reload took too short or too long!
    }
    fireMulti(cameraCFrames: CFrame[]) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;

        this.ammo --;
        
        cameraCFrames.forEach((v) => {
            let hit = this.handleFire(v)
            if (hit) {
                if (hit[0].Mass < 1) {
                    let z = hit[0].GetNetworkOwner()
                    if (!z) {
                        hit[0].ApplyImpulseAtPosition(v.LookVector, hit[1])
                    }
                    else {
                        system.remote.server.fireClient('clientFlingBasepart', z, hit[0], hit[1], v.LookVector)
                    }
                }
                else {
                    if (hit[2]) {
                        this.source.images!.normal.spawn(hit[3].position, hit[3].normal, 1);
                    }
                }
            }
        })
    }
    fire(cameraCFrame: CFrame) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;

        this.ammo --;

        this.handleFire(cameraCFrame)
    }
    handleFire(cameraCFrame: CFrame): [BasePart, Vector3, boolean, castResult] | undefined {

        if (!this.source.images) return;

        let caster = new rocaster({
            from: cameraCFrame.Position,
            direction: cameraCFrame.LookVector,
            maxDistance: 999,
            ignore: [this.getUser()!.Character as Model],
            ignoreNames: ['HumanoidRootPart'],
            debug: false
        });

        let castResult = caster.cast({
            canPierce: (result) => {
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