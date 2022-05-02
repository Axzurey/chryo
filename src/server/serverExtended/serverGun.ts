import serverItem from "../serverBase/serverItem";
import rocaster from 'shared/zero/rocast';
import { newThread } from "shared/athena/utils";
import space from "shared/zero/space";
import examine, { examineHitLocation } from "server/serverBase/examine";
import { itemTypeIdentifier } from "shared/types/gunwork";

export default class serverGun extends serverItem {
    //internal

    ammo: number = 0;
    maxAmmo: number = 0;
    reserveAmmo: number = 0;
    magazineOverload: number = 0;

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
    fire(cameraCFrame: CFrame) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;

        this.ammo --;

        print('start')

        let caster = new rocaster({
            from: cameraCFrame.Position,
            direction: cameraCFrame.LookVector,
            maxDistance: 999,
            ignore: [this.getUser()!.Character as Model],
            ignoreNames: ['HumanoidRootPart'],
            debug: true
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
            print('hit some')
            let entity = space.query.findFirstEntityWithVesselThatContainsInstance(castResult.instance);
            print('entity is', entity)
            if (entity && space.query.entityHasPropertyOfType(entity, 'health', 'number')) {
                let location = examineHitLocation(castResult.instance);
                if (location === examine.hitLocation.head) {
                    entity.health -= this.damage.head;
                }
                else if (location === examine.hitLocation.body) {
                    entity.health -= this.damage.body;
                }
                else {
                    entity.health -= this.damage.limb;
                }
                print(entity.health, 'damaged!')
            }
        }
        else {
            print('hit none')
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