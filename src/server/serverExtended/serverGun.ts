import serverItem from "../serverBase/serverItem";
import rocaster from 'shared/zero/rocast';

export default class serverGun extends serverItem {
    constructor(serverId: string) {
        super(serverId);
    }
    fire(from: Vector3, direction: Vector3) {
        let caster = new rocaster({
            from: from,
            direction: direction,
            maxDistance: 999,
            ignore: []
        });

        let result = caster.cast({
            canPierce: (result) => {
                return {
                    damageMultiplier: 1,
                    weight: 1
                }
            }
        })
    }
}