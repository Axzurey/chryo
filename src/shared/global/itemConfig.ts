import hk416_config from "shared/itemConfig/hk416";
import holographic_config from "shared/itemConfig/holographic";

namespace itemConfig {
    const gunData = {
        holographic: holographic_config,
        hk416: hk416_config
    };

    const cleanables = ['path'] as const

    export function getItemConfig<A extends keyof typeof gunData, B extends keyof typeof gunData[A]>(itemName: A, property: B) {
        return gunData[itemName][property];
    }

    export function getProperties<A extends keyof typeof gunData>(itemName: A) {
        return gunData[itemName];
    }

    export function itemClean<A extends {[key: string | number | symbol]: any}>(d: A): Omit<A, typeof cleanables[number]> {
        cleanables.forEach((v) => {
            if (d[v]) {
                delete d[v];
            }
        })
        return d;
    }
}

export = itemConfig;