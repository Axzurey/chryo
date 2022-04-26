import serverItem from "../serverBase/serverItem";
import rocaster from 'shared/zero/rocast';
import { newThread } from "shared/athena/utils";

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
    fire(from: Vector3, direction: Vector3) {
        if (!this.userEquipped) return;
        if (this.reloading) return;
        if (this.ammo <= 0) return;

        this.ammo --;
        let caster = new rocaster({
            from: from,
            direction: direction,
            maxDistance: 999,
            ignore: []
        });

        let castResult = caster.cast({
            canPierce: (result) => {
                return {
                    damageMultiplier: 1,
                    weight: 1
                }
            }
        })

        if (!castResult) return;
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