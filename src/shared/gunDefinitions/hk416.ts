import gun from "shared/extended/gun";
import itemConfig, { itemClean } from "shared/global/itemConfig";

const gunIdentifier = 'hk416';

export default function hk416_definition(id: string) {
    let g = new gun(id, 'ReplicatedStorage//guns//hk416&class=Model', {
        sight: {
            name: 'holographic',
            path: 'ReplicatedStorage//sights//holographic&class=Model',
            zOffset: .13
        }
    }, {
        idle: 'rbxassetid://9335189959'
    });

    for (let [p, v] of pairs(itemClean(itemConfig.getProperties(gunIdentifier)))) {
        g[p] = v as any;
    }

    return g;
}