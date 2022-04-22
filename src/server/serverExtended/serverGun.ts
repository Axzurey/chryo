import serverItem from "../serverBase/serverItem";
import rocaster from 'shared/zero/rocast';
import { newThread } from "shared/athena/utils";

export default class serverGun extends serverItem {
    constructor(serverId: string) {
        super(serverId);
    }
    getRemotes() {
        
    }
    fire(from: Vector3, direction: Vector3) {
        if (!this.userEquipped) return;
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