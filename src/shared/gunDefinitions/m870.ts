import gun from "shared/extended/gun";
import itemConfig, { itemClean } from "shared/global/itemConfig";

const gunIdentifier = 'm870';

export default function m870_definition(id: string) {
    let g = new gun(id, 'ReplicatedStorage//guns//m870&class=Model', {
        sight: {
            name: 'holographic',
            path: 'ReplicatedStorage//sights//holographic&class=Model',
            zOffset: .13
        }
    }, {
        idle: 'rbxassetid://9708823676',
        pump: 'rbxassetid://9708836982',
        reloadStart: 'rbxassetid://10025405779',
        reloadFill: 'rbxassetid://10025403248'
    });

    for (let [p, v] of pairs(itemClean(itemConfig.getProperties(gunIdentifier)))) {
        g[p] = v as never;
    }

    return g;
}