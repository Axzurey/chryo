import { tableUtils } from "shared/athena/utils";
import { fireMode } from "shared/types/gunwork";

namespace itemConfig {
    const gunData = {
        holographic: {
            name: 'holographic',
            path: 'ReplicatedStorage//sights//holographic&class=Model',
            zOffset: .13
        },
        hk416: {
            firerate: {
                burst2: 600,
                auto: 500,
                burst3: 600,
                burst4: 600,
                shotgun: 1000,
                semi: 800
            },
            maxAmmo: 9999,
            reserveAmmo: 9999,
            togglableFireModes: [fireMode.auto, fireMode.semi],
            reloadSpeed: 1.5,
            recoilRegroupTime: 1.5,
            spreadHipfirePenalty: 1.1,
            spreadMovementHipfirePenalty: 1.2,
            spreadDelta: 1.15,
            spreadPopTime: 1.5,
            spreadUpPerShot: .25,
            maxAllowedSpread: 35,
            recoilPattern: tableUtils.toMap([
                new NumberRange(0, 10),
                new NumberRange(10, 20),
                new NumberRange(20, 31)
            ], [
                [new Vector3(.2, .3, .2), new Vector3(.7, 1, .2)],
                [new Vector3(.2, .7, .3), new Vector3(.6, .8, .3)],
                [new Vector3(.7, .9, .2), new Vector3(.5, .5, .4)]
            ])
        }
    };

    const cleanables = ['path']

    export function getItemConfig<A extends keyof typeof gunData, B extends keyof typeof gunData[A]>(itemName: A, property: B) {
        return gunData[itemName][property];
    }

    export function getProperties<A extends keyof typeof gunData>(itemName: A) {
        return gunData[itemName];
    }

    export function itemClean<A extends {[key: string | number | symbol]: any}>(d: A) {
        cleanables.forEach((v) => {
            if (d[v]) {
                delete d[v];
            }
        })
        return d;
    }
}

export = itemConfig;