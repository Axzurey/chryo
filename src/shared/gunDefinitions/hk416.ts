import gun from "shared/extended/gun";
import { fireMode } from "shared/types/gunwork";

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

    g.firerate = {
        burst2: 600,
        auto: 800,
        burst3: 600,
        burst4: 600,
        shotgun: 1000,
        semi: 800
    }

    g.togglableFireModes = [fireMode.auto, fireMode.semi]

    g.reloadSpeed = 1.5;

    return g;
}